import 'package:flutter_test/flutter_test.dart';
import 'package:nioudem/src/app/siraya_app.dart';

void main() {
  testWidgets('SIRAYA app starts on entry screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SirayaApp());

    expect(find.text('Commencer'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('Commencer opens onboarding before registration', (WidgetTester tester) async {
    await tester.pumpWidget(const SirayaApp());

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(find.text('Trouvez les meilleurs départs facilement'), findsOneWidget);
    expect(find.text('Suivant'), findsOneWidget);
  });
}
