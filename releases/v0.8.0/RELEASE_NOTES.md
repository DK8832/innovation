# CERTI:ON v0.8.0 — Runtime Stabilization · Full Fixed Baseline

> **Development archive 08/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
OpenAI 기반 전체 기능을 실제 시연하기 위한 실행 안정화 기준 버전입니다.

## What changed from v0.7.0
- RUN_CERTION.bat을 중심으로 백엔드 시작과 Flutter 실행을 통합했습니다.
- AI 연결 상태/실제 오류를 사용자에게 표시하도록 백엔드와 Flutter 화면을 정리했습니다.
- Chrome/Android 환경 준비 도구와 API 키 입력 안내를 추가했습니다.

## Technical delta
- **File delta:** `+6 added / -4 removed / ~7 modified`
- **Internal Flutter version:** `2.0.0+2`
- **Representative changed paths:** `API_KEY_입력.bat`, `BUILD_CHECK.txt`, `RUN_CERTION.bat`, `tools/ensure_android.bat`, `tools/prepare_ai.bat`, `먼저_읽기.txt`, `.vscode/launch.json`, `.vscode/tasks.json`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_FULL_FIXED`
- **Original modified time:** `2026-08-16 11:09:16 KST`
- **Historical source asset:** `v08__CERTI_ON_OGQ_FULL_FIXED__SOURCE.zip`
- **Source files:** `52`
- **SHA-256:** `5a68387c767b7caefe35eb74d21829d5e4d5e5ed1d2d47b1ffdd337ea99d0584`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
