# CERTI:ON v0.19.0 — Connectivity Recovery · Ollama / Firewall / Model Download

> **Development archive 19/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
PC 고성능 AI 연결 실패와 휴대폰 빠른 모델 다운로드 실패를 복구하는 네트워크 안정화 버전입니다.

## What changed from v0.18.0
- Ollama API가 꺼져 있으면 ollama serve를 자동 시작하고 준비 상태를 확인합니다.
- TCP 8787을 LocalSubnet에 허용하는 Windows 방화벽 흐름과 ECONNREFUSED 진단을 추가했습니다.
- 휴대폰 빠른 모델을 Qwen3 0.6B Q4_0으로 정리하고 .part/HTTP 416 이어받기 문제를 보완했습니다.

## Technical delta
- **File delta:** `+4 added / -0 removed / ~7 modified`
- **Internal Flutter version:** `2.1.3+6`
- **Representative changed paths:** `TEST_PC_AI_CONNECTION.bat`, `V4_BACKEND_SIMULATION.txt`, `V4_FIX_NOTES.txt`, `V4_STATIC_TEST_RESULTS.txt`, `ALLOW_PC_WIFI_FIREWALL_OPTIONAL.bat`, `PHONE_AI_MODELS.txt`, `README_FIRST_KR.txt`, `RUN_PC_AI_OPTIONAL.bat`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V4`
- **Original modified time:** `2026-08-16 19:23:58 KST`
- **Historical source asset:** `v19__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V4__SOURCE.zip`
- **Source files:** `55`
- **SHA-256:** `1a2149836b1b6eac0f663cb34f88d7b9ed29a3b3fc14366a8f94286231bbc21b`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
