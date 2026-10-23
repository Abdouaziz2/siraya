import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_theme.dart';
import 'package:nioudem/src/features/splash/presentation/screens/splash_screen.dart';

/// Point d'entrée de l'application SIRAYA.
/// Configure le thème global et la route initiale.
class SirayaApp extends StatelessWidget {
  const SirayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIRAYA',
      debugShowCheckedModeBanner: false,
      theme: SirayaTheme.light(),
      home: const SplashScreen(),
    );
  }
}
