/// Entité métier pure représentant un utilisateur SIRAYA.
class UserEntity {
  const UserEntity({
    required this.uid,
    required this.phone,
    this.displayName,
    this.email,
    this.photoUrl,
    this.isVerified = false,
  });

  final String uid;
  final String phone;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final bool isVerified;
}
