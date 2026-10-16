import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/src/features/auth/presentation/screens/onboarding_screen.dart';

/// Écran Splash SIRAYA conforme à la maquette Figma (Node 102:2).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Teintes exactes extraites de la maquette Figma
  static const Color _backgroundColor = Color(0xFF003C28); // Fond vert forêt #003C28
  static const Color _orangeAccent = Color(0xFFFF7900);     // Orange du slogan
  static const Color _spinnerColor = Color(0xFFA4D5AA);     // Vert menthe doux

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2000), _navigate);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _hasActiveSession() {
    // TODO : brancher Firebase Auth (FirebaseAuth.instance.currentUser != null)
    return false;
  }

  void _navigate() {
    if (!mounted) return;
    final Widget next = _hasActiveSession()
        ? const OnboardingScreen() // TODO : remplacer par l'écran d'accueil
        : const OnboardingScreen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: constraints.maxHeight * 0.08),

                // 1. Logo SIRAYA (Blanc & Orange)
                Image.asset(
                  'assets/images/siraya_logo_white_crisp.png',
                  width: (constraints.maxWidth * 0.52).clamp(180.0, 240.0),
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Image.asset(
                    'assets/images/siraya_logo.png',
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: constraints.maxHeight * 0.04),

                // 2. Slogan "Voyagez simplement."
                Text(
                  'Voyagez',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                Text(
                  'simplement.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: _orangeAccent,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),

                const Spacer(),

                // 3. Car de voyage réaliste
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(
                    'assets/images/splash_bus_realistic.png',
                    width: constraints.maxWidth * 0.94,
                    fit: BoxFit.contain,
                  ),
                ),

                const Spacer(),

                // 4. Spinner de chargement
                const SizedBox(
                  width: 38,
                  height: 38,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.2,
                    valueColor: AlwaysStoppedAnimation<Color>(_spinnerColor),
                  ),
                ),

                const SizedBox(height: 14),

                // 5. Texte "Chargement..."
                Text(
                  'Chargement...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 0.2,
                  ),
                ),

                SizedBox(height: constraints.maxHeight * 0.04),
              ],
            );
          },
        ),
      ),
    );
  }
}