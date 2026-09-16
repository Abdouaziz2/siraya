class InputValidators {
  static String? phone(String? value) {
    final phone = value?.replaceAll(' ', '').trim() ?? '';
    if (phone.isEmpty) return 'Le numéro est obligatoire';
    final valid = RegExp(r'^\+?[1-9]\d{7,14}$').hasMatch(phone);
    if (!valid) return 'Format de numéro invalide';
    return null;
  }

  static String? pin(String? value) {
    final pin = value ?? '';
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      return 'Le PIN doit contenir 4 chiffres';
    }
    return null;
  }
}
