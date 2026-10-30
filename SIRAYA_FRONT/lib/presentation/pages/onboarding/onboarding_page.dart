import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/constants/app_constants.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/presentation/pages/auth/phone_page.dart';

/// Données pour chaque étape d'onboarding.
class OnboardingStepData {
  const OnboardingStepData({
    required this.titleWhite,
    required this.titleOrange,
    required this.description,
  });

  final String titleWhite;
  final String titleOrange;
  final String description;
}

/// Écran d'Onboarding SIRAYA fidèle aux maquettes Figma (3 étapes).
///
/// Fond : #003C28 (vert forêt profond).
/// Typographie : Plus Jakarta Sans (bicolore blanc + orange).
/// Bouton Passer : Pilule sombre en haut à droite.
/// Étape 1 : Bus réaliste.
/// Étape 2 : Cartes de comparaison (SENECAR, ORABUS, MALI BUS).
/// Étape 3 : Voyageur avec billet digital QR code.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<OnboardingStepData> _steps = [
    OnboardingStepData(
      titleWhite: 'Trouvez les meilleurs\n',
      titleOrange: 'départs facilement',
      description: 'Comparez plusieurs compagnies\net réservez en quelques étapes.',
    ),
    OnboardingStepData(
      titleWhite: 'Comparez prix, horaires\n',
      titleOrange: 'et confort',
      description: 'Choisissez le programme qui\nvous convient le mieux.',
    ),
    OnboardingStepData(
      titleWhite: 'Réservez et voyagez\n',
      titleOrange: 'en toute tranquillité',
      description: 'Votre billet est toujours disponible\ndans l\'application.',
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
    final step = _steps[_currentIndex];

    return Scaffold(
      backgroundColor: SirayaColors.splashGreen,
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
                  InkWell(
                    onTap: _onSkip,
                    borderRadius: BorderRadius.circular(SirayaSpacing.radiusFull),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A3323),
                        borderRadius: BorderRadius.circular(SirayaSpacing.radiusFull),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 0.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Passer',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Titres & Descriptions bicolores ──────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SirayaSpacing.xl,
                vertical: SirayaSpacing.sm,
              ),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: step.titleWhite,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            height: 1.25,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: step.titleOrange,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            height: 1.25,
                            color: SirayaColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SirayaSpacing.xs + 2),
                  Text(
                    step.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),

            // ── Zone Carrousel / Contenu Visuel ──────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: [
                  // Étape 1 : Bus Siraya
                  _buildStep1Bus(),

                  // Étape 2 : Cartes de comparaison
                  _buildStep2ComparisonCards(),

                  // Étape 3 : Passager & billet QR Code
                  _buildStep3PassengerTicket(),
                ],
              ),
            ),

            // ── Stepper (Dots) & Bouton d'action ─────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SirayaSpacing.xl,
                vertical: SirayaSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicateurs de pagination (Dots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_steps.length, (index) {
                      final isActive = index == _currentIndex;
                      return AnimatedContainer(
                        duration: AppConstants.animationFast,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? SirayaColors.orange
                              : Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(
                            SirayaSpacing.radiusFull,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: SirayaSpacing.lg),

                  // Bouton Suivant / Commencer (Orange identitaire)
                  SizedBox(
                    width: double.infinity,
                    height: SirayaSpacing.buttonHeight,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: SirayaColors.orange,
                        foregroundColor: const Color(0xFF141F1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SirayaSpacing.radiusMd),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _onNext,
                      child: Text(
                        _currentIndex == _steps.length - 1
                            ? 'Commencer'
                            : 'Suivant',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Étape 1 : Bus Siraya ──────────────────────────────────────────
  Widget _buildStep1Bus() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.lg),
        child: Image.asset(
          AppConstants.busAsset,
          fit: BoxFit.contain,
          semanticLabel: 'Bus SIRAYA',
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.directions_bus_rounded,
            size: 110,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  // ── Étape 2 : Cartes de Comparaison ──────────────────────────────
  Widget _buildStep2ComparisonCards() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTripCard(
              companyName: 'SENECAR',
              departureTime: '06:00',
              price: '65 000 FCFA',
              comfortClass: 'Royal Class',
              badgeColor: const Color(0xFF1B4332),
              logoAsset: 'assets/images/logo_senecar.png',
            ),
            const SizedBox(height: SirayaSpacing.sm),
            _buildTripCard(
              companyName: 'ORABUS',
              departureTime: '06:00',
              price: '',
              comfortClass: 'Confort+',
              badgeColor: const Color(0xFFE85D04),
              logoAsset: 'assets/images/logo_orabus.png',
            ),
            const SizedBox(height: SirayaSpacing.sm),
            _buildTripCard(
              companyName: 'MALI BUS',
              departureTime: '06:00',
              price: '70 000 FCFA',
              comfortClass: 'Royal Class',
              badgeColor: const Color(0xFF2D6A4F),
              logoAsset: 'assets/images/logo_malibus.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard({
    required String companyName,
    required String departureTime,
    required String price,
    required String comfortClass,
    required Color badgeColor,
    String? logoAsset,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SirayaSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SirayaSpacing.md,
        vertical: SirayaSpacing.sm + 2,
      ),
      child: Row(
        children: [
          // Logo compagnie / Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badgeColor.withValues(alpha: 0.15),
              border: Border.all(color: badgeColor, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: logoAsset != null
                ? Image.asset(
                    logoAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.directions_bus_filled_rounded,
                        size: 22,
                        color: badgeColor,
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.directions_bus_filled_rounded,
                      size: 22,
                      color: badgeColor,
                    ),
                  ),
          ),
          const SizedBox(width: SirayaSpacing.md),

          // Heure et Compagnie
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  departureTime,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SirayaColors.textMuted,
                  ),
                ),
                Text(
                  companyName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: SirayaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.air_rounded,
                      size: 13,
                      color: SirayaColors.textMuted.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.wifi_rounded,
                      size: 13,
                      color: SirayaColors.textMuted.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Prix et Confort
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (price.isNotEmpty)
                Text(
                  price,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: SirayaColors.textPrimary,
                  ),
                ),
              const SizedBox(height: 2),
              Text(
                comfortClass,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: SirayaColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Étape 3 : Passager & Billet QR Code ───────────────────────────
  Widget _buildStep3PassengerTicket() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.lg),
        child: Image.asset(
          AppConstants.passengerAsset,
          fit: BoxFit.contain,
          semanticLabel: 'Billet digitalisé et voyageur',
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.qr_code_2_rounded,
            size: 110,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
