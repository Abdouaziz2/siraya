/// Constantes globales de l'application SIRAYA.
abstract class AppConstants {
  // Nom de l'application
  static const String appName = 'SIRAYA';

  // Durées
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Firestore collections
  static const String tripsCollection = 'trips';
  static const String usersCollection = 'users';
  static const String bookingsCollection = 'bookings';

  // Assets
  static const String busAsset = 'assets/images/bus_siraya.png';
  static const String logoAsset = 'assets/images/Siraya-logo.png';
  static const String passengerAsset = 'assets/images/passenger_siraya.png';
}

