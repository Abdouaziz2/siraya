/// Configuration des URLs et endpoints de l'API SIRAYA.
abstract class ApiConfig {
  static const String baseUrl = 'https://api.siraya.app/v1';
  static const Duration timeout = Duration(seconds: 15);
}

