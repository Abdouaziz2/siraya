import 'package:flutter_test/flutter_test.dart';
import 'package:nioudem/core/constants/app_constants.dart';
import 'package:nioudem/presentation/app.dart';
import 'package:nioudem/presentation/widgets/siraya_logo.dart';

void main() {
  testWidgets('SIRAYA app starts cleanly on root canvas', (WidgetTester tester) async {
    await tester.pumpWidget(const SirayaApp());

    expect(find.byType(SirayaLogo), findsOneWidget);

    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();
  });
}
