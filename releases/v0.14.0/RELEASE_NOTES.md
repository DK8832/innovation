<!-- release-title: CERTI:ON v0.14.0 — 웹 테스트 환경 개선 · Chrome 실행 안정화 -->

> **개발 기록 14/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
스마트 채팅 코드는 유지하면서 Chrome 기반 테스트/시연 환경을 더 안정적으로 재현하도록 실행 도구를 추가한 버전입니다.

## v0.13.0 대비 변경 사항
- CHROME_RUN_HELP.txt로 웹 실행 조건과 문제 해결 절차를 정리했습니다.
- RUN_WEB_SERVER_INTERNAL.bat을 추가해 내부 웹 서버 실행을 분리했습니다.
- RUN_CHROME_AI.bat을 수정해 Chrome/AI 실행 순서를 안정화했습니다.

## 기술 변경 내역
- **파일 변화:** `+2 추가 / -0 삭제 / ~1 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `CHROME_RUN_HELP.txt`, `RUN_WEB_SERVER_INTERNAL.bat`, `RUN_CHROME_AI.bat`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED_V2`
- **원본 수정 시각:** `2026-08-16 13:44:00 KST`
- **해당 버전 원본 Asset:** `v14__CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED_V2__SOURCE.zip`
- **소스 파일 수:** `79`
- **SHA-256:** `21113206551c5ee5a20464641edcaad68a1343a47a131d4e1502dc78ed5ecf94`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
