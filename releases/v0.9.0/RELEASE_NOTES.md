# CERTI:ON v0.9.0 — Web Reliability · Backend Port Isolation & Launch Fixes

> **Development archive 09/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
Flutter Web와 로컬 백엔드에서 실제 발생한 두 가지 장애를 수정한 안정화 버전입니다.

## What changed from v0.8.0
- Flutter Web의 ListTile background/ink assertion 종료 문제를 수정했습니다.
- localhost 백엔드 Failed to fetch 충돌을 줄이기 위해 이 계열의 포트를 8791로 분리했습니다.
- Node 런처(run_certi.mjs/start_backend_once.mjs)를 추가해 백엔드 중복 실행과 시작 순서를 제어했습니다.

## Technical delta
- **File delta:** `+3 added / -4 removed / ~9 modified`
- **Internal Flutter version:** `2.0.0+2`
- **Representative changed paths:** `.vscode/settings.json`, `tools/run_certi.mjs`, `tools/start_backend_once.mjs`, `.vscode/launch.json`, `.vscode/tasks.json`, `README.md`, `RUN_CERTION.bat`, `START_BACKEND.bat`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_FULL_FIXED_V2`
- **Original modified time:** `2026-08-16 11:40:18 KST`
- **Historical source asset:** `v09__CERTI_ON_OGQ_FULL_FIXED_V2__SOURCE.zip`
- **Source files:** `51`
- **SHA-256:** `f0d5ad8c4cf0b9708b04490fa4cbcc87810910b40f7457310c2947a6ded70c9a`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
