import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/features/auth/presentation/screens/login_pin_screen.dart';
import 'package:nioudem/src/features/auth/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = size.width < 380 ? 20.0 : 26.0;
    final logoWidth = size.width < 380 ? 220.0 : 258.0;
    const buttonHeight = 50.0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_bus.png',
            fit: BoxFit.cover,
          ),
          const _BottomShade(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 700;
                final responsiveLogoWidth = compact ? 168.0 : logoWidth;
                final topSpacing = compact ? 14.0 : constraints.maxHeight * 0.15;
                final middleSpacing = compact ? 28.0 : constraints.maxHeight * 0.26;
                final responsiveButtonWidth = (constraints.maxWidth * 0.72).clamp(230.0, 270.0);

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, 22, horizontalPadding, 28),
                      child: Column(
                        children: [
                          SizedBox(height: topSpacing),
                          Image.asset(
                            'assets/images/siraya_logo_transparent.png',
                            width: responsiveLogoWidth,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/siraya_logo.png',
                                width: responsiveLogoWidth,
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                          SizedBox(height: middleSpacing),
                          const _PageDots(),
                          const SizedBox(height: 28),
                          _StartButton(
                            label: 'Commencer',
                            filled: true,
                            width: responsiveButtonWidth,
                            height: buttonHeight,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _StartButton(
                            label: 'Se connecter',
                            filled: false,
                            width: responsiveButtonWidth,
                            height: buttonHeight,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (_) => const LoginPinScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomShade extends StatelessWidget {
  const _BottomShade();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Color(0xAA00180E),
            Color(0xE600180E),
          ],
          stops: [0, 0.48, 0.76, 1],
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Dot(color: SirayaColors.orange),
        const SizedBox(width: 12),
        _Dot(color: Colors.white.withValues(alpha: 0.55)),
        const SizedBox(width: 12),
        _Dot(color: Colors.white.withValues(alpha: 0.55)),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({
    required this.label,
    required this.filled,
    required this.height,
    this.width,
    required this.onPressed,
  });

  final String label;
  final bool filled;
  final double height;
  final double? width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: filled
          ? FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: SirayaColors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            )
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: onPressed,
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
    );
  }
}
