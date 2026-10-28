import 'package:firebase_auth/firebase_auth.dart';
import 'package:nioudem/domain/entities/user_entity.dart';

/// Modèle User avec sérialisation/désérialisation (Data Layer).
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.phone,
    super.displayName,
    super.email,
    super.photoUrl,
    super.isVerified,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      phone: user.phoneNumber ?? '',
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      isVerified: user.emailVerified || (user.phoneNumber != null && user.phoneNumber!.isNotEmpty),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      phone: map['phone'] as String? ?? '',
      displayName: map['displayName'] as String?,
      email: map['email'] as String?,
      photoUrl: map['photoUrl'] as String?,
      isVerified: map['isVerified'] as bool? ?? false,
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
