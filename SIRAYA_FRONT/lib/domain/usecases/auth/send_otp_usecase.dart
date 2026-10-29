import 'package:nioudem/domain/repositories/auth_repository.dart';

class SendOtpUseCase {
  const SendOtpUseCase(this._repository);
  final AuthRepository _repository;

  Future<void> call({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) {
    return _repository.sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: onError,
    );
  }
}

