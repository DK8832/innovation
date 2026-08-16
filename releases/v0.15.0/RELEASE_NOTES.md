<!-- release-title: CERTI:ON v0.15.0 — 다중 AI 모델 지원 · 14B / 8B / 4B 선택 -->

> **개발 기록 15/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
PC 성능에 따라 AI 모델을 앱에서 즉시 선택할 수 있도록 다중 모델 운영 기능을 완성한 버전입니다.

## v0.14.0 대비 변경 사항
- 앱에서 높음/보통/낮음으로 qwen3:14b, 8b, 4b를 선택하도록 UI/백엔드를 연결했습니다.
- qwen3:4b 설치·선택 스크립트와 MODEL_SETUP.txt를 추가했습니다.
- 생성 요청의 강제 timeout을 제거해 큰 로컬 모델의 긴 응답 시간을 허용했습니다.

## 기술 변경 내역
- **파일 변화:** `+3 추가 / -0 삭제 / ~7 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `INSTALL_QWEN4B.bat`, `MODEL_SETUP.txt`, `USE_QWEN4B.bat`, `PREPARE_AI.bat`, `README.md`, `RUN_CERTION.bat`, `RUN_CHROME_AI.bat`, `START_BACKEND.bat`

## 보관된 원본 소스
- **원본 폴더:** `FINAL_ULTIMATE_CERTI_ON_OGQ_AI_MODEL_SELECTOR_NO_TIMEOUT`
- **원본 수정 시각:** `2026-08-16 14:03:24 KST`
- **해당 버전 원본 Asset:** `v15__FINAL_ULTIMATE_CERTI_ON_OGQ_AI_MODEL_SELECTOR_NO_TIMEOUT__SOURCE.zip`
- **소스 파일 수:** `82`
- **SHA-256:** `b2ad91fa37c61a76a39d98042c869ea5cc11cd62f101423628ea92278a2c2bfa`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
