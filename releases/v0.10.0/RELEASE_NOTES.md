<!-- release-title: CERTI:ON v0.10.0 — 로컬 AI 전환 · Ollama + Qwen3 아키텍처 -->

> **개발 기록 10/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
클라우드 API 의존 구조에서 PC 로컬 Ollama + Qwen3로 AI 아키텍처를 전환한 주요 버전입니다.

## v0.9.0 대비 변경 사항
- 기본 모델을 qwen3:14b로 설정하고 8B 경량/30B 최대 모델 선택 스크립트를 추가했습니다.
- 공식 일정 데이터를 프롬프트 문맥으로 넣는 로컬 RAG형 응답 구조를 backend/server.mjs에 반영했습니다.
- API 키 없이 로컬 모델을 설치·실행하는 RUN_CERTION/INSTALL_LOCAL_AI 흐름을 구성했습니다.

## 기술 변경 내역
- **파일 변화:** `+4 추가 / -0 삭제 / ~11 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `INSTALL_LOCAL_AI.bat`, `USE_LIGHT_MODEL.bat`, `USE_MAX_MODEL.bat`, `USE_SMART_MODEL.bat`, `.vscode/launch.json`, `.vscode/settings.json`, `.vscode/tasks.json`, `README.md`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_LOCAL_AI_SMART`
- **원본 수정 시각:** `2026-08-16 12:08:46 KST`
- **해당 버전 원본 Asset:** `v10__CERTI_ON_OGQ_LOCAL_AI_SMART__SOURCE.zip`
- **소스 파일 수:** `55`
- **SHA-256:** `c1d8c64d8417acc5b432eb461fdfe691a1ede5664a95a2e86275ef9c04f738f4`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
