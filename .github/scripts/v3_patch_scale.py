from pathlib import Path

p = Path('앱/lib/main.dart')
s = p.read_text(encoding='utf-8')
old = '''      builder: (context, child) {
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
      },'''
new = '''      builder: (context, child) {
        final media = MediaQuery.of(context);
        const designWidth = 430.0;
        final scale = media.size.width < designWidth
            ? media.size.width / designWidth
            : 1.0;
        final designHeight = media.size.height / scale;
        final visibleWidth = media.size.width < designWidth
            ? media.size.width
            : designWidth;
        return ColoredBox(
          color: const Color(0xFFF3F0EE),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: visibleWidth,
              height: media.size.height,
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: designWidth,
                  height: designHeight,
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );
      },'''
if old not in s:
    raise SystemExit('Existing v3 frame builder not found')
s = s.replace(old, new, 1)
p.write_text(s, encoding='utf-8')
print('Fixed 430px scaled design frame applied')
