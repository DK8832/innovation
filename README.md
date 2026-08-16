# CERTI:ON — Innovation

공식 자격증·시험 일정, 일정 관리, AI 브리핑, 휴대폰 독립형 로컬 AI와 PC 고성능 Ollama AI를 결합한 Flutter 프로젝트입니다.

## 현재 버전

**v1.0.0** — `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9`

현재 `main`에는 최신 V9 소스를 기준으로 정리합니다.

## 24개 개발 버전 기록

개발 과정의 24개 프로젝트 폴더를 수정 시각 기준으로 `v0.1.0` ~ `v1.0.0`으로 정리했습니다.

- `CHANGELOG.md` — 24개 버전 전체 변경사항
- `VERSION_INDEX.csv` — 원본 폴더명 / 수정 시각 / 권장 버전 매핑
- `releases/<version>/RELEASE_NOTES.md` — 각 버전별 상세 변경사항
- 저장소 루트 — 현재 최종 버전 v1.0.0 실제 Flutter 소스

> 버전 순서는 ZIP 내부 폴더 수정 시각 기준입니다. 복사/압축 과정에서 수정 시각이 달라질 수 있으므로 Git commit 시각과 동일한 의미는 아닙니다.

## v1.0.0 핵심

- `RUN_CERTION_ALL.bat` 원클릭 실행
- Release APK 생성 및 연결된 Android 휴대폰 업데이트 설치
- 휴대폰 Qwen3 GGUF 로컬 AI
- 같은 Wi-Fi의 PC Ollama Qwen3 14B / 8B / 4B 선택형 AI
- 한글 UTF-8 토큰 깨짐 방지
- Qwen3 내부 추론 노출 차단
- 빈 응답 / `...` 응답 방어
- PC LAN 주소 자동 감지와 8787 backend 실행 자동화

## 보안

공개 저장소에는 실제 API 키, `backend/.env`, Android `local.properties`, 빌드 캐시 및 생성물을 넣지 않습니다.

과거 개발 폴더 일부의 `.env`에서 실제 API 키가 확인되어 GitHub 업로드 대상에서 제외했습니다. 아직 유효한 과거 키가 있다면 발급처에서 폐기/재발급하는 것을 권장합니다.
