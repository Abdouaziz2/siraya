import 'package:nioudem/src/features/search/domain/models/search_query.dart';

/// Contrat abstrait pour la recherche de trajets.
abstract class TripRepository {
  /// Recherche des trajets disponibles selon une requête.
  Future<List<SearchQuery>> searchTrips(SearchQuery query);

  /// Retourne les trajets populaires (homepage).
  Future<List<SearchQuery>> getPopularRoutes();
}
