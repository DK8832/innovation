#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
catalog = []
for part in sorted((ROOT / 'release_catalog').glob('part-*.json')):
    catalog.extend(json.loads(part.read_text(encoding='utf-8')))
catalog.sort(key=lambda x: x['order'])
if len(catalog) != 24:
    raise SystemExit(f'Expected 24 catalog entries, got {len(catalog)}')

KOREAN_META = {
    1: ('기반 구축', '자격증 통합 플랫폼 기준선'),
    2: ('경량 시제품', '시연 중심 구조 단순화'),
    3: ('전체 기능 복원', '공식 데이터·백엔드 재통합'),
    4: ('UI 개선', '시각 자산 전면 정비'),
    5: ('클라우드 AI 연동', 'OpenAI 실행 환경 자동화'),
    6: ('프로젝트 정리', '실행 구조 단순화'),
    7: ('개발환경 개선', 'VS Code·AI 실행 자동화'),
    8: ('실행 안정화', '전체 기능 안정화 기준본'),
    9: ('웹 안정성 개선', '백엔드 포트 분리·실행 수정'),
    10: ('로컬 AI 전환', 'Ollama + Qwen3 아키텍처'),
    11: ('로컬 AI 사용성 개선', '빠른 시작·모델 관리'),
    12: ('Android 네이티브 기준본', '기존 UI + Qwen3 14B'),
    13: ('스마트 채팅 문맥 개선', '프롬프트·응답 파이프라인 수정'),
    14: ('웹 테스트 환경 개선', 'Chrome 실행 안정화'),
    15: ('다중 AI 모델 지원', '14B / 8B / 4B 선택'),
    16: ('독립형 AI 아키텍처', '온디바이스 우선 구조'),
    17: ('Android 빌드 강화', 'Gradle / SDK 검증'),
    18: ('툴체인 안정화', 'NDK 고정·LAN 자동 탐색'),
    19: ('연결 복구 강화', 'Ollama / 방화벽 / 모델 다운로드'),
    20: ('UTF-8 스트리밍 수정', '한글 토큰 깨짐 방지'),
    21: ('Qwen3 응답 복구', 'No-Think fallback·APK 빌더'),
    22: ('내부 추론 노출 방지', 'reasoning 차단·빌드 lock 보호'),
    23: ('릴리스 후보', 'fallback·백엔드 검증'),
    24: ('대회 최종본', '원클릭 통합 실행'),
}


def korean_title(item: dict) -> str:
    phase, subtitle = KOREAN_META[item['order']]
    return f"CERTI:ON {item['tag']} — {phase} · {subtitle}"


def previous_label(order: int) -> str:
    if order == 1:
        return '최초 기준본'
    if order == 24:
        return 'v0.23.0'
    return f'v0.{order - 1}.0'


def release_body(item: dict) -> str:
    delta = item['delta']
    highlights = '\n'.join(f"- {text}" for text in item['highlights'])
    status = '개발 기록' if item['prerelease'] else '대회 제출용 안정 버전'
    return f"""# {korean_title(item)}

> **{status} {item['order']:02d}/24** · 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 정렬한 역사 버전입니다.

## 개요
{item['overview']}

## {previous_label(item['order'])} 대비 변경 사항
{highlights}

## 기술 변경 내역
- **파일 변화:** `+{delta['added']} 추가 / -{delta['removed']} 삭제 / ~{delta['modified']} 수정`
- **내부 Flutter 버전:** `{item['pubspec_version']}`
- **대표 변경 경로:** {item['representative_paths']}

## 보관된 원본 소스
- **원본 폴더:** `{item['original_folder']}`
- **원본 수정 시각:** `{item['modified_time_kst']} KST`
- **해당 버전 원본 Asset:** `{item['asset']}`
- **소스 파일 수:** `{item['source_files']}`
- **SHA-256:** `{item['sha256']}`

## 무결성 및 패키징 안내
위의 `__SOURCE.zip` 파일이 이 버전의 실제 역사 프로젝트 스냅샷입니다. `build`, `.dart_tool`, Gradle 캐시 등 다시 생성 가능한 빌드 산출물과 `.env`, `local.properties` 같은 개인 환경·비밀 설정 파일은 공개 보관본에서 의도적으로 제외했습니다. GitHub가 자동으로 표시하는 **Source code (zip/tar.gz)** 는 태그 기준 저장소 압축본이므로, 각 시점의 실제 프로젝트 원본을 확인할 때는 반드시 위 `__SOURCE.zip` Asset을 사용해야 합니다.
"""


for item in catalog:
    out = ROOT / 'releases' / item['tag'] / 'RELEASE_NOTES.md'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(release_body(item).rstrip() + '\n', encoding='utf-8')

lines = [
    '# CERTI:ON 버전 변경 기록',
    '',
    '> 원본 프로젝트 폴더의 수정 시각(KST)을 기준으로 24개 버전을 정렬했습니다. `v0.x`는 개발 과정의 사전 릴리스 기록이며, `v1.0.0`은 대회 제출용 최종 통합 버전입니다.',
    '',
]
for item in sorted(catalog, key=lambda x: x['order'], reverse=True):
    d = item['delta']
    phase, subtitle = KOREAN_META[item['order']]
    lines += [
        f"## {item['tag']} — {phase} · {subtitle}",
        f"- 원본 스냅샷: `{item['original_folder']}` · {item['modified_time_kst']} KST",
        f"- 내부 Flutter 버전: `{item['pubspec_version']}`",
        f"- 역사 버전 Asset: `{item['asset']}`",
        f"- SHA-256: `{item['sha256']}`",
        f"- 파일 변화: `+{d['added']} / -{d['removed']} / ~{d['modified']}`",
        '',
    ]
(ROOT / 'CHANGELOG.md').write_text('\n'.join(lines).rstrip() + '\n', encoding='utf-8')
print(f'24개 버전의 한국어 릴리스 설명과 CHANGELOG.md 생성을 완료했습니다.')
