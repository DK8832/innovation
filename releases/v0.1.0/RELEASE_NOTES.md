# CERTI:ON v0.1.0 — 기반 구축 · 자격증 통합 플랫폼 기준선

> **개발 기록 01/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
첫 통합 기준선을 확립한 버전입니다. 5탭 Flutter UI, 공식 일정 데이터, 이미지 자산, Node 백엔드, 자동 동기화 워크플로를 한 프로젝트에 묶었습니다.

## 최초 기준본 대비 변경 사항
- 공식 일정 101건과 상시시험 6종 데이터 구조를 포함했습니다.
- Flutter 앱과 Node 백엔드 연결 구조 및 공식 출처 검증 흐름을 구성했습니다.
- 원클릭 실행/검증 스크립트와 GitHub Actions 일정 동기화 워크플로를 포함했습니다.

## 기술 변경 내역
- **파일 변화:** `+58 추가 / -0 삭제 / ~0 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `.github/workflows/sync-certificates.yml`, `.gitignore`, `.metadata`, `.vscode/launch.json`, `API_INTEGRATION.md`, `BUILD_REPORT.txt`, `CHECK_PROJECT.bat`, `DEMO_GUIDE.md`

## 보관된 원본 소스
- **원본 폴더:** `certi_on_ogq_ultimate`
- **원본 수정 시각:** `2026-08-15 15:53:22 KST`
- **해당 버전 원본 Asset:** `v01__certi_on_ogq_ultimate__SOURCE.zip`
- **소스 파일 수:** `58`
- **SHA-256:** `583aa094f2addbd3ae1b6378d32f555214e662dbff213ccd86668760861a3d24`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
