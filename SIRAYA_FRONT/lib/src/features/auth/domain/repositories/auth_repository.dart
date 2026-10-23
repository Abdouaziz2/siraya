import 'package:nioudem/src/features/auth/domain/models/user_model.dart';

/// Contrat abstrait pour l'authentification.
/// Implémenté par [FirebaseAuthService] — permet de changer de backend sans
/// modifier la couche présentation.
abstract class AuthRepository {
  /// Connexion par numéro de téléphone (étape 1 : envoi OTP).
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  });

  /// Vérification du code OTP (étape 2).
  Future<UserModel?> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  /// Connexion Google.
  Future<UserModel?> signInWithGoogle();

  /// Déconnexion.
  Future<void> signOut();

  /// Utilisateur courant (null si non connecté).
  UserModel? get currentUser;

  /// Stream d'état d'authentification.
  Stream<UserModel?> get authStateChanges;
}

