<!-- release-title: CERTI:ON v0.5.0 — 클라우드 AI 연동 · OpenAI 실행 환경 자동화 -->

> **개발 기록 05/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
OpenAI 백엔드를 실제 실행 환경에서 사용하기 위한 설정·런타임·Android 보조 도구를 강화한 버전입니다.

## v0.4.0 대비 변경 사항
- API 키 설정용 BAT와 사용자 안내 문서를 추가했습니다.
- backend/server.mjs와 Flutter AI 호출 처리를 확장해 오류/응답 흐름을 보강했습니다.
- Android 설정 자동화 PowerShell 도구를 추가했습니다. 공개 archive에서는 과거 .env 비밀값을 제거했습니다.

## 기술 변경 내역
- **파일 변화:** `+3 추가 / -0 삭제 / ~11 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `AI_키_연결방법.txt`, `SET_OPENAI_KEY.bat`, `tools/configure_android.ps1`, `.gitignore`, `API_INTEGRATION.md`, `BUILD_REPORT.txt`, `ONE_CLICK_RUN.bat`, `README.md`

## 보관된 원본 소스
- **원본 폴더:** `certi_on_ogq_ultimate3`
- **원본 수정 시각:** `2026-08-16 01:42:48 KST`
- **해당 버전 원본 Asset:** `v05__certi_on_ogq_ultimate3__SOURCE.zip`
- **소스 파일 수:** `61`
- **SHA-256:** `dbd5cd6d560233971f3a1973f6443598176b3a1ae426e7f6f8b84ea16a7ed37e`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
