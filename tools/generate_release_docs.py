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

def previous_label(order: int) -> str:
    if order == 1:
        return 'Initial baseline'
    if order == 24:
        return 'v0.23.0'
    return f'v0.{order - 1}.0'

def release_body(item: dict) -> str:
    delta = item['delta']
    highlights = '\n'.join(f"- {text}" for text in item['highlights'])
    status = 'Development archive' if item['prerelease'] else 'Stable competition release'
    return f"""# {item['title']}

> **{status} {item['order']:02d}/24** · chronological snapshot based on the original folder modified time (KST)

## Overview
{item['overview']}

## What changed from {previous_label(item['order'])}
{highlights}

## Technical delta
- **File delta:** `+{delta['added']} added / -{delta['removed']} removed / ~{delta['modified']} modified`
- **Internal Flutter version:** `{item['pubspec_version']}`
- **Representative changed paths:** {item['representative_paths']}

## Archived source
- **Original folder:** `{item['original_folder']}`
- **Original modified time:** `{item['modified_time_kst']} KST`
- **Historical source asset:** `{item['asset']}`
- **Source files:** `{item['source_files']}`
- **SHA-256:** `{item['sha256']}`

## Integrity / packaging note
The custom `__SOURCE.zip` asset above is the authoritative source snapshot for this historical release. Generated build/cache output (`build`, `.dart_tool`, Gradle caches, etc.) and private environment files such as `.env`/`local.properties` are intentionally excluded. GitHub's automatically generated **Source code (zip/tar.gz)** links are repository-tag archives and are not substitutes for the historical project asset.
"""

for item in catalog:
    out = ROOT / 'releases' / item['tag'] / 'RELEASE_NOTES.md'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(release_body(item).rstrip() + '\n', encoding='utf-8')

lines = [
    '# CERTI:ON Release History',
    '',
    '> Historical releases are ordered by the original project-folder modified time (KST). `v0.x` entries are development/pre-release snapshots; `v1.0.0` is the competition final integrated release.',
    '',
]
for item in sorted(catalog, key=lambda x: x['order'], reverse=True):
    d = item['delta']
    lines += [
        f"## {item['tag']} — {item['phase']} · {item['subtitle']}",
        f"- Snapshot: `{item['original_folder']}` · {item['modified_time_kst']} KST",
        f"- Internal Flutter version: `{item['pubspec_version']}`",
        f"- Historical asset: `{item['asset']}`",
        f"- SHA-256: `{item['sha256']}`",
        f"- Delta: `+{d['added']} / -{d['removed']} / ~{d['modified']}`",
        '',
    ]
(ROOT / 'CHANGELOG.md').write_text('\n'.join(lines).rstrip() + '\n', encoding='utf-8')
print(f'Generated {len(catalog)} release notes and CHANGELOG.md')
