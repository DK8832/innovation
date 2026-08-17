from datetime import date
from typing import List, Optional

from pydantic import BaseModel, EmailStr, Field, conint


class SessionOut(BaseModel):
    round: str
    phase: str
    apply_start: Optional[date] = None
    apply_end: Optional[date] = None
    exam_start: Optional[date] = None
    exam_end: Optional[date] = None
    result_date: Optional[date] = None
    rolling: bool = False
    verified: bool
    note: Optional[str] = None


class ExamOut(BaseModel):
    id: str
    name: str
    category: str
    category_label: str
    organizer: str
    organizer_short: str
    homepage: str
    description: str
    sessions: List[SessionOut]


class CalendarEvent(BaseModel):
    exam_id: str
    exam_name: str
    category: str
    category_label: str
    organizer_short: str
    round: str
    phase: str
    event_type: str  # apply_start | apply_end | exam_start | exam_end | result
    event_label: str
    date: date
    d_day: int
    verified: bool
    note: Optional[str] = None


class SubscribeIn(BaseModel):
    email: EmailStr
    exam_id: str
    remind_days: List[conint(ge=0, le=90)] = Field(default_factory=lambda: [7, 1])


class SubscribeOut(BaseModel):
    token: str
    email: EmailStr
    exam_id: str
    remind_days: List[int]
    created_at: str


class SummarizeIn(BaseModel):
    """모집요강 원문. 파일 업로드 대신 붙여넣기를 받는다."""

    text: str = Field(min_length=1, max_length=20000)
    use_llm: bool = True


class SourceStatus(BaseModel):
    """데이터 출처별 현황. 화면에서 '지금 무엇이 켜져 있는지'를 그대로 보여준다."""

    id: str
    label: str
    kind: str  # curated | public_api | ai
    enabled: bool
    detail: str
