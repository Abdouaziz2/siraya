import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nioudem/data/datasources/auth_remote_data_source.dart';
import 'package:nioudem/data/repositories/auth_repository_impl.dart';
import 'package:nioudem/domain/usecases/auth/send_otp_usecase.dart';
import 'package:nioudem/presentation/pages/auth/otp_page.dart';
import 'package:nioudem/presentation/pages/auth/phone_page.dart';

void main() {
  testWidgets('PhonePage renders Figma elements and handles OTP submission', (tester) async {
    final authDataSource = FirebaseAuthRemoteDataSourceImpl();
    final authRepo = AuthRepositoryImpl(authDataSource);
    final sendOtpUseCase = SendOtpUseCase(authRepo);

    await tester.pumpWidget(
      MaterialApp(
        home: PhonePage(sendOtpUseCase: sendOtpUseCase),
      ),
    );

    // 1. Vérification des éléments de la maquette Figma
    expect(find.text('Bienvenue sur SIRAYA'), findsOneWidget);
    expect(find.text('Sénégal (+221)'), findsOneWidget);
    expect(find.text('Recevoir le code'), findsOneWidget);

    // 2. Clic sur Recevoir le code
    await tester.tap(find.text('Recevoir le code'));
    await tester.pump();

    // Attente de la simulation de test (600ms)
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // 3. Navigation réussie vers OtpPage
    expect(find.byType(OtpPage), findsOneWidget);
    expect(find.text('Vérifiez votre numéro'), findsOneWidget);
  });
}
