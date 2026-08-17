import 'package:flutter/material.dart';
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
      expect(find.byType(CustomScrollView), findsOneWidget);
    });
  }
}
