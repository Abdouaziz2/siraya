import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/shared/widgets/siraya_badge.dart';
import 'package:nioudem/src/shared/widgets/siraya_buttons.dart';

void main() {
  group('SIRAYA Design System Tokens & Widgets', () {
    test('Tokens verify 8dp grid constants', () {
      expect(SirayaSpacing.xs, 8.0);
      expect(SirayaSpacing.md, 16.0);
      expect(SirayaSpacing.buttonHeight, 50.0);
      expect(SirayaSpacing.minTouchTarget, 48.0);
    });

    testWidgets('SirayaPrimaryButton has >= 50dp touch height', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirayaPrimaryButton(
              label: 'Rechercher',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(SirayaPrimaryButton);
      expect(buttonFinder, findsOneWidget);

      final size = tester.getSize(buttonFinder);
      expect(size.height, greaterThanOrEqualTo(50.0));

      await tester.tap(buttonFinder);
      expect(pressed, isTrue);
    });

    testWidgets('SirayaBadge displays label and variant styles', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SirayaBadge(
              label: 'VIP Climatisé',
              variant: SirayaBadgeVariant.success,
              icon: Icons.ac_unit,
            ),
          ),
        ),
      );

      expect(find.text('VIP Climatisé'), findsOneWidget);
      expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    });
  });
}
