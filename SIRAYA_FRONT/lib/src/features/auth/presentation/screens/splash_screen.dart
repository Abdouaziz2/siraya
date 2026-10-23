import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/shared/widgets/siraya_logo.dart';

/// Écran 1 — Splash Screen SIRAYA
///
/// Spec Figma (node 102:2) :
///   - Fond : #003C28 (vert forêt profond)
///   - Logo "Sira" (blanc) + "ya" (orange) centré en haut
///   - Slogan "Voyagez simplement." en blanc + orange
///   - Indicateur de chargement mint (#A4D5AA)
///   - Label "Chargement..." sous le spinner
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SirayaColors.splashGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ── Logo ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: SirayaSpacing.xxl),
                child: const SirayaLogo(size: 48, dark: true),
              ),

              // ── Slogan ──────────────────────────────────────────────────
              _SplashSlogan(),

              // ── Loader ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: SirayaSpacing.xxl),
                child: const _SplashLoader(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Slogan Widget ────────────────────────────────────────────────────────────

class _SplashSlogan extends StatelessWidget {
  const _SplashSlogan();

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.plusJakartaSans(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      height: 1.1,
      letterSpacing: -0.5,
    );

    return Semantics(
      label: 'Voyagez simplement.',
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Voyagez\n',
              style: style.copyWith(color: Colors.white),
            ),
            TextSpan(
              text: 'simplement.',
              style: style.copyWith(color: SirayaColors.orange),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loader Widget ────────────────────────────────────────────────────────────

class _SplashLoader extends StatelessWidget {
  const _SplashLoader();

  // Couleur mint de la maquette Figma
  static const Color _mint = Color(0xFFA4D5AA);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(_mint),
          ),
        ),
        const SizedBox(height: SirayaSpacing.sm),
        Text(
          'Chargement...',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _mint,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
