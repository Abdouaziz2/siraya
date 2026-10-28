/// Classes de base pour la gestion d'erreurs en Clean Architecture.
abstract class Failure {
  const Failure(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Aucune connexion internet', String? code])
      : super(code: code);
}
