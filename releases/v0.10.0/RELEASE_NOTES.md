# CERTI:ON v0.10.0 — Local AI Pivot · Ollama + Qwen3 Architecture

> **Development archive 10/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
클라우드 API 의존 구조에서 PC 로컬 Ollama + Qwen3로 AI 아키텍처를 전환한 주요 버전입니다.

## What changed from v0.9.0
- 기본 모델을 qwen3:14b로 설정하고 8B 경량/30B 최대 모델 선택 스크립트를 추가했습니다.
- 공식 일정 데이터를 프롬프트 문맥으로 넣는 로컬 RAG형 응답 구조를 backend/server.mjs에 반영했습니다.
- API 키 없이 로컬 모델을 설치·실행하는 RUN_CERTION/INSTALL_LOCAL_AI 흐름을 구성했습니다.

## Technical delta
- **File delta:** `+4 added / -0 removed / ~11 modified`
- **Internal Flutter version:** `2.0.0+2`
- **Representative changed paths:** `INSTALL_LOCAL_AI.bat`, `USE_LIGHT_MODEL.bat`, `USE_MAX_MODEL.bat`, `USE_SMART_MODEL.bat`, `.vscode/launch.json`, `.vscode/settings.json`, `.vscode/tasks.json`, `README.md`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_LOCAL_AI_SMART`
- **Original modified time:** `2026-08-16 12:08:46 KST`
- **Historical source asset:** `v10__CERTI_ON_OGQ_LOCAL_AI_SMART__SOURCE.zip`
- **Source files:** `55`
- **SHA-256:** `c1d8c64d8417acc5b432eb461fdfe691a1ede5664a95a2e86275ef9c04f738f4`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
