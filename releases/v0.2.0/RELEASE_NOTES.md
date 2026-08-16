<!-- release-title: CERTI:ON v0.2.0 — 경량 시제품 · 시연 중심 구조 단순화 -->

> **개발 기록 02/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
v0.1.0의 풀스택 구성을 의도적으로 축소한 경량 데모 스냅샷입니다. 개선이라기보다 시연 단순화 실험으로, 이후 버전 비교 기준에서 별도 분기로 취급해야 합니다.

## v0.1.0 대비 변경 사항
- 백엔드, 공식 데이터 asset, 이미지 asset, 자동 동기화 워크플로를 제거해 의존성을 줄였습니다.
- Flutter SDK 기본 위젯 중심으로 핵심 탐색/일정/AI 브리핑/MY 흐름만 남겼습니다.
- 내부 pubspec 버전도 1.0.0+1로 낮아져 v0.1.0과 계보가 동일한 단순 업그레이드는 아닙니다.

## 기술 변경 내역
- **파일 변화:** `+0 추가 / -36 삭제 / ~9 수정`
- **내부 Flutter 버전:** `1.0.0+1`
- **대표 변경 경로:** `API_INTEGRATION.md`, `DEMO_GUIDE.md`, `README.md`, `SETUP_ONCE.bat`, `lib/main.dart`, `main.dart`, `pubspec.lock`, `pubspec.yaml`

## 보관된 원본 소스
- **원본 폴더:** `certi_on_ogq`
- **원본 수정 시각:** `2026-08-16 00:12:44 KST`
- **해당 버전 원본 Asset:** `v02__certi_on_ogq__SOURCE.zip`
- **소스 파일 수:** `22`
- **SHA-256:** `3a5b7a9eba2a1fb92f3e0b4b9da3e8ff0e1475393a0e906054bf3c626eb19bcd`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
