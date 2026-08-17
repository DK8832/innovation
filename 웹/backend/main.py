import logging
import os
import sys
import threading
import time
from datetime import date, timedelta
from pathlib import Path

# 한글 로그가 영어 로케일(cp1252 등) 콘솔에서 UnicodeEncodeError로 서버를 죽이지 않도록
# 표준출력/에러를 UTF-8로 강제한다. 자동 실행 환경(CI, 채점 스크립트 등)은 로케일을 알 수 없으므로.
for _stream in (sys.stdout, sys.stderr):
    if hasattr(_stream, "reconfigure"):
        _stream.reconfigure(encoding="utf-8", errors="replace")

from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Query
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles

import mailer
import store
import subscriptions
from models import (
    CalendarEvent,
    ExamOut,
    SourceStatus,
    SubscribeIn,
    SubscribeOut,
    SummarizeIn,
)
from sources import pipeline, public_api, summarizer

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(name)s] %(message)s")
logger = logging.getLogger("main")

BASE_DIR = Path(__file__).parent
FRONTEND_DIR = BASE_DIR.parent / "frontend"
PROJECT_DIR = BASE_DIR.parent
ANDROID_APP_VERSION = "2.0.0"
ANDROID_APK_FILENAME = "CERTI_ON_v2.0.0_ANDROID.apk"
ANDROID_APK_SIZE = 23584072
ANDROID_APK_URL = "https://github.com/DK8832/innovation/releases/download/v2.0.0/CERTI_ON_v2.0.0_ANDROID.apk"

ALERT_INTERVAL_SECONDS = int(os.environ.get("ALERT_INTERVAL_SECONDS", "3600"))


def _alert_loop():
    while True:
        try:
            sent = subscriptions.check_and_send(store.all_exams(), mailer.send_email)
            if sent:
                logger.info("알림 발송 완료: %d건", sent)
        except Exception:
            logger.exception("알림 체크 루프에서 오류 발생 (다음 주기에 재시도)")
        time.sleep(ALERT_INTERVAL_SECONDS)


@asynccontextmanager
async def lifespan(_app: FastAPI):
    # 시작: 데이터를 올리고 알림 스레드를 띄운다.
    # 여기서 예외가 나면 서버가 뜨지 않는다 — 깨진 데이터로 조용히 도는 것보다 낫다.
    store.load_exams()
    subscriptions.init_db()
    threading.Thread(target=_alert_loop, daemon=True).start()
    logger.info("서버 시작 완료. 알림 체크 주기 %d초", ALERT_INTERVAL_SECONDS)
    yield
    # 종료: 알림 스레드는 daemon이라 프로세스와 함께 정리된다.


app = FastAPI(title="자격증·시험 통합 캘린더", lifespan=lifespan)


@app.get("/api/health")
def health():
    return {"status": "ok", "exams": len(store.all_exams())}


@app.get("/api/app/android")
def android_app_info():
    """Android 설치 파일은 GitHub Release의 검증된 v2.0.0 APK를 연결한다."""
    return {
        "available": True,
        "platform": "Android",
        "version": ANDROID_APP_VERSION,
        "filename": ANDROID_APK_FILENAME,
        "size_bytes": ANDROID_APK_SIZE,
        "download_url": ANDROID_APK_URL,
    }


@app.get("/download/android")
def download_android_app():
    """저장소에 APK를 중복 저장하지 않고 GitHub Release로 이동한다."""
    return RedirectResponse(url=ANDROID_APK_URL, status_code=307)


@app.get("/api/exams", response_model=list[ExamOut])
def list_exams(category: str | None = None, q: str | None = None):
    return store.get_exams(category=category, q=q)


@app.get("/api/exams/{exam_id}", response_model=ExamOut)
def exam_detail(exam_id: str):
    exam = store.get_exam(exam_id)
    if exam is None:
        raise HTTPException(status_code=404, detail="해당 시험을 찾을 수 없습니다")
    return exam


@app.get("/api/calendar", response_model=list[CalendarEvent])
def calendar(
    start: date = Query(...),
    end: date = Query(...),
    category: str | None = None,
):
    if end < start:
        raise HTTPException(status_code=422, detail="end는 start보다 앞설 수 없습니다")
    return store.calendar_events(start=start, end=end, category=category)


@app.get("/api/upcoming", response_model=list[CalendarEvent])
def upcoming(days: int = Query(30, ge=1, le=365)):
    return store.upcoming_events(days=days)


@app.post("/api/subscribe", response_model=SubscribeOut)
def subscribe(payload: SubscribeIn):
    exam = store.get_exam(payload.exam_id)
    if exam is None:
        raise HTTPException(status_code=404, detail="해당 시험을 찾을 수 없습니다")
    remind_days = payload.remind_days or [7, 1]
    token = subscriptions.add_subscription(
        email=payload.email, exam_id=payload.exam_id, remind_days=remind_days
    )
    return SubscribeOut(
        token=token,
        email=payload.email,
        exam_id=payload.exam_id,
        remind_days=sorted(set(remind_days)),
        created_at=date.today().isoformat(),
    )


@app.delete("/api/subscribe/{token}")
def unsubscribe(token: str):
    ok = subscriptions.delete_subscription(token)
    if not ok:
        raise HTTPException(status_code=404, detail="해당 구독을 찾을 수 없습니다")
    return {"status": "deleted"}


# ---------------------------------------------------------------- 데이터 출처

@app.get("/api/sources", response_model=list[SourceStatus])
def sources():
    """어떤 데이터 출처가 지금 켜져 있는지 그대로 보여준다.

    켜지지 않은 것을 켜진 것처럼 표시하지 않는다 — 무엇이 큐레이션이고
    무엇이 자동 수집인지 사용자가 구분할 수 있어야 하기 때문이다.
    """
    exams = store.all_exams()
    unverified = sum(
        1 for e in exams for s in e.sessions if not s.verified
    )
    sync_state = pipeline.load_sync_state()
    api_on = public_api.has_key()
    llm_on = summarizer.llm_available()

    return [
        SourceStatus(
            id="curated",
            label="큐레이션 데이터",
            kind="curated",
            enabled=True,
            detail=(
                f"{len(exams)}개 종목을 공식 사이트에서 직접 확인해 정리했습니다. "
                f"날짜 미확인 세션 {unverified}건은 화면에 표시됩니다."
            ),
        ),
        SourceStatus(
            id="public_api",
            label="공공데이터 자동 동기화",
            kind="public_api",
            enabled=api_on,
            detail=(
                (
                    f"마지막 동기화: {sync_state.get('last_run') or '없음'} — "
                    f"{sync_state.get('reason', '')}"
                )
                if api_on
                else (
                    "API 키가 없어 꺼져 있습니다. 키가 없어도 위 큐레이션 데이터로 "
                    "서비스는 완전히 동작합니다."
                )
            ),
        ),
        SourceStatus(
            id="ai_summary",
            label="모집요강 AI 요약",
            kind="ai",
            enabled=True,
            detail=(
                "규칙 기반 추출이 기본이라 키 없이 동작합니다. "
                + ("LLM 보강이 켜져 있습니다." if llm_on else "LLM 키를 넣으면 서술형 항목이 더 다듬어집니다.")
            ),
        ),
    ]


@app.get("/api/review")
def review_queue():
    """자동 수집이 찾아낸 '사람이 확인해야 할 변경'. 자동 반영하지 않는다."""
    return {
        "sync": pipeline.load_sync_state(),
        "changes": pipeline.load_review_queue(),
    }


@app.post("/api/summarize")
def summarize_notice(payload: SummarizeIn):
    """모집요강 원문을 표준 항목으로 요약한다.

    날짜는 정규식으로만 뽑고 LLM을 거치지 않는다. LLM이 보강한 서술형 항목도
    원문 대조를 통과해야만 채택된다.
    """
    result = summarizer.summarize(payload.text, use_llm=payload.use_llm)
    return {
        "sections": result.sections,
        "dates": result.dates,
        "method": result.method,
        "llm_used": result.llm_used,
        "rejected_by_grounding": result.rejected_by_grounding,
        "notes": result.notes,
    }


# API 라우트를 먼저 등록했으므로, 나머지 모든 경로(/, /app.js 등)는 정적 프론트엔드로 서빙된다.
app.mount("/", StaticFiles(directory=str(FRONTEND_DIR), html=True), name="frontend")


if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", "8000"))
    uvicorn.run(app, host=os.environ.get("HOST", "127.0.0.1"), port=port)
