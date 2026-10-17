import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

/// Service d'Authentification Firebase pour SIRAYA.
/// Implémente : Téléphone (SMS OTP), Email/Mot de passe, et Connexion Google.
/// Conforme aux recommandations officielles Firebase Flutter (support Mobile & Web).
class FirebaseAuthService {
  FirebaseAuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    // Initialisation conditionnelle pour éviter le blocage DWDS sur Web
    if (!kIsWeb) {
      GoogleSignIn.instance.initialize();
    }
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Écoute en temps réel des changements d'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Utilisateur actuellement connecté
  User? get currentUser => _auth.currentUser;

  // ==========================================
  // 1. AUTHENTIFICATION PAR TÉLÉPHONE (SMS OTP)
  // ==========================================

  /// Envoie un code OTP par SMS au numéro fourni.
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential) onVerificationCompleted,
    required void Function(FirebaseAuthException e) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
    int? resendToken,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInWithCredentialAndSync(credential);
        onVerificationCompleted(credential);
      },
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
      forceResendingToken: resendToken,
      timeout: timeout,
    );
  }

  /// Valide le code SMS saisi par l'utilisateur.
  Future<UserCredential> verifySmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _signInWithCredentialAndSync(credential);
  }

  // ==========================================
  // 2. AUTHENTIFICATION EMAIL / MOT DE PASSE
  // ==========================================

  /// Inscription avec Email et Mot de passe
  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (displayName != null && displayName.isNotEmpty) {
      await credential.user?.updateDisplayName(displayName);
    }

    await _syncUserProfile(
      credential.user,
      extraData: phoneNumber != null ? {'phoneNumber': phoneNumber} : null,
    );

    return credential;
  }

  /// Connexion avec Email et Mot de passe
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _syncUserProfile(credential.user);
    return credential;
  }

  /// Réinitialisation du mot de passe par email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ==========================================
  // 3. CONNEXION GOOGLE (Google Sign-In)
  // ==========================================

  /// Connexion avec Google compatible Mobile et Web
  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // Sur le Web : utilisation du popup Firebase pour éviter les soucis de client ID
      final GoogleAuthProvider authProvider = GoogleAuthProvider();
      final credential = await _auth.signInWithPopup(authProvider);
      await _syncUserProfile(credential.user);
      return credential;
    } else {
      // Sur Mobile : utilisation du flux standard GoogleSignIn
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _syncUserProfile(userCredential.user);
      return userCredential;
    }
  }

  // ==========================================
  // 4. DÉCONNEXION & PROFIL FIRESTORE
  // ==========================================

  /// Déconnexion sécurisée (Mobile et Web)
  Future<void> signOut() async {
    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }
    await _auth.signOut();
  }

  /// Connexion interne et synchronisation
  Future<UserCredential> _signInWithCredentialAndSync(
    AuthCredential credential,
  ) async {
    final userCredential = await _auth.signInWithCredential(credential);
    await _syncUserProfile(userCredential.user);
    return userCredential;
  }

  /// Synchronise les informations de l'utilisateur dans la collection `users/{uid}` sur Firestore
  Future<void> _syncUserProfile(
    User? user, {
    Map<String, dynamic>? extraData,
  }) async {
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final data = <String, dynamic>{
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'phoneNumber': user.phoneNumber,
      'photoURL': user.photoURL,
      'lastLoginAt': FieldValue.serverTimestamp(),
      if (extraData != null) ...extraData,
    };

    await userDoc.set(
      data,
      SetOptions(merge: true),
    );
  }
}
