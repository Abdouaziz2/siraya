/// Extensions utilitaires sur [String].
extension StringExtensions on String {
  /// Met la première lettre en majuscule.
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Vérifie si la chaîne est un numéro de téléphone valide (format Afrique de l'Ouest).
  bool get isValidPhone => RegExp(r'^\+?[0-9]{8,15}$').hasMatch(trim());

  /// Vérifie si la chaîne est un email valide.
  bool get isValidEmail =>
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(trim());

  /// Retourne null si la chaîne est vide, sinon la chaîne elle-même.
  String? get nullIfEmpty => trim().isEmpty ? null : this;
}

