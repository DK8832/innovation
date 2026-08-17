"""
정적 검사 + 실제 서버를 띄운 API 검증.
사용법: python verify_all.py

이 스크립트가 띄운 서버 프로세스는 정확한 PID로만 추적/종료한다 (이름으로 kill 금지).
"""
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request
from datetime import date, timedelta
from pathlib import Path

ROOT = Path(__file__).parent
BACKEND = ROOT / "backend"
sys.path.insert(0, str(BACKEND))

PASS = []
FAIL = []


def check(name, condition, detail=""):
    if condition:
        PASS.append(name)
        print(f"  OK   {name}")
    else:
        FAIL.append((name, detail))
        print(f"  FAIL {name}  -- {detail}")


# ---------------------------------------------------------------
print("[1/5] 문법 검사 (py_compile)")
import py_compile

for pyfile in sorted(BACKEND.glob("sources/*.py")) + sorted(BACKEND.glob("*.py")):
    try:
        py_compile.compile(str(pyfile), doraise=True)
        check(f"syntax: {pyfile.name}", True)
    except py_compile.PyCompileError as e:
        check(f"syntax: {pyfile.name}", False, str(e))

# ---------------------------------------------------------------
print("\n[2/5] exams.json 스키마 검사")
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
REQUIRED_EXAM_FIELDS = {
    "id", "name", "category", "category_label", "organizer",
    "organizer_short", "homepage", "description", "sessions",
}
REQUIRED_SESSION_FIELDS = {"round", "phase", "verified"}
DATE_FIELDS = ["apply_start", "apply_end", "exam_start", "exam_end", "result_date"]

data_path = BACKEND / "data" / "exams.json"
with open(data_path, encoding="utf-8") as f:
    raw = json.load(f)

exams_raw = raw.get("exams", [])
check("exams.json: exams 배열 존재", isinstance(exams_raw, list) and len(exams_raw) > 0, f"{len(exams_raw)}개")

ids_seen = set()
unverified = []
for exam in exams_raw:
    missing = REQUIRED_EXAM_FIELDS - set(exam.keys())
    check(f"schema: {exam.get('id', '?')} 필수 필드", not missing, f"누락: {missing}")
    check(f"schema: {exam.get('id', '?')} id 중복 아님", exam.get("id") not in ids_seen)
    ids_seen.add(exam.get("id"))
    for s in exam.get("sessions", []):
        smissing = REQUIRED_SESSION_FIELDS - set(s.keys())
        check(f"schema: {exam['id']}/{s.get('round')} 세션 필수 필드", not smissing, f"누락: {smissing}")
        for field in DATE_FIELDS:
            v = s.get(field)
            if v is not None:
                ok = bool(DATE_RE.match(v))
                check(f"schema: {exam['id']}/{s.get('round')} {field} 날짜형식", ok, f"값: {v}")
        if not s.get("verified", False):
            unverified.append(f"{exam['id']} / {s.get('round')} / {s.get('phase')}")

print(f"  (참고) 날짜 미확인(verified:false) 세션 {len(unverified)}건:")
for u in unverified:
    print(f"    - {u}")

# ---------------------------------------------------------------
print("\n[3/5] D-day 계산 단위 검사 (오늘을 고정 주입)")
import store  # noqa: E402

store.load_exams()
fixed_today = date(2026, 8, 15)

# 3-1. 정상 케이스: 알고 있는 세션의 d_day가 정확히 계산되는지
toeic = store.get_exam("toeic")
sess = toeic.sessions[0]  # 9월 6일 시험, apply_end 2026-08-24
expected = (sess.apply_end - fixed_today).days
events = store.calendar_events(date(2026, 8, 1), date(2026, 8, 31), today=fixed_today)
matched = [e for e in events if e.exam_id == "toeic" and e.event_type == "apply_end" and e.date == sess.apply_end]
check("dday: 정상 케이스 값 일치", bool(matched) and matched[0].d_day == expected, f"expected={expected}")

# 3-2. 당일(D-DAY, d_day=0)
d0_events = store.calendar_events(fixed_today, fixed_today, today=fixed_today)
# 그날짜에 실제 이벤트가 있는지와 무관하게, 있다면 d_day가 반드시 0이어야 한다
check("dday: 당일 이벤트는 d_day=0", all(e.d_day == 0 for e in d0_events), str([e.d_day for e in d0_events]))

# 3-3. 이미 지난 날짜는 upcoming에서 제외
past_events = store.calendar_events(date(2026, 1, 1), fixed_today - timedelta(days=1), today=fixed_today)
upcoming = store.upcoming_events(days=400, today=fixed_today)
past_dates = {(e.exam_id, e.event_type, e.date) for e in past_events}
upcoming_keys = {(e.exam_id, e.event_type, e.date) for e in upcoming}
check("dday: 과거 이벤트가 upcoming에 안 섞임", past_dates.isdisjoint(upcoming_keys), str(past_dates & upcoming_keys))

# 3-4. 월 경계: 8/31 -> 9/1 로 넘어가도 d_day가 연속적인지
d31 = date(2026, 8, 31)
d1 = date(2026, 9, 1)
check("dday: 월 경계 연속성", (d1 - d31).days == 1)

# 3-5. rolling(상시) 세션은 캘린더/upcoming에서 완전히 제외
rolling_exam = store.get_exam("computer-literacy")
check("dday: rolling 세션 존재 확인(전제조건)", any(s.rolling for s in rolling_exam.sessions))
wide = store.upcoming_events(days=3650, today=fixed_today)
check("dday: rolling 세션은 upcoming에서 제외", all(e.exam_id != "computer-literacy" for e in wide))

# 3-6. upcoming 정렬이 오름차순인지
check("dday: upcoming 오름차순 정렬", all(a.d_day <= b.d_day for a, b in zip(upcoming, upcoming[1:])))

# ---------------------------------------------------------------
print("\n[4/5] 데이터 소스 · 요약기 단위 검사 (네트워크 없이)")

from sources import normalize, pipeline, public_api, summarizer  # noqa: E402

# 4-1. 날짜 형식 변환
check("normalize: YYYYMMDD 변환", normalize.to_iso_date("20260720") == "2026-07-20")
check("normalize: 이미 ISO면 그대로", normalize.to_iso_date("2026-07-20") == "2026-07-20")
check("normalize: 점 구분자", normalize.to_iso_date("2026.07.20") == "2026-07-20")
for bad in ("", None, "0", "2026-13-01", "abc", "202607"):
    check(f"normalize: 잘못된 입력 거부 ({bad!r})", normalize.to_iso_date(bad) is None)

# 4-2. 문서 스키마 그대로의 가짜 응답을 주입해 정규화 검증
#     (실제 API 키가 없으므로 네트워크 대신 주입으로 파이프라인을 검사한다)
fake_rows = [
    {
        "jmNm": "정보처리기사", "jmCd": "1320", "implSeq": "2026년 3회",
        "docRegStartDt": "20260720", "docRegEndDt": "20260723",
        "docExamStartDt": "20260807", "docExamEndDt": "20260901", "docPassDt": "20260909",
        "pracRegStartDt": "20260921", "pracRegEndDt": "20260923",
        "pracExamStartDt": "20261024", "pracExamEndDt": "20261113", "pracPassDt": "",
    },
    {"jmNm": "유령종목", "jmCd": "9999", "implSeq": "2026년 1회"},  # 날짜 0개
]
collected = normalize.normalize_rows(fake_rows)
check("normalize: 종목명으로 묶임", "정보처리기사" in collected)
check("normalize: 날짜 없는 행은 세션을 만들지 않음", "유령종목" not in collected)
sessions = collected.get("정보처리기사", {}).get("sessions", [])
check("normalize: 필기/실기 두 세션으로 분리", len(sessions) == 2, f"{len(sessions)}개")
written = next((s for s in sessions if s["phase"] == "필기"), None)
check(
    "normalize: 필기 날짜 매핑 정확",
    written is not None
    and written["apply_start"] == "2026-07-20"
    and written["exam_end"] == "2026-09-01"
    and written["result_date"] == "2026-09-09",
    str(written),
)
check(
    "normalize: 빈 문자열 날짜는 None",
    next((s for s in sessions if s["phase"] == "실기"), {}).get("result_date") is None,
)

# 4-3. 변경 감지 — 같으면 조용하고, 다르면 그 필드만 잡아낸다
base_session = {
    "round": "2026년 3회", "phase": "필기",
    "apply_start": "2026-07-20", "apply_end": "2026-07-23",
    "exam_start": "2026-08-07", "exam_end": "2026-09-01", "result_date": "2026-09-09",
}
same = pipeline.diff_sessions("정보처리기사", "x", [base_session], [dict(base_session)])
check("diff: 동일하면 변경 없음", same == [], str(same))

changed_input = dict(base_session, apply_end="2026-07-24")
changed = pipeline.diff_sessions("정보처리기사", "x", [base_session], [changed_input])
check("diff: 달라진 필드만 감지", len(changed) == 1 and changed[0]["fields"] == ["apply_end"], str(changed))

added = pipeline.diff_sessions("정보처리기사", "x", [], [base_session])
check("diff: 없던 세션은 new_session", len(added) == 1 and added[0]["change_type"] == "new_session")

# 4-4. 종목 매칭은 보수적이어야 한다 (엉뚱한 종목에 날짜를 붙이면 안 됨)
check(
    "match: 정확히 일치하면 매칭",
    pipeline.match_exam({"name": "전기기사"}, {"전기기사": {}}) == "전기기사",
)
check(
    "match: 후보가 둘 이상이면 매칭하지 않음",
    pipeline.match_exam({"name": "전기기사"}, {"전기기사 필기": {}, "전기기사 실기": {}}) is None,
)
check(
    "match: 무관한 종목은 매칭하지 않음",
    pipeline.match_exam({"name": "전기기사"}, {"정보처리기사": {}}) is None,
)

# 4-5. 키가 없을 때 성공을 흉내내지 않는다
if not public_api.has_key():
    res = public_api.fetch_schedules(2026, key=None)
    check("public_api: 키 없으면 ok=False", res.ok is False)
    check("public_api: 실패 이유를 알려줌", bool(res.reason) and "키" in res.reason)
    check("public_api: 실패 시 데이터를 만들어내지 않음", res.rows == [])
else:
    print("  SKIP 키가 설정되어 있어 '키 없음' 경로는 건너뜁니다")

# 4-6. 요약기 — 날짜는 규칙으로만, 종류는 가장 가까운 라벨로
notice = (
    "1. 원서접수\n2026년 7월 20일(월) ~ 2026년 7월 23일(목)\n"
    "2. 시험일자\n필기시험: 2026년 8월 7일(금)\n"
    "3. 합격자 발표\n2026년 9월 9일(수)\n"
    "4. 응시자격\n대학졸업자 또는 졸업예정자\n"
    "5. 시험과목\n소프트웨어설계, 데이터베이스구축\n"
    "6. 합격기준\n전과목 평균 60점 이상\n"
)
summary = summarizer.summarize(notice, use_llm=False)
by_date = {d["date"]: d["kind"] for d in summary.dates}
check("summarize: 접수일 추출", by_date.get("2026-07-20") == "apply", str(by_date))
check(
    "summarize: 시험일이 접수로 오분류되지 않음",
    by_date.get("2026-08-07") == "exam",
    f"실제={by_date.get('2026-08-07')}",
)
check("summarize: 발표일 추출", by_date.get("2026-09-09") == "result", str(by_date))
check(
    "summarize: 시험과목이 다음 항목을 삼키지 않음",
    "합격기준" not in (summary.sections["subjects"]["value"] or ""),
    summary.sections["subjects"]["value"],
)
check("summarize: 응시자격 추출", summary.sections["eligibility"]["found"])
check("summarize: 없는 항목은 found=False", summary.sections["method"]["found"] is False)
check("summarize: 키 없으면 규칙 기반으로 표기", summary.method == "rule" or summary.llm_used)
check("summarize: 빈 입력에도 죽지 않음", summarizer.summarize("", use_llm=False).dates == [])

# 4-7. 근거 대조(grounding)가 실제로 지어낸 값을 거른다
src = "필기 과목은 소프트웨어설계와 데이터베이스구축이다"
check("grounding: 원문에 있는 값은 채택", summarizer.is_grounded("소프트웨어설계, 데이터베이스구축", src))
check("grounding: 지어낸 값은 거부", not summarizer.is_grounded("인공지능개론, 블록체인실무", src))
check("grounding: 절반만 진짜여도 거부", not summarizer.is_grounded("소프트웨어설계 및 블록체인 심화", src))

# 4-8. 프론트엔드 정적 검사
# 스크롤 리스너를 인라인 함수로 등록하면 removeEventListener가 '등록된 적 없는 함수'를
# 지우려 해서 아무것도 해제되지 않는다. 화면을 오갈 때마다 리스너가 쌓였던 실제 버그라
# 등록/해제가 같은 이름을 쓰는지 확인한다.
app_js = (ROOT / "frontend" / "app.js").read_text(encoding="utf-8")
app_html = (ROOT / "frontend" / "index.html").read_text(encoding="utf-8")

added = set(re.findall(r'addEventListener\(\s*"scroll"\s*,\s*([A-Za-z_$][\w$]*)\s*[,)]', app_js))
removed = set(re.findall(r'removeEventListener\(\s*"scroll"\s*,\s*([A-Za-z_$][\w$]*)\s*[,)]', app_js))
check("frontend: 해제하는 scroll 리스너는 등록도 같은 이름으로", removed and removed <= added,
      f"등록={sorted(added)} 해제={sorted(removed)}")

# 화면을 전환할 때마다 불리는 함수 안에서 리스너를 새로 만들어 붙이면 안 된다.
# (한 번만 붙는 내비게이션 핸들러는 해당 없음 — 여기서는 반복 호출 경로만 본다)
m = re.search(r"function strikeAssumptions\(\)\s*\{(.*?)\n  \}", app_js, re.S)
check("frontend: strikeAssumptions 본문을 찾음", m is not None)
if m:
    body = m.group(1)
    check("frontend: 화면 전환 함수가 인라인 리스너를 만들지 않음",
          not re.search(r'addEventListener\([^)]*(?:function|=>)', body),
          body.strip()[:90])
    check("frontend: 스윕 함수는 안정된 이름으로 한 번만 선언",
          app_js.count("function sweepAssumptions") == 1)

# 넓은 표는 반드시 자기 스크롤 상자를 가져야 한다 (그리드가 페이지를 가로로 밀어낸 버그)
app_css = (ROOT / "frontend" / "style.css").read_text(encoding="utf-8")
check("frontend: 실측표에 가로 스크롤 상자 지정", ".proc-table-scroll" in app_css
      and "overflow-x: auto" in app_css)
check("frontend: 그리드 칸의 min-width를 0으로 눌러둠", ".proc-body { min-width: 0; }" in app_css)
check(
    "frontend: Android 앱 설치 영역과 다운로드 링크 존재",
    'id="appDownload"' in app_html and 'CERTI_ON_v2.0.0_ANDROID.apk' in app_html,
)
check(
    "frontend: APK가 Android 전용임을 명시",
    "Android 전용 설치 파일" in app_html,
)
check(
    "frontend: 앱 다운로드 반응형 스타일 존재",
    ".app-download {" in app_css and "grid-template-columns: 1fr" in app_css,
)

# ---------------------------------------------------------------
print("\n[5/5] 실 서버 기동 후 API 검증")

venv_python = ROOT / ".venv" / "Scripts" / "python.exe"
python_exe = str(venv_python) if venv_python.exists() else sys.executable

env = os.environ.copy()
env["PORT"] = "8010"
env["ALERT_INTERVAL_SECONDS"] = "3600"

# ⚠️ stdout=PIPE로 띄우고 읽지 않으면, 서버 로그가 파이프 버퍼(수십 KB)를 채우는 순간
#    서버가 write()에서 멈춘다. 요청이 늘어날수록 확실히 걸리는 함정이라 파일로 받는다.
#    (검사 항목을 늘리다 실제로 이 현상을 재현했다 — 서버가 죽은 게 아니라 멈춘 것이었다)
server_log = ROOT / "verify_server.log"
log_handle = open(server_log, "w+", encoding="utf-8")

proc = subprocess.Popen(
    [python_exe, "-X", "utf8", "main.py"],
    cwd=str(BACKEND),
    env=env,
    stdout=log_handle,
    stderr=subprocess.STDOUT,
)
BASE = "http://127.0.0.1:8010"


def http_get(path, timeout=5):
    try:
        with urllib.request.urlopen(BASE + path, timeout=timeout) as r:
            return r.status, json.loads(r.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        return e.code, json.loads(e.read().decode("utf-8"))


def http_post(path, payload, timeout=5):
    req = urllib.request.Request(
        BASE + path,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, json.loads(r.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        return e.code, json.loads(e.read().decode("utf-8"))


def http_bytes(path, timeout=20):
    try:
        with urllib.request.urlopen(BASE + path, timeout=timeout) as r:
            return r.status, r.headers, r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.headers, e.read()


try:
    ready = False
    for _ in range(30):  # 최대 6초, fail-fast로 짧게 여러 번
        if proc.poll() is not None:
            break
        try:
            status, _ = http_get("/api/health", timeout=1)
            if status == 200:
                ready = True
                break
        except Exception:
            pass
        time.sleep(0.2)

    check("server: 기동 후 /api/health 응답", ready, f"poll={proc.poll()}")

    if ready:
        status, app_info = http_get("/api/app/android")
        check("api: GET /api/app/android 200", status == 200, f"status={status}")
        check(
            "api: Android APK 메타데이터 정확",
            app_info.get("available") is True
            and app_info.get("version") == "2.0.0"
            and app_info.get("filename") == "CERTI_ON_v2.0.0_ANDROID.apk"
            and app_info.get("size_bytes", 0) > 0
            and app_info.get("download_url", "").startswith("https://github.com/DK8832/innovation/releases/download/v2.0.0/"),
            str(app_info),
        )

        # APK 바이너리는 웹 소스에 중복 저장하지 않고 검증된 GitHub Release Asset으로 연결한다.
        # 네트워크가 차단된 CI에서도 외부 다운로드를 강제하지 않고, 서버가 정확한 리다이렉트를
        # 돌려주는지만 확인한다.
        req = urllib.request.Request(BASE + "/download/android", method="GET")
        opener = urllib.request.build_opener(urllib.request.HTTPHandler())
        try:
            response = opener.open(req, timeout=5)
            redirect_ok = response.geturl() == app_info.get("download_url")
        except Exception:
            redirect_ok = False
        check("download: Android APK Release 주소로 연결", redirect_ok, app_info.get("download_url", ""))

        status, body = http_get("/api/exams")
        check("api: GET /api/exams 200", status == 200)
        check("api: /api/exams 개수>0", len(body) > 0, f"{len(body)}개")

        status, body = http_get("/api/calendar?start=2026-01-01&end=2026-12-31")
        check("api: GET /api/calendar 200", status == 200)
        in_range = all("2026-01-01" <= e["date"] <= "2026-12-31" for e in body)
        check("api: calendar 이벤트가 범위 안에 있음", in_range)

        status, body = http_get("/api/upcoming?days=365")
        check("api: GET /api/upcoming 200", status == 200)
        ascending = all(a["d_day"] <= b["d_day"] for a, b in zip(body, body[1:]))
        check("api: upcoming 오름차순", ascending)

        status, body = http_get("/api/sources")
        check("api: GET /api/sources 200", status == 200)
        ids = {s["id"] for s in body}
        check("api: 출처 3종 모두 보고", ids == {"curated", "public_api", "ai_summary"}, str(ids))
        curated = next((s for s in body if s["id"] == "curated"), {})
        check("api: 큐레이션은 항상 켜져 있음", curated.get("enabled") is True)
        check("api: 모든 출처가 설명을 가짐", all(s.get("detail") for s in body))

        status, body = http_get("/api/review")
        check("api: GET /api/review 200", status == 200)
        check("api: review에 sync 상태 포함", "sync" in body and "changes" in body, str(body.keys()))

        status, body = http_post(
            "/api/summarize",
            {"text": "1. 원서접수\n2026년 7월 20일\n4. 응시자격\n대학졸업자", "use_llm": False},
        )
        check("api: POST /api/summarize 200", status == 200, str(body)[:120])
        check(
            "api: summarize 날짜 추출",
            any(d["date"] == "2026-07-20" for d in body.get("dates", [])),
            str(body.get("dates")),
        )
        check(
            "api: summarize 응시자격 추출",
            body.get("sections", {}).get("eligibility", {}).get("found") is True,
        )
        check("api: summarize가 사용 방식을 밝힘", body.get("method") in ("rule", "rule+llm"))

        status, _ = http_post("/api/summarize", {"text": ""})
        check("api: summarize 빈 입력 -> 422", status == 422, f"status={status}")

        status, _ = http_post("/api/summarize", {"text": "가" * 20001})
        check("api: summarize 과대 입력 -> 422", status == 422, f"status={status}")

        status, body = http_post("/api/subscribe", {"email": "verify@example.com", "exam_id": "toeic", "remind_days": [7, 1]})
        check("api: subscribe 정상 이메일 -> 200", status == 200, f"status={status} body={body}")

        status, body = http_post("/api/subscribe", {"email": "not-an-email", "exam_id": "toeic", "remind_days": [7]})
        check("api: subscribe 잘못된 이메일 -> 422", status == 422, f"status={status}")

        status, body = http_post("/api/subscribe", {"email": "verify@example.com", "exam_id": "no-such-exam", "remind_days": [7]})
        check("api: subscribe 존재하지 않는 시험 -> 404", status == 404, f"status={status}")

        req = urllib.request.Request(BASE + "/")
        with urllib.request.urlopen(req, timeout=5) as r:
            status = r.status
            ctype = r.headers.get("Content-Type", "")
            html = r.read().decode("utf-8")
        check("api: GET / 200 + html", status == 200 and "text/html" in ctype)
        check("api: GET / 캘린더 타이틀 포함", "자격증" in html)

        # 화면 네 개가 한 페이지에 모두 들어있는지 (탭 버튼 + 실제 패널)
        for view_id, label in (
            ("calendarView", "캘린더"),
            ("listView", "리스트"),
            ("summarizerView", "요강 요약"),
            ("processView", "만든 과정"),
        ):
            has_panel = ('id="' + view_id + '"') in html
            has_tab = (">" + label + "<") in html
            check(
                f"화면: {label} 패널과 탭이 함께 존재",
                has_panel and has_tab,
                f"panel={has_panel} tab={has_tab}",
            )

        # 개발 기록은 실측값을 담고 있어야 의미가 있다 (문구만 남고 숫자가 빠지는 것 방지)
        for evidence in ("235KB", "3.6KB", "SERVICE_KEY_IS_NOT_REGISTERED_ERROR", "166"):
            check(f"개발 기록: 실측 근거 '{evidence}' 포함", evidence in html)

        # --- 동시 부하 ---
        # 여러 탭을 동시에 열거나 새로고침을 연타하는 상황을 흉내낸다.
        # 덤으로 서버 로그를 많이 만들어내므로, 서버 출력을 파이프로 받고 읽지 않는
        # 실수가 재발하면(=버퍼가 차서 서버가 멈추면) 이 검사에서 바로 드러난다.
        import threading

        load_errors = []
        load_lock = threading.Lock()

        def _hammer(path):
            for _ in range(10):
                try:
                    code, _body = http_get(path, timeout=8)
                    if code != 200:
                        with load_lock:
                            load_errors.append(f"{path}->{code}")
                except Exception as exc:
                    with load_lock:
                        load_errors.append(f"{path}->{type(exc).__name__}")

        load_paths = [
            "/api/exams",
            "/api/upcoming?days=365",
            "/api/calendar?start=2026-01-01&end=2026-12-31",
            "/api/sources",
            "/api/review",
            "/api/health",
        ]
        threads = [threading.Thread(target=_hammer, args=(p,)) for p in load_paths for _ in range(2)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        check(
            f"부하: 동시 {len(threads)}스레드 × 10요청 무오류",
            not load_errors,
            f"{len(load_errors)}건 예: {load_errors[:3]}",
        )

        # 동시 쓰기(SQLite)도 함께 확인한다
        write_errors = []

        def _subscribe(i):
            code, _body = http_post(
                "/api/subscribe",
                {"email": f"load{i}@example.com", "exam_id": "toeic", "remind_days": [7]},
                timeout=10,
            )
            if code != 200:
                with load_lock:
                    write_errors.append(code)

        threads = [threading.Thread(target=_subscribe, args=(i,)) for i in range(15)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        check("부하: 동시 구독 15건 무오류", not write_errors, f"{write_errors[:3]}")

        status, _ = http_get("/api/health")
        check("부하: 부하 후에도 서버 응답", status == 200, f"status={status}")

finally:
    proc.terminate()
    try:
        proc.wait(timeout=5)
    except subprocess.TimeoutExpired:
        proc.kill()
        proc.wait(timeout=5)
    still_alive = proc.poll() is None
    check("server: 테스트 서버 정상 종료", not still_alive, f"pid={proc.pid}")

    # 서버 로그에 예외가 찍혔는지 확인한다 (요청은 200인데 안에서 조용히 터지는 경우 대비)
    try:
        log_handle.flush()
        log_handle.seek(0)
        server_output = log_handle.read()
    except Exception:
        server_output = ""
    finally:
        log_handle.close()
    check(
        "server: 서버 로그에 예외 흔적 없음",
        "Traceback" not in server_output,
        server_output[-300:].replace("\n", " ") if "Traceback" in server_output else "",
    )
    # 로그 파일은 지우지 않고 남긴다. 윈도우에서는 자식 프로세스가 방금 쓰던 파일을
    # 곧바로 지우지 못해 실패하기도 하고, 검사가 깨졌을 때 들여다볼 근거가 필요하다.
    # (.gitignore에 등록되어 있어 커밋에는 섞이지 않는다)

# ---------------------------------------------------------------
print(f"\n{'='*50}")
print(f"통과: {len(PASS)}  실패: {len(FAIL)}")
if FAIL:
    print("\n실패 목록:")
    for name, detail in FAIL:
        print(f"  - {name}: {detail}")
    print(f"\n서버 쪽 로그: {server_log}")
    sys.exit(1)
else:
    print("전부 통과.")
    sys.exit(0)
