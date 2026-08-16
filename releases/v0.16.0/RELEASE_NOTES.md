# CERTI:ON v0.16.0 — Standalone AI Architecture · On-Device First

> **Development archive 16/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
PC 의존 AI에서 Android 휴대폰 자체 GGUF 추론을 기본으로 바꾼 가장 큰 아키텍처 전환 버전입니다.

## What changed from v0.15.0
- 휴대폰 Qwen3 1.7B/0.6B 온디바이스 AI를 기본 모드로 도입했습니다.
- PC Ollama 14B/8B/4B는 동일 Wi-Fi에서 사용하는 선택 옵션으로 분리했습니다.
- 기존 Android wrapper를 보관하는 대신 실행 시 생성/검증하는 구조로 단순화하고 standalone 빌드 도구를 추가했습니다.

## Technical delta
- **File delta:** `+12 added / -47 removed / ~7 modified`
- **Internal Flutter version:** `2.1.0+3`
- **Representative changed paths:** `ALLOW_PC_WIFI_FIREWALL_OPTIONAL.bat`, `BUILD_STANDALONE_APK.bat`, `MOCK_BACKEND_TEST.txt`, `PHONE_AI_MODELS.txt`, `README_FIRST_KR.txt`, `RESET_ANDROID_FOR_CURRENT_FLUTTER.bat`, `RUN_PC_AI_OPTIONAL.bat`, `SIMULATION_REPORT.txt`

## Archived source
- **Original folder:** `FINAL_FINAL_ULTIMATE_CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED`
- **Original modified time:** `2026-08-16 18:37:54 KST`
- **Historical source asset:** `v16__FINAL_FINAL_ULTIMATE_CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED__SOURCE.zip`
- **Source files:** `47`
- **SHA-256:** `ec52a9f0d3aa472d886f4ad49092ef1bd4c08b8c039d2c5d396e2d2f7ca535bf`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
