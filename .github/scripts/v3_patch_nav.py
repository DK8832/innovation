from pathlib import Path

p = Path('앱/lib/main.dart')
s = p.read_text(encoding='utf-8')

old = '''      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goTo,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: '홈'),
          NavigationDestination(icon: Icon(Icons.search_rounded), label: '탐색'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month_rounded), label: '일정'),
          NavigationDestination(
              icon: Icon(Icons.auto_awesome_rounded), label: 'AI 브리핑'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'MY'),
        ],
      ),'''
new = '''      bottomNavigationBar: _CertiBottomNav(
        selectedIndex: _index,
        onDestinationSelected: _goTo,
      ),'''
if old not in s:
    raise SystemExit('AppShell NavigationBar block not found')
s = s.replace(old, new, 1)

anchor = 'class HomePage extends StatelessWidget {'
if anchor not in s:
    raise SystemExit('HomePage anchor not found')
nav_class = r'''class _CertiBottomNav extends StatelessWidget {
  const _CertiBottomNav({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _items = <(IconData, String)>[
    (Icons.home_rounded, '홈'),
    (Icons.search_rounded, '탐색'),
    (Icons.calendar_month_rounded, '일정'),
    (Icons.auto_awesome_rounded, 'AI 브리핑'),
    (Icons.person_rounded, 'MY'),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 74,
          child: Row(
            children: List.generate(_items.length, (index) {
              final selected = selectedIndex == index;
              final item = _items[index];
              return Expanded(
                child: InkWell(
                  onTap: () => onDestinationSelected(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: 46,
                          height: 30,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFE8E2DA)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            item.$1,
                            size: 23,
                            color: selected
                                ? const Color(0xFF024AD8)
                                : const Color(0xFF141413),
                          ),
                        ),
                        const SizedBox(height: 3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            item.$2,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: selected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: selected
                                  ? const Color(0xFF024AD8)
                                  : const Color(0xFF696969),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

'''
s = s.replace(anchor, nav_class + anchor, 1)
p.write_text(s, encoding='utf-8')
print('Narrow-phone bottom navigation patch applied')
