/// Entité représentant une ville de départ ou d'arrivée.
class CityEntity {
  const CityEntity({
    required this.name,
    required this.country,
    required this.countryCode,
    required this.flagEmoji,
    this.isPopular = false,
    this.isRecent = false,
  });

  final String name;
  final String country;
  final String countryCode;
  final String flagEmoji;
  final bool isPopular;
  final bool isRecent;

  String get fullLabel => '$name, $country';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          countryCode == other.countryCode;

  @override
  int get hashCode => name.hashCode ^ countryCode.hashCode;
}
