/// Entité métier représentant une recherche de trajet.
class SearchQueryEntity {
  const SearchQueryEntity({
    required this.departureCity,
    required this.arrivalCity,
    required this.departureDate,
    this.passengers = 1,
  });

  final String departureCity;
  final String arrivalCity;
  final DateTime departureDate;
  final int passengers;
}

/// Entité métier représentant un voyage en bus.
class TripEntity {
  const TripEntity({
    required this.id,
    required this.companyName,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.priceCfa,
    required this.availableSeats,
    this.isAirConditioned = true,
  });

  final String id;
  final String companyName;
  final String departureCity;
  final String arrivalCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double priceCfa;
  final int availableSeats;
  final bool isAirConditioned;
}

