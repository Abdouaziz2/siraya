import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle d'un trajet de bus SIRAYA depuis Firestore
class FirestoreTrip {
  const FirestoreTrip({
    required this.id,
    required this.companyName,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.totalSeats,
    required this.availableSeats,
    required this.busClass,
    this.companyLogoUrl,
    this.amenities = const [],
  });

  final String id;
  final String companyName;
  final String departureCity;
  final String destinationCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int price;
  final int totalSeats;
  final int availableSeats;
  final String busClass; // ex: 'Standard', 'Confort+', 'Royal Class'
  final String? companyLogoUrl;
  final List<String> amenities; // ex: ['Climatisation', 'Wi-Fi', 'Prise USB']

  factory FirestoreTrip.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return FirestoreTrip(
      id: doc.id,
      companyName: data['companyName']?.toString() ?? 'SIRAYA Express',
      departureCity: data['departureCity']?.toString() ?? '',
      destinationCity: data['destinationCity']?.toString() ?? '',
      departureTime: (data['departureTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      arrivalTime: (data['arrivalTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      price: (data['price'] as num?)?.toInt() ?? 0,
      totalSeats: (data['totalSeats'] as num?)?.toInt() ?? 50,
      availableSeats: (data['availableSeats'] as num?)?.toInt() ?? 0,
      busClass: data['busClass']?.toString() ?? 'Standard',
      companyLogoUrl: data['companyLogoUrl']?.toString(),
      amenities: List<String>.from(data['amenities'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'departureCity': departureCity,
      'destinationCity': destinationCity,
      'departureTime': Timestamp.fromDate(departureTime),
      'arrivalTime': Timestamp.fromDate(arrivalTime),
      'price': price,
      'totalSeats': totalSeats,
      'availableSeats': availableSeats,
      'busClass': busClass,
      if (companyLogoUrl != null) 'companyLogoUrl': companyLogoUrl,
      'amenities': amenities,
    };
  }
}

/// Repository Firestore pour les trajets et réservations SIRAYA.
/// Exploite le temps réel et le cache hors-ligne natif de Firestore.
class FirestoreTripRepository {
  FirestoreTripRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference get _tripsRef => _firestore.collection('trips');
  CollectionReference get _bookingsRef => _firestore.collection('bookings');

  /// Recherche des trajets disponibles selon la ville de départ et d'arrivée
  Stream<List<FirestoreTrip>> watchTrips({
    required String departureCity,
    required String destinationCity,
  }) {
    return _tripsRef
        .where('departureCity', isEqualTo: departureCity)
        .where('destinationCity', isEqualTo: destinationCity)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FirestoreTrip.fromDocument(doc))
          .toList();
    });
  }

  /// Récupérer les trajets populaires du moment
  Future<List<FirestoreTrip>> getPopularTrips({int limit = 6}) async {
    final query = await _tripsRef.limit(limit).get();
    return query.docs.map((doc) => FirestoreTrip.fromDocument(doc)).toList();
  }

  /// Créer une réservation sécurisée avec mise à jour des places restantes
  Future<String> createBooking({
    required String userId,
    required String tripId,
    required int seatCount,
    required int totalPrice,
    required String passengerName,
    required String passengerPhone,
  }) async {
    return _firestore.runTransaction((transaction) async {
      final tripDocRef = _tripsRef.doc(tripId);
      final tripSnapshot = await transaction.get(tripDocRef);

      if (!tripSnapshot.exists) {
        throw Exception('Ce trajet n\'existe plus.');
      }

      final tripData = tripSnapshot.data() as Map<String, dynamic>;
      final currentAvailable = (tripData['availableSeats'] as num?)?.toInt() ?? 0;

      if (currentAvailable < seatCount) {
        throw Exception('Désolé, il ne reste que $currentAvailable place(s) disponible(s).');
      }

      // 1. Décrémenter les places disponibles
      transaction.update(tripDocRef, {
        'availableSeats': currentAvailable - seatCount,
      });

      // 2. Créer la réservation
      final newBookingRef = _bookingsRef.doc();
      transaction.set(newBookingRef, {
        'bookingId': newBookingRef.id,
        'userId': userId,
        'tripId': tripId,
        'seatCount': seatCount,
        'totalPrice': totalPrice,
        'passengerName': passengerName,
        'passengerPhone': passengerPhone,
        'status': 'CONFIRMED', // 'PENDING_PAYMENT', 'CONFIRMED', 'CANCELLED'
        'createdAt': FieldValue.serverTimestamp(),
      });

      return newBookingRef.id;
    });
  }

  /// Écouter en temps réel les réservations d'un utilisateur (disponibles hors ligne)
  Stream<List<Map<String, dynamic>>> watchUserBookings(String userId) {
    return _bookingsRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    });
  }
}
