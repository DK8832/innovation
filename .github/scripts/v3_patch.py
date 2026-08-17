from pathlib import Path

# Flutter app: preserve illustration aspect ratio, cap visual frame width,
# and give the smart-tool cards enough vertical room across phone widths.
dart = Path('앱/lib/main.dart')
s = dart.read_text(encoding='utf-8')
old = '                fit: BoxFit.cover,'
if old not in s:
    raise SystemExit('AppAssetThumb BoxFit.cover marker not found')
s = s.replace(old, '                fit: BoxFit.contain,', 1)

home_marker = '      home: const AppShell(),'
if home_marker not in s:
    raise SystemExit('MaterialApp home marker not found')
builder = '''      builder: (context, child) {
        final media = MediaQuery.of(context);
        final frameWidth = math.min(media.size.width, 430.0);
        return ColoredBox(
          color: const Color(0xFFF3F0EE),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: frameWidth,
              height: media.size.height,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
      home: const AppShell(),'''
s = s.replace(home_marker, builder, 1)

ratio_marker = '      childAspectRatio: 1.16,'
if ratio_marker not in s:
    raise SystemExit('SmartToolGrid childAspectRatio marker not found')
s = s.replace(ratio_marker, '      childAspectRatio: 0.74,', 1)
dart.write_text(s, encoding='utf-8')

pub = Path('앱/pubspec.yaml')
p = pub.read_text(encoding='utf-8')
if 'version: 2.0.0+10' not in p:
    raise SystemExit('Expected app version 2.0.0+10 not found')
p = p.replace('version: 2.0.0+10', 'version: 3.0.0+11', 1)
if 'dev_dependencies:' not in p:
    marker = '\nflutter:\n'
    if marker not in p:
        raise SystemExit('pubspec flutter section marker not found')
    p = p.replace(marker, '\ndev_dependencies:\n  flutter_test:\n    sdk: flutter\n\nflutter:\n', 1)
pub.write_text(p, encoding='utf-8')

test = Path('앱/test/responsive_smoke_test.dart')
test.parent.mkdir(parents=True, exist_ok=True)
test.write_text(r'''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:certi_on/main.dart' as certion;

void main() {
  final sizes = <Size>[
    const Size(320, 720),
    const Size(360, 800),
    const Size(390, 844),
    const Size(430, 932),
    const Size(600, 960),
  ];

  for (final size in sizes) {
    testWidgets('CERTI:ON home has no layout exception at ${size.width}x${size.height}', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = size;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(const certion.CertiOnApp());
      await tester.pump(const Duration(milliseconds: 800));
      expect(tester.takeException(), isNull);
      expect(find.text('CERTI:ON'), findsWidgets);
      final scroll = find.byType(CustomScrollView).first;
      await tester.drag(scroll, const Offset(0, -850));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
      expect(find.text('스마트 준비 도구'), findsOneWidget);
    });
  }
}
''', encoding='utf-8')

# Website: harden layout for phones without changing the desktop design.
css = Path('웹/frontend/style.css')
c = css.read_text(encoding='utf-8')
marker = '/* CERTI:ON v3 mobile hardening */'
if marker not in c:
    c += r'''

/* CERTI:ON v3 mobile hardening */
html, body { width: 100%; max-width: 100%; overflow-x: hidden; }
img, svg, video, canvas { max-width: 100%; }

@media (max-width: 700px) {
  .container { width: 100%; max-width: none; padding-left: 14px; padding-right: 14px; }
  .floating-nav {
    top: 10px; left: 12px; right: 12px; width: auto; max-width: none; transform: none;
    padding: 10px; gap: 8px; border-radius: 20px; flex-direction: column; align-items: stretch;
  }
  .floating-nav .logo { justify-content: center; width: 100%; font-size: 14px; }
  .view-switch {
    width: 100%; min-width: 0; overflow-x: auto; overscroll-behavior-inline: contain;
    -webkit-overflow-scrolling: touch; scrollbar-width: none; justify-content: flex-start;
  }
  .view-switch::-webkit-scrollbar, .filter-group::-webkit-scrollbar, .upcoming-row::-webkit-scrollbar { display: none; }
  .view-btn { flex: 0 0 auto; padding: 7px 11px; font-size: 12px; }
  main.container { padding-top: 138px; padding-bottom: 40px; }
  .hero-intro { max-width: none; margin-bottom: 28px; }
  .eyebrow { font-size: 10.5px; margin-bottom: 12px; }
  .display-h1 { font-size: clamp(26px, 8.4vw, 32px); line-height: 1.24; overflow-wrap: anywhere; }
  .hero-body { font-size: 13.5px; line-height: 1.65; }
  .app-download {
    grid-template-columns: minmax(0, 1fr); gap: 18px; padding: 22px 18px;
    border-radius: 22px; margin-bottom: 30px;
  }
  .app-download h2 { font-size: 24px; }
  .app-download-copy > p { font-size: 12.5px; }
  .app-download-actions { width: 100%; flex-direction: column; align-items: stretch; gap: 10px; }
  .app-download-button { width: 100%; }
  .app-install-link { text-align: center; }
  .app-install-panel { padding: 16px; }
  .app-install-panel li { font-size: 12px; }
  .upcoming-row {
    width: 100%; overflow-x: auto; scroll-snap-type: x proximity;
    scrollbar-width: none; -webkit-overflow-scrolling: touch;
  }
  .upcoming-card { min-width: min(82vw, 280px); scroll-snap-align: start; }
  .filter-bar { flex-direction: column; align-items: stretch; gap: 10px; }
  .filter-group {
    width: 100%; flex-wrap: nowrap; overflow-x: auto; -webkit-overflow-scrolling: touch;
    scrollbar-width: none; padding-bottom: 3px;
  }
  .chip { flex: 0 0 auto; padding: 7px 13px; font-size: 12px; }
  .search-box, .search-box input { width: 100%; min-width: 0; }
  .calendar-nav { gap: 10px; }
  .calendar-weekdays { font-size: 10px; }
  .calendar-grid { gap: 3px; }
  .cal-cell { min-width: 0; min-height: 54px; padding: 4px 2px; border-radius: 10px; }
  .cal-cell .cal-date { font-size: 10px; }
  .cal-dots { gap: 2px; }
  .cal-dot { width: 5px; height: 5px; }
  .event-row { align-items: flex-start; flex-wrap: wrap; gap: 8px; }
  .event-row .event-main { flex-basis: calc(100% - 24px); }
  .event-row .event-date { width: 100%; white-space: normal; }
  .rolling-row { display: grid; grid-template-columns: 1fr; }
  .footer-dark { margin-top: 40px; border-radius: 24px 24px 0 0; }
}

@media (max-width: 360px) {
  .container { padding-left: 12px; padding-right: 12px; }
  .floating-nav { left: 8px; right: 8px; top: 8px; padding: 8px; }
  .view-btn { font-size: 11px; padding: 7px 9px; }
  main.container { padding-top: 132px; }
  .display-h1 { font-size: 25px; }
  .app-download { padding: 20px 16px; }
  .app-download h2 { font-size: 22px; }
  .cal-cell { min-height: 50px; }
}
'''
css.write_text(c, encoding='utf-8')

html = Path('웹/frontend/index.html')
h = html.read_text(encoding='utf-8')
h = h.replace('v2.0.0 · Android · 설치 파일 확인 중', 'v3.0.0 · Android · 설치 파일 확인 중')
h = h.replace('releases/download/v2.0.0/CERTI_ON_v2.0.0_ANDROID.apk', 'releases/download/v3.0.0/CERTI_ON_v3.0.0_ANDROID.apk')
h = h.replace('download="CERTI_ON_v2.0.0_ANDROID.apk"', 'download="CERTI_ON_v3.0.0_ANDROID.apk"')
html.write_text(h, encoding='utf-8')

static = Path('웹/frontend/static_api.js')
a = static.read_text(encoding='utf-8')
a = a.replace('releases/download/v2.0.0/CERTI_ON_v2.0.0_ANDROID.apk', 'releases/download/v3.0.0/CERTI_ON_v3.0.0_ANDROID.apk')
a = a.replace('CERTI_ON_v2.0.0_ANDROID.apk', 'CERTI_ON_v3.0.0_ANDROID.apk')
a = a.replace('version: "2.0.0"', 'version: "3.0.0"')
a = a.replace("version: '2.0.0'", "version: '3.0.0'")
static.write_text(a, encoding='utf-8')

print('CERTI:ON v3 workspace patch applied')
