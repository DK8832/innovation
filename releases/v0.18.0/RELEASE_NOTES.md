# CERTI:ON v0.18.0 — Toolchain Stability · Pinned NDK & LAN Discovery

> **Development archive 18/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
Android 네이티브 빌드 도구 버전과 PC AI 네트워크 탐색을 고정·자동화한 버전입니다.

## What changed from v0.17.0
- Android NDK를 28.2.13676358로 고정하고 누락 시 자동 설치/검증하도록 수정했습니다.
- 같은 Wi-Fi의 PC AI 주소를 자동 탐색하고 사용자에게 표시하는 도구를 추가했습니다.
- 정적/구성 시뮬레이션 결과 67/67 PASS 기록을 포함했습니다.

## Technical delta
- **File delta:** `+3 added / -1 removed / ~10 modified`
- **Internal Flutter version:** `2.1.2+5`
- **Representative changed paths:** `SHOW_PC_AI_SERVER_ADDRESS.bat`, `V3_FIX_NOTES.txt`, `V3_SIMULATION_REPORT.txt`, `README.md`, `README_FIRST_KR.txt`, `RUN_PC_AI_OPTIONAL.bat`, `SIMULATION_REPORT.txt`, `STATIC_TEST_RESULTS.txt`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V3`
- **Original modified time:** `2026-08-16 19:06:26 KST`
- **Historical source asset:** `v18__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V3__SOURCE.zip`
- **Source files:** `51`
- **SHA-256:** `538b69e00fac7c08a37903d2bebc38b6c2dacd41d174e4bda3bbe8005aa57d9b`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
