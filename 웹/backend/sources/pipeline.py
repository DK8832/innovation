"""수집 → 정규화 → 변경 감지 → 검토 큐.

핵심 규칙: **수집한 값을 exams.json에 자동으로 반영하지 않는다.**
틀린 날짜 하나가 수험생이 시험을 통째로 놓치게 만들기 때문에,
사람이 확인한 뒤에만 반영한다. 이 모듈은 "무엇이 달라졌는지"까지만 만든다.
"""
import json
import logging
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional

from . import normalize, public_api

logger = logging.getLogger("sources.pipeline")

DATA_DIR = Path(__file__).parent.parent / "data"
EXAMS_PATH = DATA_DIR / "exams.json"
REVIEW_PATH = DATA_DIR / "review_queue.json"
SYNC_STATE_PATH = DATA_DIR / "sync_state.json"

# 비교할 날짜 필드
DATE_FIELDS = ("apply_start", "apply_end", "exam_start", "exam_end", "result_date")


def _load_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    try:
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, OSError) as exc:
        logger.warning("%s 를 읽지 못해 기본값을 씁니다: %s", path.name, exc)
        return default


def _save_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    try:
        with open(tmp, "w", encoding="utf-8") as f:
            json.dump(payload, f, ensure_ascii=False, indent=2)
        tmp.replace(path)
    finally:
        if tmp.exists():
            try:
                tmp.unlink()
            except OSError:
                pass


def load_exams() -> Dict[str, Any]:
    return _load_json(EXAMS_PATH, {"exams": []})


def load_review_queue() -> List[Dict[str, Any]]:
    return _load_json(REVIEW_PATH, [])


def load_sync_state() -> Dict[str, Any]:
    return _load_json(
        SYNC_STATE_PATH,
        {"last_run": None, "ok": None, "reason": "아직 한 번도 동기화하지 않았습니다", "rows": 0},
    )


def _session_key(session: Dict[str, Any]) -> str:
    return f"{session.get('round', '')}|{session.get('phase', '')}"


def diff_sessions(
    exam_name: str,
    exam_id: str,
    current: List[Dict[str, Any]],
    proposed: List[Dict[str, Any]],
) -> List[Dict[str, Any]]:
    """현재 데이터와 수집 데이터를 비교해 검토가 필요한 항목만 만든다."""
    changes: List[Dict[str, Any]] = []
    current_by_key = {_session_key(s): s for s in current}

    for prop in proposed:
        key = _session_key(prop)
        cur = current_by_key.get(key)

        if cur is None:
            changes.append(
                {
                    "exam_id": exam_id,
                    "exam_name": exam_name,
                    "change_type": "new_session",
                    "session_key": key,
                    "current": None,
                    "proposed": prop,
                    "fields": [f for f in DATE_FIELDS if prop.get(f)],
                }
            )
            continue

        differing = [
            f for f in DATE_FIELDS if prop.get(f) is not None and cur.get(f) != prop.get(f)
        ]
        if differing:
            changes.append(
                {
                    "exam_id": exam_id,
                    "exam_name": exam_name,
                    "change_type": "date_changed",
                    "session_key": key,
                    "current": {f: cur.get(f) for f in differing},
                    "proposed": {f: prop.get(f) for f in differing},
                    "fields": differing,
                }
            )

    return changes


def match_exam(exam: Dict[str, Any], collected: Dict[str, Dict[str, Any]]) -> Optional[str]:
    """우리 종목과 API 종목명을 잇는다. 정확히 같거나 포함 관계일 때만 인정한다.

    느슨하게 매칭하면 엉뚱한 종목의 날짜를 가져다 붙이게 되므로 일부러 보수적으로 둔다.
    """
    name = exam.get("name", "").strip()
    if not name:
        return None
    if name in collected:
        return name
    # '컴퓨터활용능력' 처럼 급수가 붙어 오는 경우까지만 허용
    candidates = [k for k in collected if k.startswith(name) or name.startswith(k)]
    if len(candidates) == 1:
        return candidates[0]
    return None


def run_sync(impl_year: int, key: Optional[str] = None) -> Dict[str, Any]:
    """한 번 동기화한다. exams.json은 절대 수정하지 않고 검토 큐만 갱신한다."""
    started = datetime.now().isoformat(timespec="seconds")
    result = public_api.fetch_schedules(impl_year=impl_year, key=key)

    state: Dict[str, Any] = {
        "last_run": started,
        "ok": result.ok,
        "reason": result.reason,
        "rows": len(result.rows),
        "impl_year": impl_year,
    }

    if not result.ok:
        _save_json(SYNC_STATE_PATH, state)
        logger.warning("동기화 실패: %s", result.reason)
        return {"state": state, "changes": []}

    collected = normalize.normalize_rows(result.rows)
    exams = load_exams().get("exams", [])

    all_changes: List[Dict[str, Any]] = []
    matched = 0
    for exam in exams:
        api_name = match_exam(exam, collected)
        if api_name is None:
            continue
        matched += 1
        all_changes.extend(
            diff_sessions(
                exam_name=exam.get("name", ""),
                exam_id=exam.get("id", ""),
                current=exam.get("sessions", []),
                proposed=collected[api_name]["sessions"],
            )
        )

    for change in all_changes:
        change["detected_at"] = started
        change["source"] = "data.go.kr / 한국산업인력공단 국가자격 시험일정"

    state["matched_exams"] = matched
    state["collected_names"] = len(collected)
    state["changes"] = len(all_changes)

    _save_json(REVIEW_PATH, all_changes)
    _save_json(SYNC_STATE_PATH, state)
    logger.info(
        "동기화 완료: 수집 %d종목, 매칭 %d종목, 검토 대기 %d건",
        len(collected),
        matched,
        len(all_changes),
    )
    return {"state": state, "changes": all_changes}
