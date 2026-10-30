import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nioudem/core/constants/siraya_cities.dart';
import 'package:nioudem/presentation/pages/home/city_selection_page.dart';
import 'package:nioudem/presentation/pages/home/home_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HomePage renders search form, destinations and partner companies',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(userName: 'Baye'),
      ),
    );

    // Vérifie le header de salutation
    expect(find.text('Bonjour, Baye 👋'), findsOneWidget);

    // Vérifie la question de recherche
    expect(find.text('Où souhaitez-vous aller ?'), findsOneWidget);
    expect(find.text('Départ'), findsOneWidget);
    expect(find.text('Arrivée'), findsOneWidget);
    expect(find.text('Rechercher'), findsOneWidget);

    // Vérifie les sections
    expect(find.text('Destinations populaires'), findsOneWidget);
    expect(find.text('Compagnies partenaires'), findsOneWidget);

    // Vérifie la bottom navigation
    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Recherche'), findsOneWidget);
    expect(find.text('Mes voyages'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('CitySelectionPage renders search bar and recent cities',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CitySelectionPage(title: 'Ville de départ'),
      ),
    );

    expect(find.text('Ville de départ'), findsOneWidget);
    expect(find.text('Rechercher une ville...'), findsOneWidget);
    expect(find.text('Villes récentes'), findsOneWidget);
    expect(find.text('Pays voisins et autres pays d’Afrique'), findsOneWidget);

    // Filtrer par recherche
    await tester.enterText(find.byType(TextField), 'Kayes');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Kayes'), findsOneWidget);
  });
}
