# CERTI:ON v0.13.0 — 스마트 채팅 문맥 개선 · 프롬프트·응답 파이프라인 수정

> **개발 기록 13/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
Qwen3 14B가 CERTI:ON의 기능과 공식 일정 문맥을 더 정확히 이해하도록 채팅 경로를 수정한 버전입니다.

## v0.12.0 대비 변경 사항
- backend/server.mjs의 시스템/문맥 프롬프트와 응답 처리를 조정했습니다.
- lib/main.dart의 AI 요청/표시 로직을 함께 수정해 프런트와 백엔드 동작을 맞췄습니다.
- UI 전체를 바꾸지 않고 채팅 품질과 문맥 전달에 변경 범위를 집중했습니다.

## 기술 변경 내역
- **파일 변화:** `+0 추가 / -0 삭제 / ~3 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `README.md`, `backend/server.mjs`, `lib/main.dart`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED`
- **원본 수정 시각:** `2026-08-16 13:38:06 KST`
- **해당 버전 원본 Asset:** `v13__CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED__SOURCE.zip`
- **소스 파일 수:** `77`
- **SHA-256:** `49dabc1d1d8f597bfe93c5b4e7d771b5aa4d0554079a815b6daf3e5fc5ba57d7`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
