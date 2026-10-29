import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nioudem/domain/entities/trip_entity.dart';

/// Modèle Trip avec sérialisation Firestore (Data Layer).
class TripModel extends TripEntity {
  const TripModel({
    required super.id,
    required super.companyName,
    required super.departureCity,
    required super.arrivalCity,
    required super.departureTime,
    required super.arrivalTime,
    required super.priceCfa,
    required super.availableSeats,
    super.isAirConditioned,
  });

  factory TripModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TripModel(
      id: doc.id,
      companyName: data['companyName'] as String? ?? 'Compagnie',
      departureCity: data['departureCity'] as String? ?? '',
      arrivalCity: data['arrivalCity'] as String? ?? '',
      departureTime: (data['departureTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      arrivalTime: (data['arrivalTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      priceCfa: (data['priceCfa'] as num?)?.toDouble() ?? 0.0,
      availableSeats: (data['availableSeats'] as num?)?.toInt() ?? 0,
      isAirConditioned: data['isAirConditioned'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'companyName': companyName,
    'departureCity': departureCity,
    'arrivalCity': arrivalCity,
    'departureTime': Timestamp.fromDate(departureTime),
    'arrivalTime': Timestamp.fromDate(arrivalTime),
    'priceCfa': priceCfa,
    'availableSeats': availableSeats,
    'isAirConditioned': isAirConditioned,
  };
}

