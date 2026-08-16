# CERTI:ON v0.22.0 — Reasoning Guard · Hidden-Reasoning & Build-Lock Protection

> **Development archive 22/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
휴대폰/PC Qwen3의 내부 추론 텍스트가 사용자에게 노출되는 문제와 Windows Gradle 파일 잠금을 함께 방어한 버전입니다.

## What changed from v0.21.0
- Qwen3 raw ChatML/final-answer 경로와 reasoning 패턴 감지·재시도 로직을 강화했습니다.
- 백엔드에서도 <think>/analysis 계열 내부 추론을 제거하도록 수정했습니다.
- stale Gradle/Kotlin daemon과 lock을 정리하는 stop_gradle_locks.ps1을 추가했습니다.

## Technical delta
- **File delta:** `+3 added / -0 removed / ~5 modified`
- **Internal Flutter version:** `2.1.4+7`
- **Representative changed paths:** `V7_FIX_NOTES.txt`, `V7_SIMULATION_REPORT.txt`, `tools/stop_gradle_locks.ps1`, `MAKE_FLUTTER_APK.bat`, `RUN_CERTION.bat`, `backend/server.mjs`, `lib/main.dart`, `tools/configure_android.ps1`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V7`
- **Original modified time:** `2026-08-16 20:07:34 KST`
- **Historical source asset:** `v22__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V7__SOURCE.zip`
- **Source files:** `65`
- **SHA-256:** `9d8144b1232748be6170f7d210f1d120016ebf3c333cb8aa5e724090d28345a7`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
