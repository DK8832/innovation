"""모집요강 원문 → 표준 템플릿 요약.

검색 결과의 광고성 블로그 대신 공식 공고문을 바로 읽어 필요한 항목만 뽑는 것이 목적이다.

## 설계에서 양보하지 않은 것 세 가지

1. **날짜는 절대 LLM을 거치지 않는다.** 날짜·숫자는 정규식으로만 뽑는다.
   접수 마감일 하나가 틀리면 수험생이 시험을 통째로 놓치는데, 생성 모델은
   그럴듯한 날짜를 지어내는 실패 유형이 확실히 존재한다.
2. **규칙 기반이 기본이고 LLM은 선택적 강화다.** API 키가 없는 사람도
   기능을 그대로 쓸 수 있어야 한다.
3. **LLM이 낸 값은 원문 대조(grounding)를 통과해야만 채택한다.**
   원문에 없는 내용이면 폐기하고 규칙 기반 결과로 되돌린다.
"""
import logging
import os
import re
from dataclasses import asdict, dataclass, field
from typing import Any, Dict, List, Optional

logger = logging.getLogger("sources.summarizer")

MAX_INPUT_CHARS = 20000  # 지나치게 큰 입력이 서버를 붙잡지 않도록

# ---------------------------------------------------------------- 날짜 (규칙 전용)

# 2026년 7월 20일 / 2026. 7. 20. / 2026-07-20 / 2026.7.20
_DATE_PATTERNS = [
    re.compile(r"(?P<y>20\d{2})\s*년\s*(?P<m>\d{1,2})\s*월\s*(?P<d>\d{1,2})\s*일"),
    re.compile(r"(?P<y>20\d{2})\s*[.\-/]\s*(?P<m>\d{1,2})\s*[.\-/]\s*(?P<d>\d{1,2})"),
]

# 공고문에서 날짜 앞에 흔히 붙는 라벨
DATE_LABELS = {
    "원서접수": "apply",
    "접수기간": "apply",
    "접수 기간": "apply",
    "인터넷 접수": "apply",
    "시험일": "exam",
    "시행일": "exam",
    "시험일자": "exam",
    "필기시험": "exam",
    "실기시험": "exam",
    "합격자 발표": "result",
    "합격자발표": "result",
    "합격발표": "result",
    "발표일": "result",
}

LABEL_KO = {"apply": "접수", "exam": "시험", "result": "발표"}


@dataclass
class ExtractedDate:
    date: str
    kind: str  # apply | exam | result | unknown
    kind_label: str
    context: str  # 원문에서 이 날짜가 등장한 주변 문구 (근거 제시용)


def extract_dates(text: str) -> List[ExtractedDate]:
    """원문에서 날짜를 뽑고, 바로 앞 문맥으로 종류를 추정한다.

    ⚠️ 여기서만 날짜가 만들어진다. LLM 경로는 날짜를 만들 수 없다.
    """
    found: List[ExtractedDate] = []
    seen = set()

    for pattern in _DATE_PATTERNS:
        for m in pattern.finditer(text):
            year, month, day = int(m.group("y")), int(m.group("m")), int(m.group("d"))
            if not (1 <= month <= 12 and 1 <= day <= 31):
                continue
            iso = f"{year:04d}-{month:02d}-{day:02d}"

            head = text[max(0, m.start() - 40) : m.start()]
            kind = "unknown"
            best_pos = -1
            for label, k in DATE_LABELS.items():
                pos = head.rfind(label)
                if pos > best_pos:
                    best_pos = pos
                    kind = k

            dedup_key = (iso, kind)
            if dedup_key in seen:
                continue
            seen.add(dedup_key)

            context = " ".join(
                text[max(0, m.start() - 30) : min(len(text), m.end() + 20)].split()
            )
            found.append(
                ExtractedDate(
                    date=iso,
                    kind=kind,
                    kind_label=LABEL_KO.get(kind, "구분 미상"),
                    context=context,
                )
            )

    found.sort(key=lambda d: d.date)
    return found


SECTION_ALIASES = {
    "eligibility": ["응시자격", "응시 자격", "지원자격", "응시대상"],
    "subjects": ["시험과목", "시험 과목", "검정과목", "출제과목"],
    "passing": ["합격기준", "합격 기준", "합격결정기준", "합격자 결정", "합격결정"],
    "method": ["검정방법", "시험방법", "출제형태", "시험형식"],
    "fee": ["응시수수료", "응시료", "수수료"],
}

SECTION_KO = {
    "eligibility": "응시자격",
    "subjects": "시험과목",
    "passing": "합격기준",
    "method": "검정방법",
    "fee": "응시수수료",
}

_ALL_HEADERS = [alias for aliases in SECTION_ALIASES.values() for alias in aliases] + list(
    DATE_LABELS.keys()
)


def _clean(text: str) -> str:
    text = re.sub(r"[​﻿]", "", text)
    return " ".join(text.split())


def extract_sections(text: str, max_len: int = 300) -> Dict[str, Optional[str]]:
    """제목어를 찾아 그 뒤부터 다음 제목어 전까지를 해당 항목으로 본다."""
    out: Dict[str, Optional[str]] = {k: None for k in SECTION_ALIASES}

    for field_name, aliases in SECTION_ALIASES.items():
        for alias in aliases:
            idx = text.find(alias)
            if idx == -1:
                continue
            start = idx + len(alias)

            next_pos = len(text)
            for header in _ALL_HEADERS:
                if header == alias:
                    continue
                p = text.find(header, start)
                if p != -1:
                    next_pos = min(next_pos, p)

            body = text[start:next_pos]
            body = re.sub(r"^[\s:：\-–·।|]+", "", body)
            body = _clean(body)
            body = re.sub(r"[\s\-–·]*(?:\d{1,2}\s*[.)]|[□■○●▶*])\s*$", "", body).strip()
            if body:
                out[field_name] = body[:max_len].strip()
                break

    return out


def _significant_tokens(text: str) -> List[str]:
    return re.findall(r"[가-힣]{2,}|\d+", text)


def grounding_ratio(candidate: str, source: str) -> float:
    tokens = _significant_tokens(candidate)
    if not tokens:
        return 0.0
    hit = sum(1 for t in tokens if t in source)
    return hit / len(tokens)


def is_grounded(candidate: str, source: str, threshold: float = 0.7) -> bool:
    return grounding_ratio(candidate, source) >= threshold


LLM_KEY_ENVS = ("OPENAI_API_KEY", "GROQ_API_KEY", "ANTHROPIC_API_KEY")


def llm_available() -> bool:
    return any(os.environ.get(k, "").strip() for k in LLM_KEY_ENVS)


def _llm_refine(text: str, rule_result: Dict[str, Optional[str]]) -> Optional[Dict[str, str]]:
    if not llm_available():
        return None
    try:
        import json
        import urllib.request

        api_key = os.environ.get("GROQ_API_KEY", "").strip()
        if not api_key:
            return None

        prompt = (
            "다음은 자격시험 모집요강 원문이다. 아래 JSON 형식으로만 답하라.\n"
            "규칙: 원문에 없는 내용은 절대 쓰지 마라. 날짜는 쓰지 마라. "
            "해당 항목이 원문에 없으면 빈 문자열로 두라.\n"
            '{"eligibility":"응시자격 요약","subjects":"시험과목 요약",'
            '"passing":"합격기준 요약"}\n\n'
            f"원문:\n{text[:6000]}"
        )
        body = json.dumps(
            {
                "model": "llama-3.3-70b-versatile",
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0.1,
                "response_format": {"type": "json_object"},
            }
        ).encode("utf-8")
        req = urllib.request.Request(
            "https://api.groq.com/openai/v1/chat/completions",
            data=body,
            headers={
                "Authorization": f"Bearer {api_key}",
                "Content-Type": "application/json",
                "User-Agent": "exam-calendar/1.0",
            },
        )
        with urllib.request.urlopen(req, timeout=15) as resp:
            payload = json.loads(resp.read().decode("utf-8"))
        content = payload["choices"][0]["message"]["content"]
        parsed = json.loads(content)
        return {k: str(v) for k, v in parsed.items() if v}
    except Exception as exc:
        logger.warning("LLM 보강 실패, 규칙 기반 결과를 사용합니다: %s", exc)
        return None


@dataclass
class SummaryResult:
    sections: Dict[str, Any] = field(default_factory=dict)
    dates: List[Dict[str, Any]] = field(default_factory=list)
    method: str = "rule"
    llm_used: bool = False
    rejected_by_grounding: List[str] = field(default_factory=list)
    notes: List[str] = field(default_factory=list)


def summarize(text: str, use_llm: bool = True) -> SummaryResult:
    result = SummaryResult()

    if not text or not text.strip():
        result.notes.append("입력이 비어 있습니다.")
        return result

    if len(text) > MAX_INPUT_CHARS:
        text = text[:MAX_INPUT_CHARS]
        result.notes.append(f"입력이 길어 앞 {MAX_INPUT_CHARS}자만 사용했습니다.")

    result.dates = [asdict(d) for d in extract_dates(text)]
    rule_sections = extract_sections(text)
    final_sections = dict(rule_sections)
    if use_llm and llm_available():
        refined = _llm_refine(text, rule_sections)
        if refined:
            result.llm_used = True
            result.method = "rule+llm"
            for key, value in refined.items():
                if key not in SECTION_ALIASES:
                    continue
                if is_grounded(value, text):
                    final_sections[key] = value
                else:
                    result.rejected_by_grounding.append(SECTION_KO.get(key, key))
    elif use_llm:
        result.notes.append(
            "LLM 키가 없어 규칙 기반으로만 추출했습니다 "
            "(GROQ_API_KEY 를 설정하면 서술형 항목이 더 다듬어집니다)."
        )

    result.sections = {
        key: {
            "label": SECTION_KO[key],
            "value": value,
            "found": value is not None,
        }
        for key, value in final_sections.items()
    }
    return result
