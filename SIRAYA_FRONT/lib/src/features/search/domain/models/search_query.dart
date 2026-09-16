/// Modèle de données pour la recherche de voyages SIRAYA.
class SearchQuery {
  const SearchQuery({
    this.departureCity,
    this.destinationCity,
    required this.departureDate,
    this.passengerCount = 1,
  });

  final String? departureCity;
  final String? destinationCity;
  final DateTime departureDate;
  final int passengerCount;

  bool get isComplete =>
      departureCity != null &&
      departureCity!.isNotEmpty &&
      destinationCity != null &&
      destinationCity!.isNotEmpty &&
      passengerCount > 0;

  SearchQuery copyWith({
    String? departureCity,
    String? destinationCity,
    DateTime? departureDate,
    int? passengerCount,
  }) {
    return SearchQuery(
      departureCity: departureCity ?? this.departureCity,
      destinationCity: destinationCity ?? this.destinationCity,
      departureDate: departureDate ?? this.departureDate,
      passengerCount: passengerCount ?? this.passengerCount,
    );
  }

  SearchQuery swapCities() {
    return copyWith(
      departureCity: destinationCity,
      destinationCity: departureCity,
    );
  }

  /// Liste des principales villes desservies en Afrique de l'Ouest
  static const List<Map<String, String>> westAfricanCities = [
    {'name': 'Dakar', 'country': 'Sénégal', 'flag': '🇸🇳', 'hub': 'Gare des Baux Maraîchers'},
    {'name': 'Bamako', 'country': 'Mali', 'flag': '🇲🇱', 'hub': 'Gare de Sogoniko'},
    {'name': 'Touba', 'country': 'Sénégal', 'flag': '🇸🇳', 'hub': 'Gare Routière Touba'},
    {'name': 'Saint-Louis', 'country': 'Sénégal', 'flag': '🇸🇳', 'hub': 'Gare de Khor'},
    {'name': 'Kayes', 'country': 'Mali', 'flag': '🇲🇱', 'hub': 'Gare Principale de Kayes'},
    {'name': 'Kaolack', 'country': 'Sénégal', 'flag': '🇸🇳', 'hub': 'Garage Nioro'},
    {'name': 'Tambacounda', 'country': 'Sénégal', 'flag': '🇸🇳', 'hub': 'Gare Centrale Tamba'},
    {'name': 'Ziguinchor', 'country': 'Sénégal', 'flag': '🇸🇳', 'hub': 'Gare Routière Ziguinchor'},
    {'name': 'Thiès', 'country': 'Sénégal', 'flag': '🇸🇳', 'hub': 'Gare Routière de Thiès'},
    {'name': 'Sikasso', 'country': 'Mali', 'flag': '🇲🇱', 'hub': 'Gare de Sikasso'},
    {'name': 'Ségou', 'country': 'Mali', 'flag': '🇲🇱', 'hub': 'Gare Routière de Ségou'},
    {'name': 'Abidjan', 'country': 'Côte d\'Ivoire', 'flag': '🇨🇮', 'hub': 'Gare d\'Adjamé'},
    {'name': 'Bouaké', 'country': 'Côte d\'Ivoire', 'flag': '🇨🇮', 'hub': 'Gare Centrale Bouaké'},
    {'name': 'Conakry', 'country': 'Guinée', 'flag': '🇬🇳', 'hub': 'Gare de Matam'},
    {'name': 'Ouagadougou', 'country': 'Burkina Faso', 'flag': '🇧🇫', 'hub': 'Gare Routière Ouaga'},
  ];
}
