import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/constants/app_constants.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/presentation/pages/auth/phone_page.dart';
import 'package:nioudem/presentation/widgets/siraya_buttons.dart';

/// Modèle pour les étapes d'onboarding.
class OnboardingStep {
  const OnboardingStep({
    required this.title,
    required this.description,
    required this.imageAsset,
  });

  final String title;
  final String description;
  final String imageAsset;
}

/// Écran Onboarding SIRAYA (Node Figma 32:10246).
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingStep> _steps = const [
    OnboardingStep(
      title: 'Trouvez les meilleurs\ndéparts facilement',
      description: 'Comparez plusieurs compagnies\net réservez en quelques étapes.',
      imageAsset: AppConstants.passengerAsset,
    ),
    OnboardingStep(
      title: 'Voyagez en toute\nsérénité et sécurité',
      description: 'Consultez les avis, les horaires en temps réel\net choisissez votre place.',
      imageAsset: AppConstants.busAsset,
    ),
    OnboardingStep(
      title: 'Billet digitalisé\net paiement mobile',
      description: 'Payez via Wave ou Orange Money\net embarquez avec votre QR Code.',
      imageAsset: AppConstants.passengerAsset,
    ),
  ];

  void _onSkip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PhonePage()),
    );
  }

  void _onNext() {
    if (_currentIndex < _steps.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOut,
      );
    } else {
      _onSkip();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SirayaColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar (Bouton Passer) ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SirayaSpacing.lg,
                vertical: SirayaSpacing.xs,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: SirayaColors.textMuted,
                      padding: const EdgeInsets.symmetric(
                        horizontal: SirayaSpacing.sm,
                        vertical: SirayaSpacing.xs,
                      ),
                    ),
                    child: Text(
                      'Passer',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SirayaColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Carrousel d'étapes ───────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SirayaSpacing.xl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Image.asset(
                              step.imageAsset,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.directions_bus_rounded,
                                size: 100,
                                color: SirayaColors.green,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: SirayaSpacing.xl),

                        // Titre
                        Text(
                          step.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            height: 1.25,
                            color: SirayaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: SirayaSpacing.md),

                        // Description
                        Text(
                          step.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                            color: SirayaColors.textSecondary,
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Pagination Dots & Bouton Suivant ─────────────────────
            Padding(
              padding: const EdgeInsets.all(SirayaSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicateurs de pagination
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_steps.length, (index) {
                      final isActive = index == _currentIndex;
                      return AnimatedContainer(
                        duration: AppConstants.animationFast,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? SirayaColors.orange
                              : SirayaColors.border,
                          borderRadius: BorderRadius.circular(
                            SirayaSpacing.radiusFull,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: SirayaSpacing.xl),

                  // Bouton Suivant
                  SirayaPrimaryButton(
                    label: _currentIndex == _steps.length - 1
                        ? 'Commencer'
                        : 'Suivant',
                    onPressed: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
