# CERTI:ON v0.12.0 — Android 네이티브 기준본 · 기존 UI + Qwen3 14B

> **개발 기록 12/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
원래 CERTI:ON UI와 기능을 유지하면서 Ollama Qwen3 14B 로컬 AI를 결합하고 Android 네이티브 wrapper를 프로젝트에 포함한 버전입니다.

## v0.11.0 대비 변경 사항
- Android Gradle 프로젝트 전체를 포함해 네이티브 빌드 기준선을 마련했습니다.
- AI 구조를 Flutter → Node :8787 → Ollama :11434 → qwen3:14b로 정리했습니다.
- 기존 공식 일정/이미지/플래너/비교 기능은 유지했습니다.

## 기술 변경 내역
- **파일 변화:** `+30 추가 / -9 삭제 / ~10 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `ONE_CLICK_RUN.bat`, `PREPARE_AI.bat`, `RUN_CHROME_AI.bat`, `USE_QWEN14B.bat`, `USE_QWEN8B.bat`, `android/.gitignore`, `android/app/build.gradle.kts`, `android/app/src/debug/AndroidManifest.xml`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_ORIGINAL_LOCAL_QWEN14B`
- **원본 수정 시각:** `2026-08-16 13:27:22 KST`
- **해당 버전 원본 Asset:** `v12__CERTI_ON_OGQ_ORIGINAL_LOCAL_QWEN14B__SOURCE.zip`
- **소스 파일 수:** `77`
- **SHA-256:** `d1b6cc340aa9b17448cb7901f75d9e902b8e7c8ecd9cd4c0d5306c0d8b0265be`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
