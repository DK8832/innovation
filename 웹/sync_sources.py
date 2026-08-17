"""공공데이터 동기화 CLI.

    python sync_sources.py                # 올해 일정 동기화
    python sync_sources.py --year 2026
    python sync_sources.py --show-schema  # 응답 필드 이름을 그대로 덤프 (스키마 확인용)

exams.json은 절대 수정하지 않는다. 변경 후보만 backend/data/review_queue.json에 쌓는다.
"""
import argparse
import json
import sys
from datetime import date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "backend"))

for _stream in (sys.stdout, sys.stderr):
    if hasattr(_stream, "reconfigure"):
        _stream.reconfigure(encoding="utf-8", errors="replace")

from sources import pipeline, public_api  # noqa: E402


def main() -> int:
    parser = argparse.ArgumentParser(description="공공데이터 시험일정 동기화")
    parser.add_argument("--year", type=int, default=date.today().year, help="시행년도")
    parser.add_argument(
        "--show-schema",
        action="store_true",
        help="응답 첫 행의 필드명을 그대로 출력한다 (실제 스키마 확인용)",
    )
    args = parser.parse_args()

    if not public_api.has_key():
        print("공공데이터 API 키가 없습니다.")
        print(f"  환경변수 {public_api.KEY_ENV} 또는 저장소 루트의 {public_api.KEY_FILE} 첫 줄에 넣으세요.")
        print("  (키가 없어도 큐레이션 데이터로 서비스는 정상 동작합니다)")
        return 1

    if args.show_schema:
        result = public_api.fetch_schedules(impl_year=args.year)
        if not result.ok:
            print(f"실패: {result.reason}")
            return 1
        print(f"{len(result.rows)}건 수신")
        if result.raw_sample:
            print("첫 행의 필드:")
            print(json.dumps(result.raw_sample, ensure_ascii=False, indent=2))
        return 0

    outcome = pipeline.run_sync(impl_year=args.year)
    state = outcome["state"]

    if not state["ok"]:
        print(f"동기화 실패: {state['reason']}")
        return 1

    changes = outcome["changes"]
    print(f"수신 {state['rows']}건 / 종목 매칭 {state.get('matched_exams', 0)}개")
    print(f"검토가 필요한 변경: {len(changes)}건")
    for c in changes[:20]:
        print(f"  [{c['change_type']}] {c['exam_name']} {c['session_key']}")
        print(f"      현재: {c['current']}")
        print(f"      수집: {c['proposed']}")
    if len(changes) > 20:
        print(f"  ... 외 {len(changes) - 20}건")
    print()
    print(f"검토 큐: {pipeline.REVIEW_PATH}")
    print("확인 후 backend/data/exams.json에 직접 반영하세요 (자동 반영하지 않습니다).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
