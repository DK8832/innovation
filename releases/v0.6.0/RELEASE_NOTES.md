# CERTI:ON v0.6.0 — Project Cleanup · Simplified Runtime Layout

> **Development archive 06/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
v0.5.0에서 늘어난 실행/문서 파일을 정리하고 핵심 실행 경로를 단순화한 구조 정리 버전입니다.

## What changed from v0.5.0
- 중복 루트 main.dart와 다수의 중복 실행/설명 파일을 제거했습니다.
- ONE_CLICK_RUN.bat과 START_BACKEND.bat 중심으로 실행 흐름을 정리했습니다.
- 기능을 새로 늘리기보다 유지보수성과 프로젝트 가독성을 개선했습니다.

## Technical delta
- **File delta:** `+0 added / -14 removed / ~4 modified`
- **Internal Flutter version:** `2.0.0+2`
- **Representative changed paths:** `ONE_CLICK_RUN.bat`, `README.md`, `START_BACKEND.bat`, `lib/main.dart`, `AI_키_연결방법.txt`, `API_INTEGRATION.md`, `BUILD_REPORT.txt`, `CHECK_PROJECT.bat`

## Archived source
- **Original folder:** `certi_on_ogq_ultimate4`
- **Original modified time:** `2026-08-16 01:51:54 KST`
- **Historical source asset:** `v06__certi_on_ogq_ultimate4__SOURCE.zip`
- **Source files:** `47`
- **SHA-256:** `5288b89537e1b42c809ed562bb4e880e732f625ddf98efbcd64411196b18185e`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
