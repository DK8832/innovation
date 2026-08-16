# CERTI:ON v0.3.0 — 전체 기능 복원 · 공식 데이터·백엔드 재통합

> **개발 기록 03/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
v0.2.0의 경량 실험에서 빠졌던 ULTIMATE 풀스택 구성을 다시 복원한 버전입니다.

## v0.2.0 대비 변경 사항
- 공식 일정 JSON, 카테고리/기능 이미지, Node 백엔드, 동기화 워크플로를 재통합했습니다.
- 프로젝트 검증·원클릭 실행·백엔드 실행 문서와 도구를 복구했습니다.
- v0.2.0 대비 +36개 파일이 복원되어 v0.1.0 계열의 전체 기능 구조로 돌아왔습니다.

## 기술 변경 내역
- **파일 변화:** `+36 추가 / -0 삭제 / ~9 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `.github/workflows/sync-certificates.yml`, `BUILD_REPORT.txt`, `CHECK_PROJECT.bat`, `OFFICIAL_DATA_SOURCES.md`, `ONE_CLICK_RUN.bat`, `RUN_WITH_BACKEND.bat`, `SHA256SUMS.txt`, `START_BACKEND.bat`

## 보관된 원본 소스
- **원본 폴더:** `certi_on_ogq_ultimate1`
- **원본 수정 시각:** `2026-08-16 01:11:24 KST`
- **해당 버전 원본 Asset:** `v03__certi_on_ogq_ultimate1__SOURCE.zip`
- **소스 파일 수:** `58`
- **SHA-256:** `9b7a27502abaefbbaa479ec2cca5965dc81af4e502142bfa9c3d5c45db03d3e1`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
