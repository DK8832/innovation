<!-- release-title: CERTI:ON v0.7.0 — 개발환경 개선 · VS Code·AI 실행 자동화 -->

> **개발 기록 07/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
개발·시연 과정에서 AI와 Chrome 실행을 빠르게 재현하도록 개발자 경험을 강화한 버전입니다.

## v0.6.0 대비 변경 사항
- VS Code tasks.json을 추가하고 launch 설정을 갱신했습니다.
- PREPARE_AI.bat과 RUN_CHROME_AI.bat을 추가해 AI 준비와 웹 실행 단계를 분리했습니다.
- Flutter HTTP 의존성과 AI 화면/호출 코드를 함께 조정했습니다.

## 기술 변경 내역
- **파일 변화:** `+3 추가 / -0 삭제 / ~4 수정`
- **내부 Flutter 버전:** `2.0.0+2`
- **대표 변경 경로:** `.vscode/tasks.json`, `PREPARE_AI.bat`, `RUN_CHROME_AI.bat`, `.vscode/launch.json`, `lib/main.dart`, `pubspec.lock`, `pubspec.yaml`

## 보관된 원본 소스
- **원본 폴더:** `z_real_final_final_final_certi_on_ogq_ai_fixed`
- **원본 수정 시각:** `2026-08-16 01:59:54 KST`
- **해당 버전 원본 Asset:** `v07__z_real_final_final_final_certi_on_ogq_ai_fixed__SOURCE.zip`
- **소스 파일 수:** `50`
- **SHA-256:** `cdcd6a6866944208ac8cfd015c0becf88236c0f927ac4544dde73a4bd8591138`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
