import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/constants/app_constants.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/presentation/pages/onboarding/onboarding_page.dart';
import 'package:nioudem/presentation/widgets/siraya_logo.dart';

/// Écran 1 — Splash Screen SIRAYA (Clean Architecture Presentation Page).
///
/// Design Figma : fond #003C28, logo blanc+orange, slogan, bus centré, loader mint.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashDuration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: SirayaColors.splashGreen,
      body: SafeArea(
        child: Column(
          children: [
            // ── Logo ────────────────────────────────────────────────────
            const SizedBox(height: SirayaSpacing.xxxl),
            const SirayaLogo(size: 48, dark: true),

            // ── Slogan ──────────────────────────────────────────────────
            const SizedBox(height: SirayaSpacing.xl),
            const _SplashSlogan(),

            // ── Bus Image ───────────────────────────────────────────────
            const Spacer(),
            SizedBox(
              width: size.width * 0.88,
              child: Image.asset(
                AppConstants.busAsset,
                fit: BoxFit.contain,
                semanticLabel: 'Bus SIRAYA',
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: SirayaSpacing.md),

            // ── Loader ──────────────────────────────────────────────────
            const SizedBox(height: SirayaSpacing.lg),
            const _SplashLoader(),
            const SizedBox(height: SirayaSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ── Slogan ───────────────────────────────────────────────────────────────────

class _SplashSlogan extends StatelessWidget {
  const _SplashSlogan();

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.plusJakartaSans(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      height: 1.15,
      letterSpacing: -0.3,
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

// ── Loader ───────────────────────────────────────────────────────────────────

class _SplashLoader extends StatelessWidget {
  const _SplashLoader();

  static const Color _mint = Color(0xFFA4D5AA);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_mint),
          ),
        ),
        const SizedBox(height: SirayaSpacing.xs),
        Text(
          'Chargement...',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _mint,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

