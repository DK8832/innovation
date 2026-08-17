#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "========================================"
echo " CERTI:ON v2.0.0 - iPhone Setup"
echo "========================================"

if ! command -v flutter >/dev/null 2>&1; then
  echo "[ERROR] Flutter가 설치되어 있지 않습니다."
  echo "https://docs.flutter.dev/get-started/install/macos"
  read -n 1 -s -r -p "아무 키나 누르면 종료합니다..."
  echo
  exit 1
fi

if ! command -v open >/dev/null 2>&1; then
  echo "[ERROR] macOS 환경에서 실행해주세요."
  exit 1
fi

flutter pub get

if [ ! -d "ios/Runner.xcworkspace" ]; then
  echo "[ERROR] ios/Runner.xcworkspace를 찾을 수 없습니다."
  exit 1
fi

echo

echo "Xcode를 엽니다."
echo "Runner > Signing & Capabilities에서 자신의 Apple Team을 선택하세요."
open ios/Runner.xcworkspace
