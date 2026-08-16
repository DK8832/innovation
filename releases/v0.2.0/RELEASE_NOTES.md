# CERTI:ON v0.2.0 — Prototype · Lightweight Demo Baseline

> **Development archive 02/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
v0.1.0의 풀스택 구성을 의도적으로 축소한 경량 데모 스냅샷입니다. 개선이라기보다 시연 단순화 실험으로, 이후 버전 비교 기준에서 별도 분기로 취급해야 합니다.

## What changed from v0.1.0
- 백엔드, 공식 데이터 asset, 이미지 asset, 자동 동기화 워크플로를 제거해 의존성을 줄였습니다.
- Flutter SDK 기본 위젯 중심으로 핵심 탐색/일정/AI 브리핑/MY 흐름만 남겼습니다.
- 내부 pubspec 버전도 1.0.0+1로 낮아져 v0.1.0과 계보가 동일한 단순 업그레이드는 아닙니다.

## Technical delta
- **File delta:** `+0 added / -36 removed / ~9 modified`
- **Internal Flutter version:** `1.0.0+1`
- **Representative changed paths:** `API_INTEGRATION.md`, `DEMO_GUIDE.md`, `README.md`, `SETUP_ONCE.bat`, `lib/main.dart`, `main.dart`, `pubspec.lock`, `pubspec.yaml`

## Archived source
- **Original folder:** `certi_on_ogq`
- **Original modified time:** `2026-08-16 00:12:44 KST`
- **Historical source asset:** `v02__certi_on_ogq__SOURCE.zip`
- **Source files:** `22`
- **SHA-256:** `3a5b7a9eba2a1fb92f3e0b4b9da3e8ff0e1475393a0e906054bf3c626eb19bcd`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
