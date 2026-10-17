import 'package:flutter_test/flutter_test.dart';
import 'package:nioudem/src/app/siraya_app.dart';
import 'package:nioudem/src/shared/widgets/siraya_logo.dart';

void main() {
  testWidgets('SIRAYA app starts cleanly on root canvas', (WidgetTester tester) async {
    await tester.pumpWidget(const SirayaApp());

    expect(find.byType(SirayaLogo), findsOneWidget);
  });
}
