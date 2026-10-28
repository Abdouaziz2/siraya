import 'package:nioudem/domain/entities/trip_entity.dart';

/// Modèle SearchQuery pour les requêtes de recherche.
class SearchQueryModel extends SearchQueryEntity {
  const SearchQueryModel({
    required super.departureCity,
    required super.arrivalCity,
    required super.departureDate,
    super.passengers,
  });

  factory SearchQueryModel.fromEntity(SearchQueryEntity entity) {
    return SearchQueryModel(
      departureCity: entity.departureCity,
      arrivalCity: entity.arrivalCity,
      departureDate: entity.departureDate,
      passengers: entity.passengers,
    );
  }
}
