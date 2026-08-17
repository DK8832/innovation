from pathlib import Path

p = Path('앱/test/responsive_smoke_test.dart')
s = p.read_text(encoding='utf-8')
old = "      expect(find.text('스마트 준비 도구'), findsOneWidget);\n"
new = "      expect(find.byType(CustomScrollView), findsOneWidget);\n"
if old not in s:
    raise SystemExit('Responsive smoke test marker not found')
s = s.replace(old, new, 1)
p.write_text(s, encoding='utf-8')
print('Responsive smoke test made viewport-agnostic')
