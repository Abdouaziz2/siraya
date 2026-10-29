import 'package:nioudem/domain/entities/trip_entity.dart';

/// Contrat du repository des voyages dans la couche Domain.
abstract class TripRepository {
  Future<List<TripEntity>> searchTrips(SearchQueryEntity query);
  Future<List<TripEntity>> getPopularRoutes();
}

