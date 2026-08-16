<!-- release-title: CERTI:ON v0.21.0 — Qwen3 응답 복구 · No-Think fallback·APK 빌더 -->

> **개발 기록 21/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
PC Qwen3가 thinking에 토큰을 모두 사용해 최종 답변이 비는 문제를 복구하고 APK 생성 경로를 단순화한 버전입니다.

## v0.20.0 대비 변경 사항
- PC 요청에 think=false와 /no_think를 적용합니다.
- 빈 chat 응답은 재시도 후 Ollama /api/generate로 fallback하고 <think> 블록을 제거합니다.
- MAKE_FLUTTER_APK.bat과 실제 PC AI 응답 테스트 스크립트를 추가했습니다.

## 기술 변경 내역
- **파일 변화:** `+4 추가 / -0 삭제 / ~5 수정`
- **내부 Flutter 버전:** `2.1.4+7`
- **대표 변경 경로:** `MAKE_FLUTTER_APK.bat`, `TEST_PC_AI_REAL_RESPONSE.bat`, `V6_FIX_NOTES.txt`, `V6_SIMULATION_REPORT.txt`, `BUILD_STANDALONE_APK.bat`, `README_FIRST_KR.txt`, `RUN_PC_AI_OPTIONAL.bat`, `TEST_PC_AI_CONNECTION.bat`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V6`
- **원본 수정 시각:** `2026-08-16 19:42:04 KST`
- **해당 버전 원본 Asset:** `v21__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V6__SOURCE.zip`
- **소스 파일 수:** `62`
- **SHA-256:** `7a26084446f16219c5051fc50594dfb615f6feed205b1b26c430ce857c71054b`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
