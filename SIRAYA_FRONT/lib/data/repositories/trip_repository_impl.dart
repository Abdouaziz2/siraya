import 'package:nioudem/data/datasources/trip_remote_data_source.dart';
import 'package:nioudem/data/models/search_query_model.dart';
import 'package:nioudem/domain/entities/trip_entity.dart';
import 'package:nioudem/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl(this._remoteDataSource);
  final TripRemoteDataSource _remoteDataSource;

  @override
  Future<List<TripEntity>> searchTrips(SearchQueryEntity query) {
    return _remoteDataSource.searchTrips(SearchQueryModel.fromEntity(query));
  }

  @override
  Future<List<TripEntity>> getPopularRoutes() {
    return _remoteDataSource.getPopularRoutes();
  }
}

