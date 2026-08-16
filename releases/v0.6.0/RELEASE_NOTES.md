<!-- release-title: CERTI:ON v0.6.0 — 프로젝트 정리 · 실행 구조 단순화 -->

> **개발 기록 06/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
v0.5.0에서 늘어난 실행/문서 파일을 정리하고 핵심 실행 경로를 단순화한 구조 정리 버전입니다.

## v0.5.0 대비 변경 사항
- 중복 루트 main.dart와 다수의 중복 실행/설명 파일을 제거했습니다.
- ONE_CLICK_RUN.bat과 START_BACKEND.bat 중심으로 실행 흐름을 정리했습니다.
- 기능을 새로 늘리기보다 유지보수성과 프로젝트 가독성을 개선했습니다.

## 기술 변경 내역
- **파일 변화:** `+0 추가 / -14 삭제 / ~4 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `ONE_CLICK_RUN.bat`, `README.md`, `START_BACKEND.bat`, `lib/main.dart`, `AI_키_연결방법.txt`, `API_INTEGRATION.md`, `BUILD_REPORT.txt`, `CHECK_PROJECT.bat`

## 보관된 원본 소스
- **원본 폴더:** `certi_on_ogq_ultimate4`
- **원본 수정 시각:** `2026-08-16 01:51:54 KST`
- **해당 버전 원본 Asset:** `v06__certi_on_ogq_ultimate4__SOURCE.zip`
- **소스 파일 수:** `47`
- **SHA-256:** `5288b89537e1b42c809ed562bb4e880e732f625ddf98efbcd64411196b18185e`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
