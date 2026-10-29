import 'package:nioudem/domain/entities/user_entity.dart';

/// Contrat du repository d'authentification dans la couche Domain.
abstract class AuthRepository {
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  });

  Future<UserEntity?> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<UserEntity?> signInWithGoogle();

  Future<void> signOut();

  UserEntity? get currentUser;

  Stream<UserEntity?> get authStateChanges;
}

