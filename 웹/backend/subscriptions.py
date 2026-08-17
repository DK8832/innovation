import json
import logging
import secrets
import sqlite3
from contextlib import contextmanager
from datetime import date, datetime
from pathlib import Path
from typing import List, Optional

import store

logger = logging.getLogger("subscriptions")

DB_PATH = Path(__file__).parent / "data" / "subscriptions.db"

_SCHEMA = """
CREATE TABLE IF NOT EXISTS subscriptions (
    token TEXT PRIMARY KEY,
    email TEXT NOT NULL,
    exam_id TEXT NOT NULL,
    remind_days TEXT NOT NULL,
    created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS sent_alerts (
    token TEXT NOT NULL,
    session_key TEXT NOT NULL,
    remind_day INTEGER NOT NULL,
    sent_at TEXT NOT NULL,
    PRIMARY KEY (token, session_key, remind_day)
);
"""


@contextmanager
def _conn():
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    try:
        yield conn
        conn.commit()
    finally:
        conn.close()


def init_db() -> None:
    with _conn() as conn:
        conn.executescript(_SCHEMA)


def add_subscription(email: str, exam_id: str, remind_days: List[int]) -> str:
    token = secrets.token_urlsafe(16)
    with _conn() as conn:
        conn.execute(
            "INSERT INTO subscriptions (token, email, exam_id, remind_days, created_at) "
            "VALUES (?, ?, ?, ?, ?)",
            (token, email, exam_id, json.dumps(sorted(set(remind_days))), datetime.now().isoformat()),
        )
    logger.info("구독 등록: %s / %s", exam_id, email)
    return token


def delete_subscription(token: str) -> bool:
    with _conn() as conn:
        cur = conn.execute("DELETE FROM subscriptions WHERE token = ?", (token,))
        return cur.rowcount > 0


def list_subscriptions() -> List[dict]:
    with _conn() as conn:
        conn.row_factory = sqlite3.Row
        rows = conn.execute("SELECT * FROM subscriptions").fetchall()
        return [
            {
                "token": r["token"],
                "email": r["email"],
                "exam_id": r["exam_id"],
                "remind_days": json.loads(r["remind_days"]),
                "created_at": r["created_at"],
            }
            for r in rows
        ]


def already_sent(token: str, session_key: str, remind_day: int) -> bool:
    with _conn() as conn:
        row = conn.execute(
            "SELECT 1 FROM sent_alerts WHERE token = ? AND session_key = ? AND remind_day = ?",
            (token, session_key, remind_day),
        ).fetchone()
        return row is not None


def mark_sent(token: str, session_key: str, remind_day: int) -> None:
    with _conn() as conn:
        conn.execute(
            "INSERT OR IGNORE INTO sent_alerts (token, session_key, remind_day, sent_at) "
            "VALUES (?, ?, ?, ?)",
            (token, session_key, remind_day, datetime.now().isoformat()),
        )


def check_and_send(exams: list, send_email_fn, today: Optional[date] = None) -> int:
    """구독마다 대상 시험의 접수마감일까지 남은 일수가 remind_days와 일치하면 발송한다.
    이미 보낸 (token, session, remind_day) 조합은 다시 보내지 않는다.
    반환값은 실제로 발송(성공)한 개수."""
    today = today or store.today_kst()
    exam_by_id = {e.id: e for e in exams}
    sent_count = 0

    for sub in list_subscriptions():
        exam = exam_by_id.get(sub["exam_id"])
        if exam is None:
            continue
        for session in exam.sessions:
            if session.rolling or session.apply_end is None:
                continue
            days_left = (session.apply_end - today).days
            if days_left < 0:
                continue
            session_key = f"{session.round}:{session.phase}"
            for remind_day in sub["remind_days"]:
                if days_left != remind_day:
                    continue
                if already_sent(sub["token"], session_key, remind_day):
                    continue
                subject = f"[자격증 알림] {exam.name} 접수마감 D-{remind_day}"
                body = (
                    f"{exam.name} ({session.round} {session.phase})\n"
                    f"접수마감일: {session.apply_end.isoformat()}\n"
                    f"시험일: {session.exam_start.isoformat() if session.exam_start else '미정'}\n"
                    f"공식 홈페이지: {exam.homepage}"
                )
                ok = send_email_fn(sub["email"], subject, body)
                if ok:
                    mark_sent(sub["token"], session_key, remind_day)
                    sent_count += 1
    return sent_count
