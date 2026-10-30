import 'package:nioudem/domain/entities/city_entity.dart';

/// Données des villes et corridors de transport de SIRAYA (Afrique de l'Ouest).
abstract class SirayaCities {
  static const CityEntity dakar = CityEntity(
    name: 'Dakar',
    country: 'Sénégal',
    countryCode: 'SN',
    flagEmoji: '🇸🇳',
    isPopular: true,
    isRecent: true,
  );

  static const CityEntity bamako = CityEntity(
    name: 'Bamako',
    country: 'Mali',
    countryCode: 'ML',
    flagEmoji: '🇲🇱',
    isPopular: true,
    isRecent: true,
  );

  static const CityEntity kaolack = CityEntity(
    name: 'Kaolack',
    country: 'Sénégal',
    countryCode: 'SN',
    flagEmoji: '🇸🇳',
    isPopular: true,
    isRecent: true,
  );

  static const CityEntity thies = CityEntity(
    name: 'Thiès',
    country: 'Sénégal',
    countryCode: 'SN',
    flagEmoji: '🇸🇳',
    isPopular: true,
  );

  static const CityEntity diourbel = CityEntity(
    name: 'Diourbel',
    country: 'Sénégal',
    countryCode: 'SN',
    flagEmoji: '🇸🇳',
  );

  static const CityEntity saintLouis = CityEntity(
    name: 'Saint-Louis',
    country: 'Sénégal',
    countryCode: 'SN',
    flagEmoji: '🇸🇳',
  );

  static const CityEntity ziguinchor = CityEntity(
    name: 'Ziguinchor',
    country: 'Sénégal',
    countryCode: 'SN',
    flagEmoji: '🇸🇳',
  );

  static const CityEntity touba = CityEntity(
    name: 'Touba',
    country: 'Sénégal',
    countryCode: 'SN',
    flagEmoji: '🇸🇳',
  );

  static const CityEntity kayes = CityEntity(
    name: 'Kayes',
    country: 'Mali',
    countryCode: 'ML',
    flagEmoji: '🇲🇱',
    isPopular: true,
  );

  static const CityEntity sikasso = CityEntity(
    name: 'Sikasso',
    country: 'Mali',
    countryCode: 'ML',
    flagEmoji: '🇲🇱',
  );

  static const CityEntity segou = CityEntity(
    name: 'Ségou',
    country: 'Mali',
    countryCode: 'ML',
    flagEmoji: '🇲🇱',
  );

  static const CityEntity tombouctou = CityEntity(
    name: 'Tombouctou',
    country: 'Mali',
    countryCode: 'ML',
    flagEmoji: '🇲🇱',
    isPopular: true,
  );

  static const CityEntity ouaga = CityEntity(
    name: 'Ouaga',
    country: 'Burkina Faso',
    countryCode: 'BF',
    flagEmoji: '🇧🇫',
    isPopular: true,
  );

  static const CityEntity bobo = CityEntity(
    name: 'Bobo-Dioulasso',
    country: 'Burkina Faso',
    countryCode: 'BF',
    flagEmoji: '🇧🇫',
  );

  static const CityEntity abidjan = CityEntity(
    name: 'Abidjan',
    country: "Côte d'Ivoire",
    countryCode: 'CI',
    flagEmoji: '🇨🇮',
    isPopular: true,
  );

  static const CityEntity banjul = CityEntity(
    name: 'Banjul',
    country: 'Gambie',
    countryCode: 'GM',
    flagEmoji: '🇬🇲',
  );

  static const CityEntity conakry = CityEntity(
    name: 'Conakry',
    country: 'Guinée',
    countryCode: 'GN',
    flagEmoji: '🇬🇳',
  );

  static const CityEntity cotonou = CityEntity(
    name: 'Cotonou',
    country: 'Bénin',
    countryCode: 'BJ',
    flagEmoji: '🇧🇯',
  );

  static const CityEntity lome = CityEntity(
    name: 'Lomé',
    country: 'Togo',
    countryCode: 'TG',
    flagEmoji: '🇹🇬',
  );

  static const CityEntity niamey = CityEntity(
    name: 'Niamey',
    country: 'Niger',
    countryCode: 'NE',
    flagEmoji: '🇳🇪',
  );

  static const List<CityEntity> all = [
    dakar,
    bamako,
    kaolack,
    thies,
    diourbel,
    saintLouis,
    ziguinchor,
    touba,
    kayes,
    sikasso,
    segou,
    tombouctou,
    ouaga,
    bobo,
    abidjan,
    banjul,
    conakry,
    cotonou,
    lome,
    niamey,
  ];

  /// Villes récemment consultées (conformes à l'écran 10 de Figma).
  static const List<CityEntity> defaultRecent = [
    dakar,
    bamako,
    kaolack,
  ];

  /// Paires de destinations populaires d'Afrique de l'Ouest (Figma Écran 9).
  static const List<PopularDestination> popularRoutes = [
    PopularDestination(departure: dakar, arrival: bamako),
    PopularDestination(departure: dakar, arrival: kayes),
    PopularDestination(departure: bamako, arrival: ouaga),
    PopularDestination(departure: thies, arrival: tombouctou),
  ];
}

class PopularDestination {
  const PopularDestination({
    required this.departure,
    required this.arrival,
  });

  final CityEntity departure;
  final CityEntity arrival;

  String get label => '${departure.name} vers ${arrival.name}';
}
