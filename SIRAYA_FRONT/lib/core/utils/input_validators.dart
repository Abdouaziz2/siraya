/// Validateurs de formulaires réutilisables.
abstract class InputValidators {
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre numéro de téléphone';
    }
    final clean = value.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(clean)) {
      return 'Format de téléphone invalide';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir le code reçu';
    }
    if (value.trim().length != 6) {
      return 'Le code doit contenir 6 chiffres';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Le champ $fieldName est requis';
    }
    return null;
  }
}
