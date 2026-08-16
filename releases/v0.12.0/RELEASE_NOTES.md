# CERTI:ON v0.12.0 — Native Android Baseline · Original UI + Qwen3 14B

> **Development archive 12/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
원래 CERTI:ON UI와 기능을 유지하면서 Ollama Qwen3 14B 로컬 AI를 결합하고 Android 네이티브 wrapper를 프로젝트에 포함한 버전입니다.

## What changed from v0.11.0
- Android Gradle 프로젝트 전체를 포함해 네이티브 빌드 기준선을 마련했습니다.
- AI 구조를 Flutter → Node :8787 → Ollama :11434 → qwen3:14b로 정리했습니다.
- 기존 공식 일정/이미지/플래너/비교 기능은 유지했습니다.

## Technical delta
- **File delta:** `+30 added / -9 removed / ~10 modified`
- **Internal Flutter version:** `2.0.0+2`
- **Representative changed paths:** `ONE_CLICK_RUN.bat`, `PREPARE_AI.bat`, `RUN_CHROME_AI.bat`, `USE_QWEN14B.bat`, `USE_QWEN8B.bat`, `android/.gitignore`, `android/app/build.gradle.kts`, `android/app/src/debug/AndroidManifest.xml`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_ORIGINAL_LOCAL_QWEN14B`
- **Original modified time:** `2026-08-16 13:27:22 KST`
- **Historical source asset:** `v12__CERTI_ON_OGQ_ORIGINAL_LOCAL_QWEN14B__SOURCE.zip`
- **Source files:** `77`
- **SHA-256:** `d1b6cc340aa9b17448cb7901f75d9e902b8e7c8ecd9cd4c0d5306c0d8b0265be`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
