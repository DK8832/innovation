# CERTI:ON v0.17.0 — Android 빌드 강화 · Gradle / SDK 검증

> **개발 기록 17/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
Standalone 구조에서 Android release 빌드가 Flutter/AGP 조합에 따라 실패하던 문제를 줄이기 위한 빌드 하드닝 버전입니다.

## v0.16.0 대비 변경 사항
- Gradle release 설정에서 code shrinking/resource shrinking 조건을 명시적으로 검증합니다.
- verify_android_gradle.ps1과 V2 시뮬레이션 보고서를 추가했습니다.
- release 실패 시 테스트 지속을 위한 ARM64 debug fallback 경로를 보강했습니다.

## 기술 변경 내역
- **파일 변화:** `+2 추가 / -0 삭제 / ~9 수정`
- **내부 Flutter 버전:** `2.1.1+4`
- **대표 변경 경로:** `V2_SIMULATION_REPORT.txt`, `tools/verify_android_gradle.ps1`, `BUILD_STANDALONE_APK.bat`, `README.md`, `README_FIRST_KR.txt`, `RUN_CERTION.bat`, `SIMULATION_REPORT.txt`, `STATIC_TEST_RESULTS.txt`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V2`
- **원본 수정 시각:** `2026-08-16 18:51:06 KST`
- **해당 버전 원본 Asset:** `v17__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V2__SOURCE.zip`
- **소스 파일 수:** `49`
- **SHA-256:** `4488ad9ce728e5abe69cabf6dd0b6f2fbb52e1ccd096de4b418af5e5598c23e5`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
