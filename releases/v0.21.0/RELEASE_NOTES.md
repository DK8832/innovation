# CERTI:ON v0.21.0 — Qwen3 Response Recovery · No-Think Fallback & APK Builder

> **Development archive 21/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
PC Qwen3가 thinking에 토큰을 모두 사용해 최종 답변이 비는 문제를 복구하고 APK 생성 경로를 단순화한 버전입니다.

## What changed from v0.20.0
- PC 요청에 think=false와 /no_think를 적용합니다.
- 빈 chat 응답은 재시도 후 Ollama /api/generate로 fallback하고 <think> 블록을 제거합니다.
- MAKE_FLUTTER_APK.bat과 실제 PC AI 응답 테스트 스크립트를 추가했습니다.

## Technical delta
- **File delta:** `+4 added / -0 removed / ~5 modified`
- **Internal Flutter version:** `2.1.4+7`
- **Representative changed paths:** `MAKE_FLUTTER_APK.bat`, `TEST_PC_AI_REAL_RESPONSE.bat`, `V6_FIX_NOTES.txt`, `V6_SIMULATION_REPORT.txt`, `BUILD_STANDALONE_APK.bat`, `README_FIRST_KR.txt`, `RUN_PC_AI_OPTIONAL.bat`, `TEST_PC_AI_CONNECTION.bat`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V6`
- **Original modified time:** `2026-08-16 19:42:04 KST`
- **Historical source asset:** `v21__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V6__SOURCE.zip`
- **Source files:** `62`
- **SHA-256:** `7a26084446f16219c5051fc50594dfb615f6feed205b1b26c430ce857c71054b`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
