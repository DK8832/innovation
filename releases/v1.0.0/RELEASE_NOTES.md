# CERTI:ON v1.0.0 — Competition Final · One-Click Integrated Runtime

> **Stable competition release 24/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
CERTI:ON의 대회 제출용 최종 통합/최적화 버전입니다. 여러 실행 파일을 하나의 원클릭 런처로 합치고 빌드·설치·PC AI 선택 경로를 자동화했습니다.

## What changed from v0.23.0
- RUN_CERTION_ALL.bat 하나가 SDK/NDK/CMake 확인, Android 준비, UTF-8 패치, ARM64 release APK 빌드, adb 업데이트 설치를 수행합니다.
- PC Wi-Fi IPv4 자동 탐지, 방화벽 8787 설정, Ollama 확인/시작, Node backend 실행, 휴대폰 앱 실행까지 연결합니다.
- 다운로드된 휴대폰 GGUF 모델을 보존하도록 자동 uninstall을 제거하고 Android wrapper 재사용/실패 시 rebuild 전략을 적용했습니다.
- backend 공식 일정 JSON을 메모리로 로드하고 중복 스크립트·과거 보고서를 정리했습니다.

## Technical delta
- **File delta:** `+4 added / -39 removed / ~5 modified`
- **Internal Flutter version:** `2.2.0+9`
- **Representative changed paths:** `README_KR.txt`, `RUN_CERTION_ALL.bat`, `tools/ensure_firewall.ps1`, `tools/start_pc_ai.ps1`, `.gitignore`, `backend/server.mjs`, `lib/main.dart`, `pubspec.yaml`

## Archived source
- **Original folder:** `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9`
- **Original modified time:** `2026-08-16 21:09:12 KST`
- **Historical source asset:** `v24__CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9__SOURCE.zip`
- **Source files:** `35`
- **SHA-256:** `593953ad21fc32471885348da3683c23afcc3e6fdf01f75f07c5267e8e688bd5`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
