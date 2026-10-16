import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
// TODO : remplacer par l'écran Téléphone (numéro + OTP) quand il existera
import 'package:nioudem/src/features/auth/presentation/screens/login_pin_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _bg = Color(0xFF0A291C);
  static const _onOrange = Color(0xFF1A1005);
  static const _total = 3;

  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _total - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _goToPhone();
    }
  }

  void _goToPhone() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginPinScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.sizeOf(context).width < 380 ? 20.0 : 24.0;
    final last = _page == _total - 1;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(pad, 8, pad - 8, 0),
                child: TextButton(
                  onPressed: _goToPhone,
                  style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                  child: const Text(
                    'Passer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _OnboardingPage(
                    padding: pad,
                    before: 'Trouvez les meilleurs ',
                    highlight: 'départs facilement',
                    subtitle:
                        'Comparez plusieurs compagnies et réservez en quelques étapes.',
                    visual: const _CutoutImage('assets/images/onboarding_1.png'),
                  ),
                  _OnboardingPage(
                    padding: pad,
                    before: 'Comparez prix, horaires ',
                    highlight: 'et confort',
                    subtitle:
                        'Choisissez le programme qui vous convient le mieux.',
                    visual: const _TripCards(),
                  ),
                  _OnboardingPage(
                    padding: pad,
                    before: 'Réservez et voyagez ',
                    highlight: 'en toute tranquillité',
                    subtitle:
                        'Votre billet est toujours disponible dans l\'application.',
                    visual: const _CutoutImage('assets/images/onboarding_3.png'),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_total, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? SirayaColors.orange
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 20, pad, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: SirayaColors.orange,
                    foregroundColor: _onOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _next,
                  child: Text(
                    last ? 'Commencer' : 'Suivant',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.padding,
    required this.before,
    required this.highlight,
    required this.subtitle,
    required this.visual,
  });

  final double padding;
  final String before;
  final String highlight;
  final String subtitle;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(text: before),
                    TextSpan(
                      text: highlight,
                      style: const TextStyle(color: SirayaColors.orange),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFC9D8CE),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        // Visuel : posé directement sur le fond, sans carte ni bordure
        Expanded(child: visual),
      ],
    );
  }
}

/// Image détourée, ancrée en bas, taille adaptée à l'espace disponible.
class _CutoutImage extends StatelessWidget {
  const _CutoutImage(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        asset,
        width: double.infinity,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      ),
    );
  }
}

/// Page 2 : pas d'image, de vraies cartes (données mock à brancher plus tard).
class _TripCards extends StatelessWidget {
  const _TripCards();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MiniTrip('SENECAR', '08:00 · Royal Class', '65 000 FCFA'),
            SizedBox(height: 12),
            _MiniTrip('ORABUS', '07:30 · Confort+', '60 000 FCFA'),
            SizedBox(height: 12),
            _MiniTrip('MALI BUS', '06:00 · Standard', '45 000 FCFA'),
          ],
        ),
      ),
    );
  }
}

class _MiniTrip extends StatelessWidget {
  const _MiniTrip(this.company, this.detail, this.price);

  final String company;
  final String detail;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0E3B28),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF121A16),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF485950),
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Color(0xFF0E3B28),
            ),
          ),
        ],
      ),
    );
  }
}