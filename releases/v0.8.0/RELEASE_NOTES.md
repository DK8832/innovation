# CERTI:ON v0.8.0 — 실행 안정화 · 전체 기능 안정화 기준본

> **개발 기록 08/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
OpenAI 기반 전체 기능을 실제 시연하기 위한 실행 안정화 기준 버전입니다.

## v0.7.0 대비 변경 사항
- RUN_CERTION.bat을 중심으로 백엔드 시작과 Flutter 실행을 통합했습니다.
- AI 연결 상태/실제 오류를 사용자에게 표시하도록 백엔드와 Flutter 화면을 정리했습니다.
- Chrome/Android 환경 준비 도구와 API 키 입력 안내를 추가했습니다.

## 기술 변경 내역
- **파일 변화:** `+6 추가 / -4 삭제 / ~7 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `API_KEY_입력.bat`, `BUILD_CHECK.txt`, `RUN_CERTION.bat`, `tools/ensure_android.bat`, `tools/prepare_ai.bat`, `먼저_읽기.txt`, `.vscode/launch.json`, `.vscode/tasks.json`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_FULL_FIXED`
- **원본 수정 시각:** `2026-08-16 11:09:16 KST`
- **해당 버전 원본 Asset:** `v08__CERTI_ON_OGQ_FULL_FIXED__SOURCE.zip`
- **소스 파일 수:** `52`
- **SHA-256:** `5a68387c767b7caefe35eb74d21829d5e4d5e5ed1d2d47b1ffdd337ea99d0584`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
