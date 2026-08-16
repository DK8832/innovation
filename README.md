# CERTI:ON — Qualification Schedule & AI Planner

CERTI:ON은 여러 기관에 흩어진 자격증·시험의 공식 일정을 한곳에서 확인하고, 일정 관리·관심 자격증·비교·AI 브리핑·학습 계획까지 연결하는 Flutter 기반 통합 플랫폼입니다.

## Current stable release

**CERTI:ON v1.0.0 — Competition Final · One-Click Integrated Runtime**

최종 스냅샷은 `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9`이며, Android 휴대폰 온디바이스 AI와 선택형 PC Ollama AI를 함께 지원합니다.

### v1.0.0 highlights
- `RUN_CERTION_ALL.bat` 하나로 Android SDK/NDK/CMake 점검부터 APK 빌드·업데이트 설치까지 자동화
- 휴대폰 Qwen3 1.7B/0.6B GGUF 온디바이스 AI
- 같은 Wi-Fi의 PC Ollama Qwen3 14B/8B/4B 고성능 AI
- PC LAN IPv4 자동 탐지 및 TCP 8787 backend/방화벽 처리
- 한글 UTF-8 token streaming 보호
- Qwen3 내부 reasoning 노출 방지
- 빈 응답·`...` placeholder 응답 이중 방어
- 공식 일정 데이터 메모리 로드 및 실행 스크립트 정리

## Release history policy

개발 과정의 **24개 실제 프로젝트 폴더**를 원본 폴더의 수정 시각(KST) 순서로 보존합니다.

- `v0.1.0` ~ `v0.23.0`: **Development / Pre-release snapshots**
- `v1.0.0`: **Stable competition final**
- 각 Release의 표시 이름은 `버전 — 개발 단계 · 핵심 변화` 형식으로 통일
- 각 Release 설명은 직전 스냅샷 대비 실제 파일 차이를 기준으로 작성

> 이 기록은 Git commit 생성 시각이 아니라, 사용자가 보관한 원본 프로젝트 폴더의 수정 시각을 기준으로 한 역사 아카이브입니다. 따라서 v0.2.0처럼 기능을 의도적으로 줄인 실험 스냅샷도 포함되며, 모든 버전이 단조롭게 기능이 증가하는 관계는 아닙니다.

## Historical source assets

각 GitHub Release에는 해당 시점의 실제 프로젝트를 보존한 별도 `__SOURCE.zip` Asset이 있습니다.

**중요:** GitHub가 자동으로 표시하는 `Source code (zip)` / `Source code (tar.gz)`는 Release tag가 가리키는 저장소 스냅샷입니다. 역사 버전의 실제 프로젝트 원본은 각 Release에 별도로 첨부된 `vXX__...__SOURCE.zip`을 기준으로 확인합니다.

각 historical asset은 SHA-256으로 검증되며, `.github/workflows/publish-version-releases.yml`이 **24개 Release의 asset 이름·업로드 상태·SHA-256·표시 제목·pre-release 상태를 자동 감사**합니다.

## Repository documents

- `release_catalog/part-*.json` — 24개 Release의 단일 기준 데이터(tag/title/source asset/SHA-256/원본 시각)
- `CHANGELOG.md` — 최신 → 최초 순서의 전체 개발 이력
- `VERSION_INDEX.csv` — 원본 폴더명, 수정 시각, 버전 매핑
- `releases/<version>/RELEASE_NOTES.md` — 각 버전의 상세 변경사항 및 무결성 정보

## Security & reproducibility

공개 historical source package에는 실제 API 키나 로컬 머신 전용 설정을 포함하지 않습니다.

제외 대상:
- `backend/.env`
- `local.properties`
- `build/`, `.dart_tool/`, Gradle cache, `node_modules/` 등 재생성 가능한 산출물

과거 개발 폴더 일부에서 비밀키 형식이 확인된 이력이 있어 공개용 아카이브에서는 해당 파일을 제거했습니다. 소스 archive는 실행 가능한 프로젝트 구조를 보존하되, 비밀정보와 빌드 캐시는 포함하지 않는 것을 원칙으로 합니다.
