<!-- release-title: CERTI:ON v0.23.0 — 릴리스 후보 · fallback·백엔드 검증 -->

> **개발 기록 23/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
대회 최종본 직전의 RC 성격으로, 빈/placeholder 응답과 오래된 backend 혼선을 이중으로 방어한 버전입니다.

## v0.22.0 대비 변경 사항
- 빈 문자열, 기호-only, 문자 그대로의 "..." 응답을 backend와 Flutter 양쪽에서 거부합니다.
- Ollama 실패가 지속되면 앱/공식 일정 문맥 기반 deterministic fallback을 반환합니다.
- TCP 8787의 오래된 backend를 종료하고 backendVersion을 검증하며 PC AI 3회 연속 테스트를 추가했습니다.

## 기술 변경 내역
- **파일 변화:** `+5 추가 / -0 삭제 / ~6 수정`
- **내부 Flutter 버전:** `2.1.4+7`
- **대표 변경 경로:** `CHECK_FLUTTER_CODE.bat`, `README_V8_KR.txt`, `TEST_PC_AI_3X.bat`, `V8_3X_SIMULATION_REPORT.txt`, `V8_FIX_NOTES.txt`, `MAKE_FLUTTER_APK.bat`, `RUN_CERTION.bat`, `RUN_PC_AI_OPTIONAL.bat`

## 보관된 원본 소스
- **원본 폴더:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V8`
- **원본 수정 시각:** `2026-08-16 20:42:02 KST`
- **해당 버전 원본 Asset:** `v23__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V8__SOURCE.zip`
- **소스 파일 수:** `70`
- **SHA-256:** `06bd647ec35bfc8edb914317eb688e92f5176ad8fb7a6c685baf7360ba888753`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
