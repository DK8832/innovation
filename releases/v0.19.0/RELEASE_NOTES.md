# CERTI:ON v0.19.0 — 연결 복구 강화 · Ollama / 방화벽 / 모델 다운로드

> **개발 기록 19/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
PC 고성능 AI 연결 실패와 휴대폰 빠른 모델 다운로드 실패를 복구하는 네트워크 안정화 버전입니다.

## v0.18.0 대비 변경 사항
- Ollama API가 꺼져 있으면 ollama serve를 자동 시작하고 준비 상태를 확인합니다.
- TCP 8787을 LocalSubnet에 허용하는 Windows 방화벽 흐름과 ECONNREFUSED 진단을 추가했습니다.
- 휴대폰 빠른 모델을 Qwen3 0.6B Q4_0으로 정리하고 .part/HTTP 416 이어받기 문제를 보완했습니다.

## 기술 변경 내역
- **파일 변화:** `+4 추가 / -0 삭제 / ~7 수정`
- **내부 Flutter 버전:** `2.1.3+6`
- **대표 변경 경로:** `TEST_PC_AI_CONNECTION.bat`, `V4_BACKEND_SIMULATION.txt`, `V4_FIX_NOTES.txt`, `V4_STATIC_TEST_RESULTS.txt`, `ALLOW_PC_WIFI_FIREWALL_OPTIONAL.bat`, `PHONE_AI_MODELS.txt`, `README_FIRST_KR.txt`, `RUN_PC_AI_OPTIONAL.bat`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V4`
- **원본 수정 시각:** `2026-08-16 19:23:58 KST`
- **해당 버전 원본 Asset:** `v19__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V4__SOURCE.zip`
- **소스 파일 수:** `55`
- **SHA-256:** `1a2149836b1b6eac0f663cb34f88d7b9ed29a3b3fc14366a8f94286231bbc21b`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
