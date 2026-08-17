"""공공데이터포털 - 한국산업인력공단 국가자격 시험일정 조회 서비스 클라이언트.

엔드포인트: http://apis.data.go.kr/B490007/qualExamSchd/getQualExamSchdList
문서: https://www.data.go.kr/data/15074408/openapi.do

키가 없으면 조용히 실패하지 않고 상태를 명확히 돌려준다(성공을 흉내내지 않는다).
"""
import json
import logging
import os
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional

logger = logging.getLogger("sources.public_api")

ENDPOINT = "http://apis.data.go.kr/B490007/qualExamSchd/getQualExamSchdList"
KEY_ENV = "DATA_GO_KR_KEY"
KEY_FILE = "data_go_kr_key.txt"  # 저장소 루트 기준. .gitignore에 등록되어 있다.

# 자격구분 코드 (문서 기준)
QUALGB_NATIONAL_TECH = "T"  # 국가기술자격
QUALGB_NATIONAL_PRO = "S"  # 국가전문자격

TIMEOUT_SECONDS = 8  # 빠른 포기: 외부 연동이 서비스를 붙잡고 있으면 안 된다


@dataclass
class FetchResult:
    """수집 결과. ok=False여도 왜 실패했는지 항상 이유를 담는다."""

    ok: bool
    reason: str
    rows: List[Dict[str, Any]] = field(default_factory=list)
    raw_sample: Optional[Dict[str, Any]] = None


def find_key(root_dir: Optional[str] = None) -> Optional[str]:
    """환경변수 -> 키 파일 순으로 찾는다. 없으면 None."""
    key = os.environ.get(KEY_ENV)
    if key and key.strip():
        return key.strip()

    if root_dir is None:
        root_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    path = os.path.join(root_dir, KEY_FILE)
    if os.path.exists(path):
        try:
            with open(path, encoding="utf-8") as f:
                line = f.readline().strip()
            if line:
                return line
        except OSError as exc:
            logger.warning("키 파일을 읽지 못했습니다 (%s): %s", path, exc)
    return None


def has_key(root_dir: Optional[str] = None) -> bool:
    return find_key(root_dir) is not None


def _unwrap_rows(payload: Dict[str, Any]) -> List[Dict[str, Any]]:
    """공공데이터포털 표준 응답에서 item 목록을 꺼낸다.

    포털 API는 결과가 0건/1건/여러건일 때 items의 모양이 제각각이라
    (없음 / dict 하나 / list) 세 경우를 모두 흡수한다.
    """
    body = (payload.get("response") or {}).get("body") or {}
    items = body.get("items")
    if items in (None, "", []):
        return []
    if isinstance(items, dict):
        item = items.get("item")
        if item is None:
            return []
        return item if isinstance(item, list) else [item]
    if isinstance(items, list):
        return items
    return []


def _error_message(payload: Dict[str, Any]) -> Optional[str]:
    """포털이 에러를 200으로 감싸 보내는 경우까지 잡아낸다."""
    if "OpenAPI_ServiceResponse" in payload:
        header = payload["OpenAPI_ServiceResponse"].get("cmmMsgHeader", {})
        return header.get("returnAuthMsg") or header.get("errMsg") or "알 수 없는 오류"
    header = (payload.get("response") or {}).get("header") or {}
    code = header.get("resultCode")
    if code not in (None, "00", "0"):
        return f"{code}: {header.get('resultMsg', '알 수 없는 오류')}"
    return None


def fetch_schedules(
    impl_year: int,
    qualgb_cd: str = QUALGB_NATIONAL_TECH,
    num_of_rows: int = 300,
    page_no: int = 1,
    key: Optional[str] = None,
    root_dir: Optional[str] = None,
) -> FetchResult:
    """해당 연도의 국가자격 시험일정을 조회한다."""
    key = key or find_key(root_dir)
    if not key:
        return FetchResult(
            ok=False,
            reason=(
                f"공공데이터 API 키가 없습니다. 환경변수 {KEY_ENV} 또는 저장소 루트의 "
                f"{KEY_FILE} 첫 줄에 키를 넣으면 자동 갱신이 활성화됩니다. "
                "키가 없어도 큐레이션된 일정으로 서비스는 정상 동작합니다."
            ),
        )

    params = {
        "serviceKey": key,
        "numOfRows": str(num_of_rows),
        "pageNo": str(page_no),
        "dataFormat": "json",
        "implYy": str(impl_year),
    }
    if qualgb_cd:
        params["qualgbCd"] = qualgb_cd

    # serviceKey는 이미 URL 인코딩된 형태로 발급되는 경우가 많아 이중 인코딩을 피한다.
    query = "&".join(
        f"{k}={v if k == 'serviceKey' else urllib.parse.quote(str(v))}" for k, v in params.items()
    )
    url = f"{ENDPOINT}?{query}"

    req = urllib.request.Request(url, headers={"User-Agent": "exam-calendar/1.0"})
    try:
        with urllib.request.urlopen(req, timeout=TIMEOUT_SECONDS) as resp:
            body = resp.read().decode("utf-8", errors="replace")
    except urllib.error.HTTPError as exc:
        detail = ""
        try:
            detail = exc.read().decode("utf-8", errors="replace")[:200]
        except Exception:
            pass
        return FetchResult(ok=False, reason=f"HTTP {exc.code} — {detail or exc.reason}")
    except urllib.error.URLError as exc:
        return FetchResult(ok=False, reason=f"네트워크 오류: {exc.reason}")
    except Exception as exc:  # noqa: BLE001 - 어떤 실패든 서비스는 계속 떠 있어야 한다
        return FetchResult(ok=False, reason=f"예상하지 못한 오류: {exc}")

    try:
        payload = json.loads(body)
    except json.JSONDecodeError:
        # 포털은 오류일 때 XML을 돌려주기도 한다. 내용을 잘라 그대로 보여준다.
        return FetchResult(ok=False, reason=f"JSON이 아닌 응답: {body[:200]}")

    err = _error_message(payload)
    if err:
        return FetchResult(ok=False, reason=f"API 오류 — {err}")

    rows = _unwrap_rows(payload)
    return FetchResult(
        ok=True,
        reason=f"{len(rows)}건 수신",
        rows=rows,
        raw_sample=rows[0] if rows else None,
    )
