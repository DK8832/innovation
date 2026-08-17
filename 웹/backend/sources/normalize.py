"""공공 API 응답을 우리 exams.json 스키마로 변환한다.

⚠️ 이 모듈은 날짜를 절대 추론하지 않는다. API가 준 값을 형식만 바꿔 옮긴다.
   값이 없으면 None으로 남긴다 (그럴듯한 값을 채워 넣지 않는다).
"""
import logging
import re
from typing import Any, Dict, List, Optional

logger = logging.getLogger("sources.normalize")

# 종목명이 담긴 필드명이 문서마다 다르게 표기되어 있어 후보를 순서대로 시도한다.
NAME_KEYS = ("jmNm", "jmfldnm", "jmNm1", "seriesNm", "jmName")
CODE_KEYS = ("jmCd", "jmcd", "jmCode")
ROUND_KEYS = ("implSeq", "description", "implSeqNm", "qualgbNm")

_DATE_RE = re.compile(r"^(\d{4})[-.]?(\d{2})[-.]?(\d{2})$")


def to_iso_date(value: Any) -> Optional[str]:
    """20260720 / 2026-07-20 / 2026.07.20 → '2026-07-20'. 해석 불가면 None."""
    if value is None:
        return None
    text = str(value).strip()
    if not text or text in ("0", "null", "None"):
        return None
    m = _DATE_RE.match(text)
    if not m:
        logger.debug("날짜 형식을 해석하지 못했습니다: %r", text)
        return None
    year, month, day = m.groups()
    # 형식만 맞고 값이 말이 안 되면(13월 등) 버린다.
    if not (1 <= int(month) <= 12 and 1 <= int(day) <= 31):
        logger.warning("범위를 벗어난 날짜라 버립니다: %r", text)
        return None
    return f"{year}-{month}-{day}"


def _pick(row: Dict[str, Any], keys) -> Optional[str]:
    for k in keys:
        v = row.get(k)
        if v not in (None, "", "null"):
            return str(v).strip()
    return None


def row_to_sessions(row: Dict[str, Any]) -> List[Dict[str, Any]]:
    """API 한 줄(한 회차)을 필기/실기 세션으로 분리한다.

    날짜가 하나도 없는 단계는 세션으로 만들지 않는다 — 빈 껍데기를 만들면
    캘린더에 '일정 있음'처럼 보이는 유령 항목이 생기기 때문이다.
    """
    round_label = _pick(row, ROUND_KEYS) or "회차 미상"
    sessions: List[Dict[str, Any]] = []

    for phase, prefix in (("필기", "doc"), ("실기", "prac")):
        parsed = {
            "apply_start": to_iso_date(row.get(f"{prefix}RegStartDt")),
            "apply_end": to_iso_date(row.get(f"{prefix}RegEndDt")),
            "exam_start": to_iso_date(row.get(f"{prefix}ExamStartDt")),
            "exam_end": to_iso_date(row.get(f"{prefix}ExamEndDt")),
            "result_date": to_iso_date(row.get(f"{prefix}PassDt")),
        }
        if not any(parsed.values()):
            continue
        sessions.append(
            {
                "round": round_label,
                "phase": phase,
                **parsed,
                # 공공 API에서 온 값이므로 확인된 것으로 표시한다.
                "verified": True,
                "note": None,
            }
        )
    return sessions


def normalize_rows(rows: List[Dict[str, Any]]) -> Dict[str, Dict[str, Any]]:
    """API 응답 여러 줄을 {종목명: {code, sessions[]}} 형태로 묶는다."""
    by_name: Dict[str, Dict[str, Any]] = {}
    skipped = 0

    for row in rows:
        if not isinstance(row, dict):
            skipped += 1
            continue
        name = _pick(row, NAME_KEYS)
        if not name:
            skipped += 1
            continue
        sessions = row_to_sessions(row)
        if not sessions:
            continue
        entry = by_name.setdefault(name, {"code": _pick(row, CODE_KEYS), "sessions": []})
        entry["sessions"].extend(sessions)

    if skipped:
        logger.info("종목명을 찾지 못해 건너뛴 행: %d개", skipped)
    return by_name
