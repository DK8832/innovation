# CERTI:ON v0.13.0 — Smart Chat Context · Prompt & Response Pipeline Fix

> **Development archive 13/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
Qwen3 14B가 CERTI:ON의 기능과 공식 일정 문맥을 더 정확히 이해하도록 채팅 경로를 수정한 버전입니다.

## What changed from v0.12.0
- backend/server.mjs의 시스템/문맥 프롬프트와 응답 처리를 조정했습니다.
- lib/main.dart의 AI 요청/표시 로직을 함께 수정해 프런트와 백엔드 동작을 맞췄습니다.
- UI 전체를 바꾸지 않고 채팅 품질과 문맥 전달에 변경 범위를 집중했습니다.

## Technical delta
- **File delta:** `+0 added / -0 removed / ~3 modified`
- **Internal Flutter version:** `2.0.0+2`
- **Representative changed paths:** `README.md`, `backend/server.mjs`, `lib/main.dart`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED`
- **Original modified time:** `2026-08-16 13:38:06 KST`
- **Historical source asset:** `v13__CERTI_ON_OGQ_QWEN14B_SMART_CHAT_FIXED__SOURCE.zip`
- **Source files:** `77`
- **SHA-256:** `49dabc1d1d8f597bfe93c5b4e7d771b5aa4d0554079a815b6daf3e5fc5ba57d7`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
