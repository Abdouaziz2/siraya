import 'package:nioudem/data/datasources/auth_remote_data_source.dart';
import 'package:nioudem/domain/entities/user_entity.dart';
import 'package:nioudem/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<UserEntity?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  UserEntity? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) {
    return _remoteDataSource.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
  }

  @override
  Future<UserEntity?> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) {
    return _remoteDataSource.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  @override
  Future<UserEntity?> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }
}

