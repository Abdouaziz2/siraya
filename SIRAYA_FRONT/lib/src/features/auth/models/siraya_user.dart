class SirayaUser {
  const SirayaUser({
    this.id,
    this.firstName,
    this.lastName,
    required this.phoneNumber,
    required this.phoneVerified,
  });

  final int? id;
  final String? firstName;
  final String? lastName;
  final String phoneNumber;
  final bool phoneVerified;

  factory SirayaUser.fromJson(Map<String, dynamic> json) {
    return SirayaUser(
      id: json['id'] is int ? json['id'] as int : null,
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      phoneVerified: json['phoneVerified'] == true,
    );
  }

  String get displayName {
    final fullName = [firstName, lastName]
        .where((value) => value != null && value.trim().isNotEmpty)
        .join(' ');
    return fullName.isEmpty ? phoneNumber : fullName;
  }
}
