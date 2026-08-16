# CERTI:ON v0.18.0 — 툴체인 안정화 · NDK 고정·LAN 자동 탐색

> **개발 기록 18/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
Android 네이티브 빌드 도구 버전과 PC AI 네트워크 탐색을 고정·자동화한 버전입니다.

## v0.17.0 대비 변경 사항
- Android NDK를 28.2.13676358로 고정하고 누락 시 자동 설치/검증하도록 수정했습니다.
- 같은 Wi-Fi의 PC AI 주소를 자동 탐색하고 사용자에게 표시하는 도구를 추가했습니다.
- 정적/구성 시뮬레이션 결과 67/67 PASS 기록을 포함했습니다.

## 기술 변경 내역
- **파일 변화:** `+3 추가 / -1 삭제 / ~10 수정`
- **내부 Flutter 버전:** `2.1.2+5`
- **대표 변경 경로:** `SHOW_PC_AI_SERVER_ADDRESS.bat`, `V3_FIX_NOTES.txt`, `V3_SIMULATION_REPORT.txt`, `README.md`, `README_FIRST_KR.txt`, `RUN_PC_AI_OPTIONAL.bat`, `SIMULATION_REPORT.txt`, `STATIC_TEST_RESULTS.txt`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V3`
- **원본 수정 시각:** `2026-08-16 19:06:26 KST`
- **해당 버전 원본 Asset:** `v18__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V3__SOURCE.zip`
- **소스 파일 수:** `51`
- **SHA-256:** `538b69e00fac7c08a37903d2bebc38b6c2dacd41d174e4bda3bbe8005aa57d9b`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
