# CERTI:ON v1.0.0 — 대회 최종본 · 원클릭 통합 실행

> **대회 제출용 안정 버전 24/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
CERTI:ON의 대회 제출용 최종 통합/최적화 버전입니다. 여러 실행 파일을 하나의 원클릭 런처로 합치고 빌드·설치·PC AI 선택 경로를 자동화했습니다.

## v0.23.0 대비 변경 사항
- RUN_CERTION_ALL.bat 하나가 SDK/NDK/CMake 확인, Android 준비, UTF-8 패치, ARM64 release APK 빌드, adb 업데이트 설치를 수행합니다.
- PC Wi-Fi IPv4 자동 탐지, 방화벽 8787 설정, Ollama 확인/시작, Node backend 실행, 휴대폰 앱 실행까지 연결합니다.
- 다운로드된 휴대폰 GGUF 모델을 보존하도록 자동 uninstall을 제거하고 Android wrapper 재사용/실패 시 rebuild 전략을 적용했습니다.
- backend 공식 일정 JSON을 메모리로 로드하고 중복 스크립트·과거 보고서를 정리했습니다.

## 기술 변경 내역
- **파일 변화:** `+4 추가 / -39 삭제 / ~5 수정`
- **내부 Flutter 버전:** `2.2.0+9`
- **대표 변경 경로:** `README_KR.txt`, `RUN_CERTION_ALL.bat`, `tools/ensure_firewall.ps1`, `tools/start_pc_ai.ps1`, `.gitignore`, `backend/server.mjs`, `lib/main.dart`, `pubspec.yaml`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9`
- **원본 수정 시각:** `2026-08-16 21:09:12 KST`
- **해당 버전 원본 Asset:** `v24__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9__SOURCE.zip`
- **소스 파일 수:** `35`
- **SHA-256:** `593953ad21fc32471885348da3683c23afcc3e6fdf01f75f07c5267e8e688bd5`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
