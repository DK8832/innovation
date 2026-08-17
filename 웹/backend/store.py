import json
import logging
from datetime import date, datetime
from pathlib import Path
from typing import List, Optional

from models import CalendarEvent, ExamOut

logger = logging.getLogger("store")

DATA_PATH = Path(__file__).parent / "data" / "exams.json"

EVENT_LABELS = {
    "apply_start": "접수 시작",
    "apply_end": "접수 마감",
    "exam_start": "시험",
    "exam_end": "시험 종료",
    "result_date": "합격자 발표",
}

_EXAMS: List[ExamOut] = []


def load_exams() -> List[ExamOut]:
    """exams.json을 읽어 메모리에 올린다. 서버 시작 시 한 번, 필요하면 재로딩용으로도 사용."""
    global _EXAMS
    with open(DATA_PATH, encoding="utf-8") as f:
        raw = json.load(f)
    _EXAMS = [ExamOut(**exam) for exam in raw["exams"]]
    logger.info("exams.json 로드 완료: %d개 시험", len(_EXAMS))
    return _EXAMS


def all_exams() -> List[ExamOut]:
    if not _EXAMS:
        load_exams()
    return _EXAMS


def get_exams(category: Optional[str] = None, q: Optional[str] = None) -> List[ExamOut]:
    exams = all_exams()
    if category:
        exams = [e for e in exams if e.category == category]
    if q:
        needle = q.strip().lower()
        exams = [
            e
            for e in exams
            if needle in e.name.lower()
            or needle in e.organizer.lower()
            or needle in e.category_label.lower()
        ]
    return exams


def get_exam(exam_id: str) -> Optional[ExamOut]:
    for e in all_exams():
        if e.id == exam_id:
            return e
    return None


def today_kst() -> date:
    """서버가 어느 시간대에서 돌든 한국 날짜 기준으로 오늘을 계산한다."""
    try:
        from zoneinfo import ZoneInfo

        return datetime.now(ZoneInfo("Asia/Seoul")).date()
    except Exception:
        logger.warning("Asia/Seoul 시간대 로드 실패, 시스템 로컬 날짜로 대체")
        return date.today()


def _events_from_session(exam: ExamOut, session, today: date) -> List[CalendarEvent]:
    if session.rolling:
        return []
    events: List[CalendarEvent] = []
    fields = [
        ("apply_start", session.apply_start),
        ("apply_end", session.apply_end),
        ("exam_start", session.exam_start),
        ("exam_end", session.exam_end if session.exam_end != session.exam_start else None),
        ("result_date", session.result_date),
    ]
    for event_type, d in fields:
        if d is None:
            continue
        events.append(
            CalendarEvent(
                exam_id=exam.id,
                exam_name=exam.name,
                category=exam.category,
                category_label=exam.category_label,
                organizer_short=exam.organizer_short,
                round=session.round,
                phase=session.phase,
                event_type=event_type,
                event_label=EVENT_LABELS[event_type],
                date=d,
                d_day=(d - today).days,
                verified=session.verified,
                note=session.note,
            )
        )
    return events


def calendar_events(
    start: date, end: date, category: Optional[str] = None, today: Optional[date] = None
) -> List[CalendarEvent]:
    today = today or today_kst()
    exams = get_exams(category=category)
    out: List[CalendarEvent] = []
    for exam in exams:
        for session in exam.sessions:
            out.extend(
                e for e in _events_from_session(exam, session, today) if start <= e.date <= end
            )
    out.sort(key=lambda e: e.date)
    return out


def upcoming_events(days: int = 30, today: Optional[date] = None) -> List[CalendarEvent]:
    today = today or today_kst()
    exams = all_exams()
    out: List[CalendarEvent] = []
    for exam in exams:
        for session in exam.sessions:
            out.extend(_events_from_session(exam, session, today))
    out = [e for e in out if 0 <= e.d_day <= days]
    out.sort(key=lambda e: (e.date, e.d_day))
    return out
