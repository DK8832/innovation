# CERTI:ON Changelog

24개 프로젝트 폴더를 수정 시각 기준으로 정리한 버전 기록입니다. 폴더 수정 시각은 Git commit 시각이 아니라 개발 파일 메타데이터 기준입니다.

## 2026-08-15

### v0.1.0 — 초기 ULTIMATE 통합본
- 원본: `certi_on_ogq_ultimate`
- 홈/탐색/일정/AI 브리핑/MY의 5탭 구조 확립
- 공식 고정 일정 101건 + 상시시험 6종의 오프라인 데이터 구조 구성
- Node backend, 공식 출처 검증, 원클릭 실행/동기화 설계 포함

## 2026-08-16

### v0.2.0 — 경량 OGQ 시제품
- 원본: `certi_on_ogq`
- 핵심 UI와 일정 흐름만 남긴 경량 데모형 브랜치

### v0.3.0 — 이미지·카테고리 자산 강화
- 원본: `certi_on_ogq_ultimate1`
- 카테고리 및 기능 카드 이미지 자산 확대

### v0.4.0 — 이미지 렌더링/UI 안정화
- 원본: `certi_on_ogq_ultimate2`
- 이미지 렌더링 단순화, 카드 레이아웃 안정화

### v0.5.0 — OpenAI 실연동·키 설정 자동화
- 원본: `certi_on_ogq_ultimate3`
- OpenAI backend 연결, API 키 설정 BAT, timeout/오류 처리 추가

### v0.6.0 — 프로젝트 정리본
- 원본: `certi_on_ogq_ultimate4`
- 중복 파일/스크립트 제거, 실행 구조 단순화

### v0.7.0 — Flutter HTTP·VS Code AI 실행 강화
- 원본: `z_real_final_final_final_certi_on_ogq_ai_fixed`
- `package:http`, VS Code launch/task, AI backend 준비 흐름 강화

### v0.8.0 — OpenAI FULL FIXED
- 원본: `CERTI_ON_OGQ_FULL_FIXED`
- `RUN_CERTION.bat` 중심 실행, backend/API 연결 안정화

### v0.9.0 — Web/Android 로컬 연결 수정
- 원본: `CERTI_ON_OGQ_FULL_FIXED_V2`
- ListTile assertion, CORS/private-network, 로컬 포트 충돌 문제 수정

### v0.10.0 — Ollama Qwen3 전환
- 원본: `CERTI_ON_OGQ_LOCAL_AI_SMART`
- 클라우드 API 제거, PC Ollama + Qwen3 로컬 AI로 전환

### v0.11.0 — Windows 로컬 AI 실행 정리
- 원본: `CERTI_ON_OGQ_LOCAL_AI_SMART_V2`
- Ollama 설치/모델 전환 BAT 및 Windows 실행 안정성 개선

### v0.12.0 — Qwen3 14B 원본 UI 통합
- 원본: `CERTI_ON_OGQ_ORIGINAL_LOCAL_QWEN14B`
- 기존 UI 유지 + Node:8787 → Ollama:11434 → qwen3:14b 구조

### v0.13.0 — 스마트 채팅 강화
- 원본: `CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED`
- 앱 자체 설명, 시험 사실/학습전략 질문 구분, 공식 데이터 우선 규칙 강화

### v0.14.0 — Chrome 실행 안정화
- 원본: `CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED_V2`
- backend → Flutter web-server → Chrome 실행 흐름 정리

### v0.15.0 — 14B/8B/4B 선택 + 생성 timeout 제거
- 원본: `FINAL_ULTIMATE_CERTI_ON_OGQ_AI_MODEL_SELECTOR_NO_TIMEOUT`
- 앱 안에서 모델 선택, 장시간 14B 생성 허용

### v0.16.0 — 휴대폰 완전 독립형 AI
- 원본: `FINAL_FINAL_ULTIMATE_CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED`
- llama.cpp 기반 휴대폰 GGUF 추론 도입
- Qwen3 1.7B/0.6B 다운로드·보관·삭제·이어받기
- PC 14B/8B/4B는 같은 Wi-Fi의 선택형 고성능 모드로 유지

### v0.17.0 — Flutter 3.47/AGP release 수정
- 원본: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V2`
- minify/resource shrinking 설정 정합성 수정, release build fallback 강화

### v0.18.0 — NDK 28.2 통일·Wi-Fi 주소 안내
- 원본: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V3`
- NDK 28.2.13676358 고정, PC 서버 주소 자동 안내

### v0.19.0 — Ollama 자동기동·0.6B 다운로드 복구
- 원본: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V4`
- Ollama 자동 실행, 방화벽/연결 검사, 빠른 모델 URL·resume 복구

### v0.20.0 — 한글 UTF-8 토큰 깨짐 수정
- 원본: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V5`
- llama.cpp 토큰 경계에서 잘리던 멀티바이트 UTF-8을 버퍼링해 한글 `�` 문제 수정

### v0.21.0 — Qwen3 빈 답변 수정·APK Builder
- 원본: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V6`
- `think=false`, `/no_think`, chat retry, `/api/generate` fallback
- 원클릭 release APK 생성기 추가

### v0.22.0 — 내부 추론 노출 차단·Gradle lock 대응
- 원본: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V7`
- Qwen3 reasoning 노출 감지/재생성
- stale Gradle/Kotlin daemon 종료 및 lock 완화

### v0.23.0 — `...` 응답 차단·stale backend 방지
- 원본: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V8`
- 빈 문자열/`...`/기호만 있는 답변 거부
- 이전 backend 종료 및 V8 버전 확인
- 3회 연속 응답 검증 스크립트 추가

### v1.0.0 — V9 원클릭 최적화 최종본
- 원본: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9`
- `RUN_CERTION_ALL.bat` 하나로 SDK/NDK/CMake → APK → 휴대폰 업데이트 → Wi-Fi IP → 방화벽 → Ollama → backend → 앱 실행 통합
- `adb install -r`로 휴대폰에 받은 GGUF 모델 보존
- Android wrapper 재사용 및 실패 시에만 clean/rebuild
- backend 공식 일정 JSON 메모리 캐시, 중복 API/스크립트 정리
- 휴대폰 독립형 AI + PC 고성능 AI + UTF-8/reasoning/blank-response 보호 유지
