# CERTI:ON v0.17.0 — Android Build Hardening · Gradle / SDK Verification

> **Development archive 17/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
Standalone 구조에서 Android release 빌드가 Flutter/AGP 조합에 따라 실패하던 문제를 줄이기 위한 빌드 하드닝 버전입니다.

## What changed from v0.16.0
- Gradle release 설정에서 code shrinking/resource shrinking 조건을 명시적으로 검증합니다.
- verify_android_gradle.ps1과 V2 시뮬레이션 보고서를 추가했습니다.
- release 실패 시 테스트 지속을 위한 ARM64 debug fallback 경로를 보강했습니다.

## Technical delta
- **File delta:** `+2 added / -0 removed / ~9 modified`
- **Internal Flutter version:** `2.1.1+4`
- **Representative changed paths:** `V2_SIMULATION_REPORT.txt`, `tools/verify_android_gradle.ps1`, `BUILD_STANDALONE_APK.bat`, `README.md`, `README_FIRST_KR.txt`, `RUN_CERTION.bat`, `SIMULATION_REPORT.txt`, `STATIC_TEST_RESULTS.txt`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V2`
- **Original modified time:** `2026-08-16 18:51:06 KST`
- **Historical source asset:** `v17__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V2__SOURCE.zip`
- **Source files:** `49`
- **SHA-256:** `4488ad9ce728e5abe69cabf6dd0b6f2fbb52e1ccd096de4b418af5e5598c23e5`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
