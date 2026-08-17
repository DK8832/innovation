# CERTI:ON Web — 자격증·시험 일정 통합 서비스

> 여러 기관에 흩어진 자격증·시험의 **공식 일정 정보를 한곳에 모으고**, 사용자가 접수·시험·발표 일정을 놓치지 않도록 D-Day, 통합 캘린더, 공식 출처 확인, 모집요강 요약 기능을 제공하는 웹 서비스입니다.

## 1. 문제 정의

자격증과 시험 일정은 큐넷(Q-Net), 대한상공회의소 자격평가사업단, 한국사능력검정시험, TOEIC 등 서로 다른 기관 사이트에 분산되어 있습니다. 사용자는 시험마다 다른 사이트를 찾아가 접수 시작일·마감일·시험일·합격자 발표일을 반복해서 확인해야 하며, 일정이 변경되거나 아직 발표되지 않은 경우 잘못된 정보를 믿을 위험도 있습니다.

CERTI:ON Web은 이 문제를 다음 원칙으로 해결합니다.

- **공식 1차 출처 우선**: AI가 날짜를 만들어내지 않고 공식 사이트·공공데이터를 기준으로 확인합니다.
- **미발표 일정 추측 금지**: 확인되지 않은 날짜는 임의로 채우지 않고 `날짜 확인 필요`로 표시합니다.
- **상시시험을 고정일로 조작하지 않음**: 컴퓨터활용능력·OPIc처럼 상시 운영되는 시험은 별도 영역으로 구분합니다.
- **자동 수집 결과를 바로 반영하지 않음**: 공공데이터와 기존 일정이 다르면 검토 큐에 쌓고 사람이 확인한 뒤 반영하도록 설계했습니다.
- **AI는 설명 보조 역할**: 날짜·숫자처럼 중요한 값은 규칙 기반으로 추출하고, 생성형 AI는 서술형 정보 정리에만 선택적으로 사용합니다.

## 2. 주요 기능

- **통합 캘린더 / 리스트**: 여러 기관의 시험을 월별 캘린더와 임박순 목록으로 확인
- **D-Day 표시**: 접수 마감·시험·발표까지 남은 기간을 중요도에 따라 표시
- **카테고리·검색 필터**: 국가기술자격, 상공회의소 자격, 한국사, 어학시험을 빠르게 탐색
- **상시시험 별도 표시**: 날짜가 고정되지 않은 시험을 별도 카드로 안내
- **공식 출처 링크**: 시험 상세에서 주관기관 공식 홈페이지로 바로 이동
- **모집요강 요약**: 공고문 원문에서 접수·시험·발표 날짜와 응시자격·시험과목·합격기준을 구조화
- **데이터 출처 상태 표시**: 현재 어떤 데이터가 큐레이션인지, 공공 API가 연결되었는지, AI 보강이 켜졌는지 사용자에게 공개
- **이메일 마감 알림 구조**: SMTP가 설정된 서버 환경에서 D-14 / D-7 / D-1 알림 발송 가능
- **Android 앱 연결**: 웹에서 CERTI:ON v2.0.0 Android APK Release로 이동 가능
- **개발 과정 공개**: 크롤링 한계와 데이터 수집 방식 변경 이유를 서비스 안에서 확인 가능

## 3. 시스템 아키텍처

```text
[공식 사이트 직접 확인] ───────────────┐
                                        │
[공공데이터포털 국가자격 API] ─→ 정규화 ├─→ 변경 감지 → 검토 큐 → 검증된 일정 데이터
                                        │
                                        ▼
                              FastAPI Backend
                     ┌──────────┼───────────┐
                     │          │           │
                 시험 API   모집요강 요약   이메일 알림
                     │          │           │
                     └──────────┼───────────┘
                                ▼
                    HTML / CSS / Vanilla JS
                                │
              ┌─────────────────┴─────────────────┐
              ▼                                   ▼
       로컬 Full-Stack 실행               GitHub Pages 공개 데모
       (FastAPI 기능 전체)                 (정적 API Adapter 사용)
```

### 데이터 처리 원칙

1. 공식 데이터 또는 사람이 확인한 큐레이션 데이터를 기본값으로 사용합니다.
2. 공공 API의 값이 기존 일정과 다르더라도 자동으로 덮어쓰지 않습니다.
3. 모집요강의 날짜는 생성형 AI에 전달하지 않고 정규식으로만 추출합니다.
4. AI가 보강한 서술형 항목은 원문 대조(grounding)를 통과한 경우만 사용합니다.

## 4. 기술 스택

| 구분 | 사용 기술 |
|---|---|
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Backend | Python 3.10+, FastAPI, Uvicorn |
| Validation / Schema | Pydantic |
| Storage | JSON, SQLite |
| Mail | Python `smtplib` 기반 SMTP |
| Public Data | 공공데이터포털 국가자격 시험일정 API(선택) |
| AI | Groq API + `llama-3.3-70b-versatile` 선택적 보강 |
| Fonts | Pretendard, Space Grotesk |
| Hosting 준비 | GitHub Pages 정적 공개 데모 + 로컬 FastAPI Full-Stack |
| License | MIT License |

## 5. 실행 방법

### Windows 원클릭 실행

```bat
run_server.bat
```

실행하면 가상환경 생성 → Python 의존성 설치 → FastAPI 서버 실행 → 브라우저 열기 순서로 진행됩니다.

기본 접속 주소:

```text
http://127.0.0.1:8000
```

### 수동 실행

```bash
python -m venv .venv
# Windows
.venv\Scripts\python -m pip install -r backend\requirements.txt
.venv\Scripts\python backend\main.py

# macOS / Linux
source .venv/bin/activate
pip install -r backend/requirements.txt
python backend/main.py
```

### 자동 검증

```bash
python verify_all.py
```

`verify_all.py`는 데이터 스키마, D-Day 계산, 요약 규칙, 프론트엔드 정적 검사, 실제 FastAPI 기동 후 API 응답 등을 검사하도록 구성되어 있습니다.

## 6. 웹에서 바로 접속하기

공개 웹 주소로 사용할 예정인 URL:

```text
https://dk8832.github.io/innovation/
```

GitHub Pages는 저장소의 `gh-pages` 브랜치에 공개용 정적 웹을 배치하는 방식으로 준비했습니다. 최초 1회 GitHub 저장소의 **Settings → Pages → Build and deployment → Deploy from a branch → `gh-pages` / `(root)` → Save**를 선택하면 위 주소로 접속할 수 있습니다.

> 공개 Pages 버전은 별도 서버가 없는 정적 환경이므로 일정 조회·캘린더·리스트·검색·상시시험·모집요강 규칙 기반 요약 등은 브라우저 안에서 동작합니다. 실제 이메일 발송, 공공데이터 동기화, 서버 측 AI 호출은 로컬/서버 Full-Stack 실행에서 사용합니다.

### 검색엔진 노출 준비

공개 프론트엔드에는 다음 항목을 포함했습니다.

- `robots.txt` — 검색엔진 크롤링 허용
- `sitemap.xml` — 공개 사이트 주소 안내
- `meta description` / `canonical` / Open Graph 메타데이터
- `robots` 메타태그 `index,follow`

검색엔진에 실제로 노출되는 시점은 각 검색엔진의 크롤링 일정에 따라 달라질 수 있습니다.

## 7. 환경변수 및 선택 기능

핵심 일정 조회 기능은 API 키가 없어도 동작합니다. 아래 값은 선택 사항입니다.

```text
SMTP_HOST
SMTP_PORT=587
SMTP_USER
SMTP_PASS
DATA_GO_KR_KEY
GROQ_API_KEY
```

- SMTP 미설정: 알림 발송을 실제로 하지 않습니다.
- `DATA_GO_KR_KEY` 미설정: 큐레이션된 공식 확인 데이터를 사용합니다.
- `GROQ_API_KEY` 미설정: 모집요강 요약은 규칙 기반으로 동작합니다.

비밀키는 GitHub 저장소에 직접 커밋하지 않습니다.

## 8. 데이터 출처

현재 데이터는 다음 공식 출처를 우선 확인하여 정리하도록 설계했습니다.

- Q-Net / 한국산업인력공단 — https://www.q-net.or.kr
- 대한상공회의소 자격평가사업단 — https://license.korcham.net
- 한국사능력검정시험 — https://www.historyexam.go.kr
- TOEIC — https://exam.toeic.co.kr
- TOEIC Speaking — https://www.toeicswt.co.kr
- OPIc — https://www.opic.or.kr
- 공공데이터포털 — https://www.data.go.kr

저장된 일정이 있더라도 **최종 접수·응시 전에는 각 주관기관의 최신 공식 공고를 다시 확인하는 것을 원칙**으로 합니다.

## 9. AI 사용 내역

### 서비스 내부 AI

- 선택적 AI 보강: **Groq API / `llama-3.3-70b-versatile`**
- 사용 범위: 응시자격·시험과목·합격기준 등 서술형 항목을 읽기 쉽게 정리
- 사용하지 않는 범위: 접수일·시험일·발표일 등 날짜 생성
- 안전장치: AI 출력이 원문에 근거하는지 다시 대조하고, 근거가 부족하면 결과를 폐기하고 규칙 기반 값으로 되돌립니다.
- API 키가 없어도 핵심 서비스가 작동하도록 AI는 필수 의존성이 아닙니다.

### 개발 과정에서 사용한 생성형 AI

- **OpenAI ChatGPT**를 아이디어 정리, 코드 구조 검토, 오류 원인 분석, 문서/README 정리 등 개발 보조 목적으로 사용했습니다.
- 생성형 AI가 만든 결과를 그대로 공식 일정 데이터로 사용하지 않았으며, 일정 정보는 공식 출처 또는 코드에 포함된 검증 데이터 기준으로 분리했습니다.

## 10. 외부 사용 내역

### 오픈소스 / 외부 패키지

- FastAPI
- Uvicorn
- Pydantic (`email` validation 포함)
- Pretendard Web Font
- Space Grotesk (Google Fonts)
- Python 표준 라이브러리: `sqlite3`, `smtplib`, `urllib`, `json`, `zoneinfo` 등

### 외부 API / 서비스

- 공공데이터포털 국가자격 시험일정 API — 선택 기능
- Groq API — 선택적 AI 보강 기능
- GitHub / GitHub Releases / GitHub Pages — 소스 관리, 앱 배포, 공개 웹 데모

### 외부 자문

현재 README에 별도로 기재할 교사·현직자 등 외부 자문은 없습니다. 실제 외부 자문을 받은 경우 대회 제출 전 자문자와 자문 범위를 이 항목에 추가합니다.

## 11. 프로젝트 구조

```text
웹/
├─ frontend/
│  ├─ index.html
│  ├─ style.css
│  ├─ app.js
│  ├─ static_api.js
│  ├─ robots.txt
│  └─ sitemap.xml
├─ backend/
│  ├─ main.py
│  ├─ store.py
│  ├─ subscriptions.py
│  ├─ mailer.py
│  ├─ models.py
│  ├─ data/exams.json
│  └─ sources/
├─ docs/
│  └─ DATA_SOURCES.md
├─ run_server.bat
├─ sync_sources.py
├─ verify_all.py
├─ requirements.txt
├─ APK_SHA256.txt
├─ LICENSE
└─ README.md
```

## 12. Android 앱

Android 설치 파일은 저장소 Release에서 제공합니다.

- Releases: https://github.com/DK8832/innovation/releases
- v2.0.0 APK: https://github.com/DK8832/innovation/releases/download/v2.0.0/CERTI_ON_v2.0.0_ANDROID.apk
- SHA-256: `9a5e6a41cb547846a9f98bac7a88a0bbdf8ac1c686522045fad14bb854a31784`

웹 소스 폴더에는 동일 APK를 중복 저장하지 않고 Release 파일을 연결합니다.

## 13. 라이선스

이 프로젝트의 웹 코드에는 저장소의 [MIT License](LICENSE)가 적용됩니다.

## 14. 팀

**innovation** — 황재찬, 한서호, 이주하, 송지율
