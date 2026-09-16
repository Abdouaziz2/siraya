import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nioudem/src/core/theme/siraya_theme.dart';
import 'package:nioudem/src/features/search/presentation/screens/search_home_screen.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp(
      theme: SirayaTheme.light(),
      home: const SearchHomeScreen(),
    );
  }

  group('SearchHomeScreen UI & Responsive Tests', () {
    testWidgets('Renders header, hero tagline, route selector and reassurance cards', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());

      // Logo & Tagline
      expect(find.text('SIRAYA'), findsOneWidget);
      expect(find.text('Voyagez sans attendre.'), findsOneWidget);

      // Route selector labels
      expect(find.text('Départ'), findsOneWidget);
      expect(find.text('Destination'), findsOneWidget);
      expect(find.text('Date de départ'), findsOneWidget);
      expect(find.text('Rechercher des voyages'), findsOneWidget);

      // Popular corridors & features
      expect(find.text('Liaisons fréquentes'), findsOneWidget);
      expect(find.text('Billet numérique sécurisé'), findsOneWidget);
    });

    testWidgets('Selecting a popular corridor updates the route fields', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());

      final dakarBamako = find.text('Dakar ➔ Bamako');
      expect(dakarBamako, findsOneWidget);

      await tester.ensureVisible(dakarBamako);
      await tester.tap(dakarBamako);
      await tester.pumpAndSettle();

      expect(find.text('Dakar'), findsOneWidget);
      expect(find.text('Bamako'), findsOneWidget);
    });

    testWidgets('Tapping swap button inverts departure and destination', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());

      final dakarBamako = find.text('Dakar ➔ Bamako');
      await tester.ensureVisible(dakarBamako);
      await tester.tap(dakarBamako);
      await tester.pumpAndSettle();

      expect(find.text('Dakar'), findsOneWidget);
      expect(find.text('Bamako'), findsOneWidget);

      // Tap swap icon
      await tester.ensureVisible(find.byIcon(Icons.swap_vert_rounded));
      await tester.tap(find.byIcon(Icons.swap_vert_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Bamako'), findsOneWidget);
      expect(find.text('Dakar'), findsOneWidget);
    });

    testWidgets('Passenger counter increments and decrements within limits', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('1'), findsOneWidget);
      expect(find.text('place'), findsOneWidget);

      // Increment
      await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('places'), findsOneWidget);

      // Decrement back
      await tester.tap(find.byIcon(Icons.remove_circle_outline_rounded));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('place'), findsOneWidget);
    });

    testWidgets('Validates on all viewports (360, 375, 390, 412, 428) without overflow', (tester) async {
      final viewports = [
        const Size(360, 800),
        const Size(375, 812),
        const Size(390, 844),
        const Size(412, 915),
        const Size(428, 926),
      ];

      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final size in viewports) {
        tester.view.physicalSize = size;
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        expect(tester.takeException(), isNull, reason: 'Failed on viewport $size');
      }
    });
  });
}
