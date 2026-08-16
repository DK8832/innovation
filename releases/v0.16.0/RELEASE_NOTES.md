<!-- release-title: CERTI:ON v0.16.0 — 독립형 AI 아키텍처 · 온디바이스 우선 구조 -->

> **개발 기록 16/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
PC 의존 AI에서 Android 휴대폰 자체 GGUF 추론을 기본으로 바꾼 가장 큰 아키텍처 전환 버전입니다.

## v0.15.0 대비 변경 사항
- 휴대폰 Qwen3 1.7B/0.6B 온디바이스 AI를 기본 모드로 도입했습니다.
- PC Ollama 14B/8B/4B는 동일 Wi-Fi에서 사용하는 선택 옵션으로 분리했습니다.
- 기존 Android wrapper를 보관하는 대신 실행 시 생성/검증하는 구조로 단순화하고 standalone 빌드 도구를 추가했습니다.

## 기술 변경 내역
- **파일 변화:** `+12 추가 / -47 삭제 / ~7 수정`
- **내부 Flutter 버전:** `2.1.0+3`
- **대표 변경 경로:** `ALLOW_PC_WIFI_FIREWALL_OPTIONAL.bat`, `BUILD_STANDALONE_APK.bat`, `MOCK_BACKEND_TEST.txt`, `PHONE_AI_MODELS.txt`, `README_FIRST_KR.txt`, `RESET_ANDROID_FOR_CURRENT_FLUTTER.bat`, `RUN_PC_AI_OPTIONAL.bat`, `SIMULATION_REPORT.txt`

## 보관된 원본 소스
- **원본 폴더:** `FINAL_FINAL_ULTIMATE_CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED`
- **원본 수정 시각:** `2026-08-16 18:37:54 KST`
- **해당 버전 원본 Asset:** `v16__FINAL_FINAL_ULTIMATE_CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED__SOURCE.zip`
- **소스 파일 수:** `47`
- **SHA-256:** `ec52a9f0d3aa472d886f4ad49092ef1bd4c08b8c039d2c5d396e2d2f7ca535bf`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
