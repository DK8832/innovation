# CERTI:ON v0.11.0 — 로컬 AI 사용성 개선 · 빠른 시작·모델 관리

> **개발 기록 11/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
v0.10.0의 로컬 AI 구조를 유지하면서 설치·실행·모델 전환 절차를 더 명확하게 만든 사용성 개선 버전입니다.

## v0.10.0 대비 변경 사항
- LOCAL_AI_QUICK_START.txt를 추가해 Ollama 설치와 모델 준비 절차를 문서화했습니다.
- 14B/8B/30B 선택 BAT와 설치 스크립트의 메시지·경로를 정리했습니다.
- RUN_CERTION.bat 및 START_BACKEND.bat 실행 흐름을 다듬었습니다.

## 기술 변경 내역
- **파일 변화:** `+1 추가 / -0 삭제 / ~7 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `LOCAL_AI_QUICK_START.txt`, `INSTALL_LOCAL_AI.bat`, `README.md`, `RUN_CERTION.bat`, `START_BACKEND.bat`, `USE_LIGHT_MODEL.bat`, `USE_MAX_MODEL.bat`, `USE_SMART_MODEL.bat`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_LOCAL_AI_SMART_V2`
- **원본 수정 시각:** `2026-08-16 12:14:02 KST`
- **해당 버전 원본 Asset:** `v11__CERTI_ON_OGQ_LOCAL_AI_SMART_V2__SOURCE.zip`
- **소스 파일 수:** `56`
- **SHA-256:** `a01b6305b73c6af44543a0d9da1cf60b59648dd7689ab1eb25b122759eb9f22f`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
