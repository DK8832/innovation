CERTI:ON V9 - 정리/최적화 원클릭 버전

실행할 파일은 하나뿐입니다.

    RUN_CERTION_ALL.bat

이 파일 하나가 다음을 순서대로 자동 처리합니다.
1) Android SDK 35 / NDK 28.2 / CMake 확인
2) Flutter Android 설정 준비
3) 휴대폰 한글 AI UTF-8 패치 적용
4) ARM64 Release APK 생성
5) OUTPUT\CERTI_ON.apk 저장
6) C-to-C로 연결된 휴대폰에 기존 앱을 유지한 채 업데이트 설치
7) 현재 Wi-Fi PC IPv4를 APK 기본 PC AI 주소로 자동 삽입
8) Windows 방화벽 8787 허용(UAC가 최초 1회 나타날 수 있음)
9) Ollama 자동 확인/실행
10) CERTI:ON PC AI 서버 자동 시작
11) 휴대폰 앱 자동 실행

중요:
- 기존 앱 업데이트는 adb install -r 방식입니다. 휴대폰 AI 모델을 보존하기 위해 자동 uninstall은 하지 않습니다.
- PC AI 기본 모델은 빠른 qwen3:4b이며 앱에서 8B/14B로 바꿀 수 있습니다.
- 휴대폰 단독 AI는 모델을 한 번 다운로드한 뒤 PC/Wi-Fi 없이 작동합니다.
- PC 고성능 AI는 노트북과 휴대폰이 같은 Wi-Fi에 있어야 합니다.
- 성공 후 APK: OUTPUT\CERTI_ON.apk
- PC AI 주소: PC_AI_ADDRESS.txt
- 백엔드 로그: logs\backend.out.log / logs\backend.err.log

V9 최적화:
- 과거 V3~V8 보고서/테스트 BAT/중복 실행 BAT 제거
- RUN_CERTION + APK Builder + PC AI Start를 RUN_CERTION_ALL.bat 하나로 통합
- Android wrapper를 매 실행마다 다시 만들지 않고 재사용
- 빌드 실패 시에만 자동 클린/Android 재생성 후 1회 재시도
- flutter analyze를 일반 실행 경로에서 제거해 DartWorker 스레드 문제 가능성 감소
- backend 공식 일정 JSON을 메모리에 1회 로드해 반복 디스크 I/O 제거
- 앱에서 사용하지 않는 backend API 제거
- PC AI 첫 연결 기본값을 4B로 조정해 로딩 부담 감소
- Wi-Fi IPv4를 빌드 시 자동 삽입해 앱에서 서버 주소를 매번 입력할 필요를 줄임
