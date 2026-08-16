# CERTI:ON v0.20.0 — UTF-8 Streaming Fix · Korean Token Integrity

> **Development archive 20/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
휴대폰 llama.cpp 스트리밍에서 한글이 U+FFFD(�)로 깨지는 문제의 원인을 토큰 경계 수준에서 수정한 버전입니다.

## What changed from v0.19.0
- llama_token_to_piece가 UTF-8 문자를 중간 byte에서 나눌 수 있는 문제를 누적 버퍼 방식으로 처리했습니다.
- tools/patch_llama_utf8.ps1을 추가해 Android JNI wrapper에 패치를 적용합니다.
- V5 UTF-8 시뮬레이션/수정 기록을 포함해 재현 원인과 수정 범위를 문서화했습니다.

## Technical delta
- **File delta:** `+4 added / -1 removed / ~4 modified`
- **Internal Flutter version:** `2.1.4+7`
- **Representative changed paths:** `V4_FIX_NOTES_PREVIOUS.txt`, `V5_FIX_NOTES.txt`, `V5_UTF8_SIMULATION.txt`, `tools/patch_llama_utf8.ps1`, `BUILD_STANDALONE_APK.bat`, `README_FIRST_KR.txt`, `RUN_CERTION.bat`, `pubspec.yaml`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V5`
- **Original modified time:** `2026-08-16 19:37:08 KST`
- **Historical source asset:** `v20__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V5__SOURCE.zip`
- **Source files:** `58`
- **SHA-256:** `4764539aa5fc2d5bc00587e1d83744d517f4a83190f1dbcee805e61ce2e57eb5`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
