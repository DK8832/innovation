# v0.20.0 — 한글 UTF-8 토큰 깨짐 수정

원본 폴더: `CERTI_ON_OGQ_STANDALONE_AI_ALL_FIXED_V5`

- llama.cpp 토큰 경계에서 분리되는 UTF-8 byte를 누적 버퍼링
- 휴대폰 AI의 한글 `�` 문제 수정
