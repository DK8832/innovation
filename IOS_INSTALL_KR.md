# CERTI:ON iPhone 설치 안내

이 프로젝트는 iOS 프로젝트 파일을 포함하며 macOS GitHub Actions에서 `flutter build ios --release --no-codesign` 실제 빌드 검증을 통과한 소스입니다.

## Mac + Xcode로 iPhone에 설치
1. Mac에 최신 Flutter와 Xcode를 설치합니다.
2. 이 프로젝트 폴더에서 `flutter pub get`을 실행합니다.
3. `open ios/Runner.xcworkspace`를 실행합니다.
4. Xcode의 Runner > Signing & Capabilities에서 자신의 Apple Team을 선택하고 Bundle Identifier를 고유한 값으로 설정합니다.
5. iPhone을 연결하고 Developer Mode를 켠 뒤 Xcode에서 Run을 누릅니다.

## 기능 차이
- Android: 휴대폰 내부 Qwen3 GGUF AI + PC Ollama AI 지원
- iPhone: 공식 일정/탐색/캘린더/플래너 등 앱 기능 + 같은 Wi-Fi의 PC Ollama AI 지원
- Android 전용 `llama_flutter_android` 기반 휴대폰 단독 AI 버튼은 iPhone에서 비활성화됩니다.

`packages/llama_flutter_android`에는 MIT 라이선스의 Android 구현만 로컬 고정하여 iOS 빌드에서 해당 Android 전용 네이티브 코드가 등록되지 않도록 했습니다. iOS에서 PC AI를 사용할 때 로컬 네트워크 권한 요청이 표시될 수 있습니다.
