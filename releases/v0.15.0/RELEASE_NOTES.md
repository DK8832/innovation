# CERTI:ON v0.15.0 — Multi-Model AI · 14B / 8B / 4B Selector

> **Development archive 15/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
PC 성능에 따라 AI 모델을 앱에서 즉시 선택할 수 있도록 다중 모델 운영 기능을 완성한 버전입니다.

## What changed from v0.14.0
- 앱에서 높음/보통/낮음으로 qwen3:14b, 8b, 4b를 선택하도록 UI/백엔드를 연결했습니다.
- qwen3:4b 설치·선택 스크립트와 MODEL_SETUP.txt를 추가했습니다.
- 생성 요청의 강제 timeout을 제거해 큰 로컬 모델의 긴 응답 시간을 허용했습니다.

## Technical delta
- **File delta:** `+3 added / -0 removed / ~7 modified`
- **Internal Flutter version:** `2.0.0+2`
- **Representative changed paths:** `INSTALL_QWEN4B.bat`, `MODEL_SETUP.txt`, `USE_QWEN4B.bat`, `PREPARE_AI.bat`, `README.md`, `RUN_CERTION.bat`, `RUN_CHROME_AI.bat`, `START_BACKEND.bat`

## Archived source
- **Original folder:** `FINAL_ULTIMATE_CERTI_ON_OGQ_AI_MODEL_SELECTOR_NO_TIMEOUT`
- **Original modified time:** `2026-08-16 14:03:24 KST`
- **Historical source asset:** `v15__FINAL_ULTIMATE_CERTI_ON_OGQ_AI_MODEL_SELECTOR_NO_TIMEOUT__SOURCE.zip`
- **Source files:** `82`
- **SHA-256:** `b2ad91fa37c61a76a39d98042c869ea5cc11cd62f101423628ea92278a2c2bfa`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
