import 'package:nioudem/domain/entities/trip_entity.dart';
import 'package:nioudem/domain/repositories/trip_repository.dart';

class SearchTripsUseCase {
  const SearchTripsUseCase(this._repository);
  final TripRepository _repository;

  Future<List<TripEntity>> call(SearchQueryEntity query) {
    return _repository.searchTrips(query);
  }
}
