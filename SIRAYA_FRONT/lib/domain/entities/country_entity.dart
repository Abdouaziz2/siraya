/// Entité représentant un pays supporté par SIRAYA.
class CountryEntity {
  const CountryEntity({
    required this.name,
    required this.isoCode,
    required this.dialCode,
    required this.flagEmoji,
    required this.exampleNumber,
    this.minLength = 8,
    this.maxLength = 10,
  });

  final String name;
  final String isoCode;
  final String dialCode;
  final String flagEmoji;
  final String exampleNumber;
  final int minLength;
  final int maxLength;

  String get displayName => '$name ($dialCode)';
}

