import 'package:nioudem/domain/entities/user_entity.dart';
import 'package:nioudem/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);
  final AuthRepository _repository;

  Future<UserEntity?> call({
    required String verificationId,
    required String smsCode,
  }) {
    return _repository.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
