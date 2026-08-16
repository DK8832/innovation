# CERTI:ON v0.22.0 — 내부 추론 노출 방지 · reasoning 차단·빌드 lock 보호

> **개발 기록 22/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
휴대폰/PC Qwen3의 내부 추론 텍스트가 사용자에게 노출되는 문제와 Windows Gradle 파일 잠금을 함께 방어한 버전입니다.

## v0.21.0 대비 변경 사항
- Qwen3 raw ChatML/final-answer 경로와 reasoning 패턴 감지·재시도 로직을 강화했습니다.
- 백엔드에서도 <think>/analysis 계열 내부 추론을 제거하도록 수정했습니다.
- stale Gradle/Kotlin daemon과 lock을 정리하는 stop_gradle_locks.ps1을 추가했습니다.

## 기술 변경 내역
- **파일 변화:** `+3 추가 / -0 삭제 / ~5 수정`
- **내부 Flutter 버전:** `2.1.4+7`
- **대표 변경 경로:** `V7_FIX_NOTES.txt`, `V7_SIMULATION_REPORT.txt`, `tools/stop_gradle_locks.ps1`, `MAKE_FLUTTER_APK.bat`, `RUN_CERTION.bat`, `backend/server.mjs`, `lib/main.dart`, `tools/configure_android.ps1`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V7`
- **원본 수정 시각:** `2026-08-16 20:07:34 KST`
- **해당 버전 원본 Asset:** `v22__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V7__SOURCE.zip`
- **소스 파일 수:** `65`
- **SHA-256:** `9d8144b1232748be6170f7d210f1d120016ebf3c333cb8aa5e724090d28345a7`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
