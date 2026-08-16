<!-- release-title: CERTI:ON v0.20.0 — UTF-8 스트리밍 수정 · 한글 토큰 깨짐 방지 -->

> **개발 기록 20/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
휴대폰 llama.cpp 스트리밍에서 한글이 U+FFFD(�)로 깨지는 문제의 원인을 토큰 경계 수준에서 수정한 버전입니다.

## v0.19.0 대비 변경 사항
- llama_token_to_piece가 UTF-8 문자를 중간 byte에서 나눌 수 있는 문제를 누적 버퍼 방식으로 처리했습니다.
- tools/patch_llama_utf8.ps1을 추가해 Android JNI wrapper에 패치를 적용합니다.
- V5 UTF-8 시뮬레이션/수정 기록을 포함해 재현 원인과 수정 범위를 문서화했습니다.

## 기술 변경 내역
- **파일 변화:** `+4 추가 / -1 삭제 / ~4 수정`
- **내부 Flutter 버전:** `2.1.4+7`
- **대표 변경 경로:** `V4_FIX_NOTES_PREVIOUS.txt`, `V5_FIX_NOTES.txt`, `V5_UTF8_SIMULATION.txt`, `tools/patch_llama_utf8.ps1`, `BUILD_STANDALONE_APK.bat`, `README_FIRST_KR.txt`, `RUN_CERTION.bat`, `pubspec.yaml`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V5`
- **원본 수정 시각:** `2026-08-16 19:37:08 KST`
- **해당 버전 원본 Asset:** `v20__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V5__SOURCE.zip`
- **소스 파일 수:** `58`
- **SHA-256:** `4764539aa5fc2d5bc00587e1d83744d517f4a83190f1dbcee805e61ce2e57eb5`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
