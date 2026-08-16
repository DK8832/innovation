# v1.0.0 — V9 원클릭 최적화 최종본

원본 폴더: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V9`  
수정 시각: 2026-08-16 21:09:12 KST

## 핵심 변경
- `RUN_CERTION_ALL.bat` 하나로 전체 실행 통합
- SDK/NDK/CMake 확인 → Android 준비 → UTF-8 패치 → ARM64 release APK → `OUTPUT\CERTI_ON.apk`
- 연결된 Android 휴대폰에 `adb install -r` 업데이트 설치
- PC Wi-Fi IPv4 자동 감지 및 앱 기본 서버 주소 반영
- 방화벽 8787 설정 → Ollama 확인/실행 → CERTI:ON backend 실행 → 휴대폰 앱 실행
- 다운로드된 휴대폰 GGUF 모델을 보존하도록 자동 uninstall 제거
- Android wrapper 재사용, 실패 시에만 clean/rebuild
- 일반 실행에서 불필요한 `flutter analyze` 제거
- backend 공식 일정 JSON 메모리 캐시와 중복 로직 정리

## 유지되는 핵심 기능
- 휴대폰 Qwen3 1.7B/0.6B 독립형 AI
- PC Qwen3 14B/8B/4B 고성능 AI
- 한글 UTF-8 token streaming 보호
- 내부 추론 노출 방지
- blank/`...` 응답 방어
