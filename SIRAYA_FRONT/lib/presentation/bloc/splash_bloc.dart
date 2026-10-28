import 'package:flutter/foundation.dart';

/// États pour le Splash Screen.
sealed class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashCompleted extends SplashState {
  const SplashCompleted({this.isAuthenticated = false});
  final bool isAuthenticated;
}

/// Contrôleur BLoC / StateNotifier pour la logique de démarrage du Splash Screen.
class SplashController extends ValueNotifier<SplashState> {
  SplashController() : super(const SplashInitial());

  Future<void> initializeApp() async {
    value = const SplashLoading();
    // Simulation / Vérification de session
    await Future.delayed(const Duration(seconds: 3));
    value = const SplashCompleted(isAuthenticated: false);
  }
}
