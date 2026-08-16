# CERTI:ON v0.23.0 — Release Candidate · Fallback & Backend Validation

> **Development archive 23/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
대회 최종본 직전의 RC 성격으로, 빈/placeholder 응답과 오래된 backend 혼선을 이중으로 방어한 버전입니다.

## What changed from v0.22.0
- 빈 문자열, 기호-only, 문자 그대로의 "..." 응답을 backend와 Flutter 양쪽에서 거부합니다.
- Ollama 실패가 지속되면 앱/공식 일정 문맥 기반 deterministic fallback을 반환합니다.
- TCP 8787의 오래된 backend를 종료하고 backendVersion을 검증하며 PC AI 3회 연속 테스트를 추가했습니다.

## Technical delta
- **File delta:** `+5 added / -0 removed / ~6 modified`
- **Internal Flutter version:** `2.1.4+7`
- **Representative changed paths:** `CHECK_FLUTTER_CODE.bat`, `README_V8_KR.txt`, `TEST_PC_AI_3X.bat`, `V8_3X_SIMULATION_REPORT.txt`, `V8_FIX_NOTES.txt`, `MAKE_FLUTTER_APK.bat`, `RUN_CERTION.bat`, `RUN_PC_AI_OPTIONAL.bat`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V8`
- **Original modified time:** `2026-08-16 20:42:02 KST`
- **Historical source asset:** `v23__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V8__SOURCE.zip`
- **Source files:** `70`
- **SHA-256:** `06bd647ec35bfc8edb914317eb688e92f5176ad8fb7a6c685baf7360ba888753`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
