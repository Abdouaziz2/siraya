import 'package:nioudem/domain/entities/user_entity.dart';
import 'package:nioudem/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase(this._repository);
  final AuthRepository _repository;

  Future<UserEntity?> call() {
    return _repository.signInWithGoogle();
  }
}
