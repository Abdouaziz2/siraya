import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nioudem/core/constants/app_constants.dart';
import 'package:nioudem/data/models/search_query_model.dart';
import 'package:nioudem/data/models/trip_model.dart';

abstract class TripRemoteDataSource {
  Future<List<TripModel>> searchTrips(SearchQueryModel query);
  Future<List<TripModel>> getPopularRoutes();
}

class FirestoreTripRemoteDataSourceImpl implements TripRemoteDataSource {
  FirestoreTripRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<List<TripModel>> searchTrips(SearchQueryModel query) async {
    final startOfDay = DateTime(
      query.departureDate.year,
      query.departureDate.month,
      query.departureDate.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .where('departureCity', isEqualTo: query.departureCity)
        .where('arrivalCity', isEqualTo: query.arrivalCity)
        .where('departureTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('departureTime', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('departureTime')
        .get();

    return snapshot.docs.map(TripModel.fromFirestore).toList();
  }

  @override
  Future<List<TripModel>> getPopularRoutes() async {
    final snapshot = await _firestore
        .collection(AppConstants.tripsCollection)
        .orderBy('departureTime')
        .limit(10)
        .get();

    return snapshot.docs.map(TripModel.fromFirestore).toList();
  }
}
