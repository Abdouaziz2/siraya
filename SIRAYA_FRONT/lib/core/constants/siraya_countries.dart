import 'package:nioudem/domain/entities/country_entity.dart';

/// Liste officielle et dynamique des pays pris en charge par SIRAYA.
/// Basée sur les corridors de transport terrestre de la CEDEAO et de l'Afrique de l'Ouest.
abstract class SirayaCountries {
  static const CountryEntity senegal = CountryEntity(
    name: 'Sénégal',
    isoCode: 'SN',
    dialCode: '+221',
    flagEmoji: '🇸🇳',
    exampleNumber: '77 123 45 67',
    minLength: 9,
    maxLength: 9,
  );

  static const List<CountryEntity> all = [
    senegal,
    CountryEntity(
      name: 'Mali',
      isoCode: 'ML',
      dialCode: '+223',
      flagEmoji: '🇲🇱',
      exampleNumber: '66 12 34 56',
      minLength: 8,
      maxLength: 8,
    ),
    CountryEntity(
      name: 'Côte d’Ivoire',
      isoCode: 'CI',
      dialCode: '+225',
      flagEmoji: '🇨🇮',
      exampleNumber: '07 12 34 56 78',
      minLength: 10,
      maxLength: 10,
    ),
    CountryEntity(
      name: 'Gambie',
      isoCode: 'GM',
      dialCode: '+220',
      flagEmoji: '🇬🇲',
      exampleNumber: '701 23 45',
      minLength: 7,
      maxLength: 8,
    ),
    CountryEntity(
      name: 'Guinée',
      isoCode: 'GN',
      dialCode: '+224',
      flagEmoji: '🇬🇳',
      exampleNumber: '620 12 34 56',
      minLength: 9,
      maxLength: 9,
    ),
    CountryEntity(
      name: 'Burkina Faso',
      isoCode: 'BF',
      dialCode: '+226',
      flagEmoji: '🇧🇫',
      exampleNumber: '70 12 34 56',
      minLength: 8,
      maxLength: 8,
    ),
    CountryEntity(
      name: 'Bénin',
      isoCode: 'BJ',
      dialCode: '+229',
      flagEmoji: '🇧🇯',
      exampleNumber: '97 12 34 56',
      minLength: 8,
      maxLength: 8,
    ),
    CountryEntity(
      name: 'Togo',
      isoCode: 'TG',
      dialCode: '+228',
      flagEmoji: '🇹🇬',
      exampleNumber: '90 12 34 56',
      minLength: 8,
      maxLength: 8,
    ),
    CountryEntity(
      name: 'Niger',
      isoCode: 'NE',
      dialCode: '+227',
      flagEmoji: '🇳🇪',
      exampleNumber: '90 12 34 56',
      minLength: 8,
      maxLength: 8,
    ),
    CountryEntity(
      name: 'Nigéria',
      isoCode: 'NG',
      dialCode: '+234',
      flagEmoji: '🇳🇬',
      exampleNumber: '802 123 4567',
      minLength: 10,
      maxLength: 11,
    ),
    CountryEntity(
      name: 'Mauritanie',
      isoCode: 'MR',
      dialCode: '+222',
      flagEmoji: '🇲🇷',
      exampleNumber: '45 12 34 56',
      minLength: 8,
      maxLength: 8,
    ),
    CountryEntity(
      name: 'Ghana',
      isoCode: 'GH',
      dialCode: '+233',
      flagEmoji: '🇬🇭',
      exampleNumber: '24 123 4567',
      minLength: 9,
      maxLength: 10,
    ),
    CountryEntity(
      name: 'France',
      isoCode: 'FR',
      dialCode: '+33',
      flagEmoji: '🇫🇷',
      exampleNumber: '6 12 34 56 78',
      minLength: 9,
      maxLength: 10,
    ),
  ];

  /// Recherche dynamique dans la liste des pays.
  static List<CountryEntity> search(String query) {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return all;

    return all.where((c) {
      return c.name.toLowerCase().contains(clean) ||
          c.dialCode.contains(clean) ||
          c.isoCode.toLowerCase().contains(clean);
    }).toList();
  }
}
