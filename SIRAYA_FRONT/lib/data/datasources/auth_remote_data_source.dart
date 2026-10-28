import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nioudem/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  });

  Future<UserModel?> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<UserModel?> signInWithGoogle();

  Future<void> signOut();

  UserModel? get currentUser;

  Stream<UserModel?> get authStateChanges;
}

class FirebaseAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    if (!kIsWeb) {
      GoogleSignIn.instance.initialize();
    }
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Stream<UserModel?> get authStateChanges => _auth.authStateChanges().map(
        (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
      );

  @override
  UserModel? get currentUser {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInWithCredentialAndSync(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Échec de vérification du numéro');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  @override
  Future<UserModel?> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _signInWithCredentialAndSync(credential);
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return _signInWithCredentialAndSync(credential);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      GoogleSignIn.instance.signOut(),
    ]);
  }

  Future<UserModel?> _signInWithCredentialAndSync(AuthCredential credential) async {
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) return null;

    final model = UserModel.fromFirebaseUser(user);
    await _syncUserToFirestore(model);
    return model;
  }

  Future<void> _syncUserToFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'phone': user.phone,
          'displayName': user.displayName,
          'email': user.email,
          'photoUrl': user.photoUrl,
          'lastSeen': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (_) {}
  }
}
