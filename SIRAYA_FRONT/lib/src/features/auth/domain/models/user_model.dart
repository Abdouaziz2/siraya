/// Modèle utilisateur SIRAYA.
class UserModel {
  const UserModel({
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

  UserModel copyWith({
    String? uid,
    String? phone,
    String? displayName,
    String? email,
    String? photoUrl,
    bool? isVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'phone': phone,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'isVerified': isVerified,
      };
}

