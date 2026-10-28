import 'package:flutter/material.dart';
import 'package:nioudem/core/theme/siraya_theme.dart';
import 'package:nioudem/presentation/pages/splash/splash_page.dart';

/// Point d'entrée de la couche Présentation SIRAYA.
class SirayaApp extends StatelessWidget {
  const SirayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIRAYA',
      debugShowCheckedModeBanner: false,
      theme: SirayaTheme.light(),
      home: const SplashPage(),
    );
  }
}
