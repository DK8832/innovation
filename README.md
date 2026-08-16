# CERTI:ON

**공식 자격증·시험 일정을 한곳에 모으고, AI가 일정 이해와 준비 판단을 보조하는 Flutter 기반 자격증 일정·플래너 앱**

CERTI:ON은 여러 기관에 흩어진 자격증·시험 일정을 공식 1차 출처 중심으로 통합하고, 사용자가 접수일·시험일·발표일을 놓치지 않도록 일정 관리, 비교, 학습 계획, AI 브리핑을 연결합니다.  
핵심 원칙은 **“AI가 사실을 만들어내는 것이 아니라, 공식 데이터를 이해하기 쉽게 설명하고 사용자가 출처를 직접 검증할 수 있게 하는 것”**입니다.

## 1. 문제 정의

자격증을 준비할 때 수험생은 Q-Net, DATAQ, 한국사능력검정시험, KPC, 대한상공회의소, TOEIC 등 여러 사이트를 반복해서 확인해야 합니다. 이 과정에서 다음 문제가 발생합니다.

- 기관마다 접수·시험·발표 일정이 서로 다른 형식으로 제공됨
- 여러 자격증을 함께 준비할 때 일정 충돌과 우선순위를 한눈에 파악하기 어려움
- 접수 마감이나 시험일을 놓치기 쉬움
- 일반 생성형 AI만 사용하면 미발표 일정이나 잘못된 날짜가 섞일 위험이 있음
- 일정 확인 이후의 비교·학습 계획·관심 자격증 관리가 서로 분리되어 있음

CERTI:ON은 이를 **공식 일정 통합 → 일정 관리 → 비교/우선순위 판단 → AI 설명 → 출처 확인**의 한 흐름으로 연결합니다.

## 2. 주요 기능

- 공식 일정 기반 자격증/시험 탐색 및 검색
- 접수 시작·접수 마감·시험일·발표일 통합 확인
- 관심 자격증 및 D-Day 중심 일정 관리
- 자격증 비교와 준비 우선순위 판단 보조
- AI 핵심 브리핑 및 추가 질문
- 공식 출처 링크를 통한 원문 검증
- 휴대폰 온디바이스 AI와 선택형 PC 고성능 AI 지원
- 앱에 포함된 공식 일정 스냅샷: **고정 일정 101건 + 상시시험 6종**

## 3. 시스템 아키텍처

```text
┌──────────────────────────────┐
│        Flutter Android App   │
│  홈 · 탐색 · 일정 · AI · MY │
└──────────────┬───────────────┘
               │
       ┌───────┴────────┐
       │                │
       ▼                ▼
┌───────────────┐  ┌────────────────────┐
│ 앱 내 공식 데이터 │  │ 휴대폰 온디바이스 AI │
│ JSON 101+6건   │  │ llama_flutter_android │
│ 공식 URL 포함  │  │ Qwen3 GGUF          │
└───────────────┘  └────────────────────┘
                         │
                         │ 선택 사용
                         ▼
                  ┌──────────────────┐
                  │ PC Node Backend  │
                  │ :8787            │
                  └────────┬─────────┘
                           ▼
                  ┌──────────────────┐
                  │ Ollama :11434    │
                  │ Qwen3 4B/8B/14B │
                  └──────────────────┘
```

휴대폰 단독 모드에서는 다운로드한 GGUF 모델로 PC 없이 AI 기능을 사용할 수 있습니다. 더 높은 성능이 필요한 경우 같은 Wi-Fi의 PC에서 Ollama를 실행해 4B/8B/14B 모델을 선택적으로 사용할 수 있습니다.

## 4. 기술 스택

| 구분 | 사용 기술 |
|---|---|
| 앱 | Flutter / Dart |
| 모바일 | Android ARM64 |
| 온디바이스 AI | `llama_flutter_android` + Qwen3 GGUF |
| PC AI | Ollama + Qwen3 4B / 8B / 14B |
| 백엔드 | Node.js HTTP Server |
| 자동화 | Windows Batch / PowerShell |
| 데이터 | JSON 기반 공식 일정 스냅샷 |
| 네트워크 | 동일 Wi-Fi 기반 PC AI 연결, TCP 8787 |

주요 Flutter 패키지:

- `http: 1.6.0`
- `path_provider: 2.1.5`
- `llama_flutter_android: 0.2.6`

## 5. 실행 방법

### 준비 환경

- Windows
- Flutter `3.35.0` 이상
- Dart SDK `3.4.0` 이상
- Java 17 이상
- Android USB 디버깅이 허용된 ARM64 Android 기기
- PC AI를 사용할 경우 Ollama

### 원클릭 실행

저장소 루트에서 다음 파일을 실행합니다.

```bat
RUN_CERTION_ALL.bat
```

이 스크립트는 Android SDK/NDK/CMake 확인, Flutter 패키지 설치, Android 빌드 준비, 한글 UTF-8 패치, ARM64 Release APK 빌드, 연결된 휴대폰 업데이트 설치, PC IP 탐지, 방화벽 설정, Ollama/백엔드 실행을 순서대로 처리합니다.

빌드가 성공하면 APK는 다음 위치에 생성됩니다.

```text
OUTPUT\CERTI_ON.apk
```

휴대폰 AI 모델은 앱에서 최초 1회 다운로드하며, 이후에는 해당 모델을 유지하기 위해 자동 `uninstall`을 수행하지 않습니다.

## 6. 공식 데이터 및 출처 원칙

앱에 포함된 일정 데이터는 공식 1차 출처를 기준으로 구성하며, 미발표 날짜를 임의로 생성하지 않는 것을 원칙으로 합니다.

주요 공식 출처:

- Q-Net: https://www.q-net.or.kr
- DATAQ: https://www.dataq.or.kr
- 한국사능력검정시험: https://www.historyexam.go.kr
- 대한상공회의소 자격평가사업단: https://license.korcham.net
- KPC 자격: https://license.kpc.or.kr
- TOEIC: https://exam.toeic.co.kr
- KAIT/정보통신기술자격검정: https://www.ihd.or.kr

각 일정 항목의 공식 URL은 `assets/data/certificates.seed.json` 및 `assets/data/rolling_exams.json`에 함께 저장되어 있습니다.

## 7. AI 사용 내역

### 앱 실행에 사용되는 AI

- **휴대폰 고품질 모드:** Qwen3 1.7B Q4_K_M GGUF
- **휴대폰 빠른 모드:** Qwen3 0.6B Q4_0 GGUF
- **PC 선택형 AI:** Ollama 기반 Qwen3 4B / 8B / 14B
- AI는 공식 일정 DB를 설명·요약하고 질문에 답하는 보조 역할로 사용합니다.
- 일정이 미발표되었거나 공식 근거가 없는 경우 임의 날짜를 생성하지 않도록 설계했습니다.

모델 배포 출처:

- Qwen3 1.7B GGUF: https://huggingface.co/ggml-org/Qwen3-1.7B-GGUF
- Qwen3 0.6B GGUF: https://huggingface.co/ggml-org/Qwen3-0.6B-GGUF

### 개발 과정에서 사용한 생성형 AI

- **ChatGPT (OpenAI):** 아이디어 구조화, 코드 검토·디버깅 보조, 문서 정리 및 테스트 시나리오 검토에 활용했습니다.
- 생성형 AI의 결과를 그대로 제출하는 방식이 아니라, 실제 프로젝트 구조·코드·공식 일정 데이터와 대조하여 필요한 내용을 선택·수정하는 보조 도구로 사용했습니다.

## 8. 외부 사용 내역

대회 제출 시 외부 사용 내역을 명확히 공개하기 위해 아래와 같이 기록합니다.

- **AI 모델/도구:** Qwen3 0.6B·1.7B·4B·8B·14B, Ollama, ChatGPT(OpenAI)
- **오픈소스 패키지:** Flutter, `http`, `path_provider`, `llama_flutter_android`
- **모델 배포/변환 자산:** ggml-org의 Qwen3 GGUF 배포본
- **외부 자문(교사/현직자):** 별도 외부 자문 없음

## 9. 라이선스

이 저장소에는 프로젝트 자체에 대한 별도의 `LICENSE` 파일이 포함되어 있지 않습니다. 따라서 별도 허가가 없는 한 프로젝트 소스의 저작권은 제작자에게 있으며, 외부 라이브러리·AI 모델·공식 데이터는 각각의 원 저작권자 및 제공처가 정한 라이선스와 이용약관을 따릅니다.

특히 Flutter 패키지, Ollama, Qwen3/GGUF 모델 등 외부 구성요소를 재배포하거나 수정할 경우 각 원본 프로젝트의 라이선스를 별도로 확인해야 합니다.
