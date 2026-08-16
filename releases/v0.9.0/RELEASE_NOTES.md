# CERTI:ON v0.9.0 — 웹 안정성 개선 · 백엔드 포트 분리·실행 수정

> **개발 기록 09/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
Flutter Web와 로컬 백엔드에서 실제 발생한 두 가지 장애를 수정한 안정화 버전입니다.

## v0.8.0 대비 변경 사항
- Flutter Web의 ListTile background/ink assertion 종료 문제를 수정했습니다.
- localhost 백엔드 Failed to fetch 충돌을 줄이기 위해 이 계열의 포트를 8791로 분리했습니다.
- Node 런처(run_certi.mjs/start_backend_once.mjs)를 추가해 백엔드 중복 실행과 시작 순서를 제어했습니다.

## 기술 변경 내역
- **파일 변화:** `+3 추가 / -4 삭제 / ~9 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `.vscode/settings.json`, `tools/run_certi.mjs`, `tools/start_backend_once.mjs`, `.vscode/launch.json`, `.vscode/tasks.json`, `README.md`, `RUN_CERTION.bat`, `START_BACKEND.bat`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_FULL_FIXED_V2`
- **원본 수정 시각:** `2026-08-16 11:40:18 KST`
- **해당 버전 원본 Asset:** `v09__CERTI_ON_OGQ_FULL_FIXED_V2__SOURCE.zip`
- **소스 파일 수:** `51`
- **SHA-256:** `f0d5ad8c4cf0b9708b04490fa4cbcc87810910b40f7457310c2947a6ded70c9a`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
