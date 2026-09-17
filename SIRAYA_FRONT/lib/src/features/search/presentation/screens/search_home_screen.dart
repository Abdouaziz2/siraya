import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/core/theme/siraya_typography.dart';
import 'package:nioudem/src/features/auth/presentation/screens/auth_choice_screen.dart';
import 'package:nioudem/src/features/search/domain/models/search_query.dart';
import 'package:nioudem/src/features/search/presentation/widgets/popular_corridors_view.dart';
import 'package:nioudem/src/features/search/presentation/widgets/route_selector_card.dart';
import 'package:nioudem/src/shared/widgets/siraya_badge.dart';
import 'package:nioudem/src/shared/widgets/siraya_logo.dart';

/// Écran principal d'accueil et de recherche de voyages SIRAYA.
/// Accessible directement sans authentification préalable obligatoire.
class SearchHomeScreen extends StatefulWidget {
  const SearchHomeScreen({super.key});

  @override
  State<SearchHomeScreen> createState() => _SearchHomeScreenState();
}

class _SearchHomeScreenState extends State<SearchHomeScreen> {
  final GlobalKey<RouteSelectorCardState> _cardKey = GlobalKey<RouteSelectorCardState>();
  SearchQuery _query = SearchQuery(departureDate: DateTime.now());

  void _onCorridorSelected(String departure, String destination) {
    _cardKey.currentState?.updateCities(departure, destination);
  }

  void _handleSearch(SearchQuery query) {
    setState(() => _query = query);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: SirayaColors.green,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: SirayaSpacing.sm),
            Expanded(
              child: Text(
                'Recherche : ${query.departureCity} ➔ ${query.destinationCity} (${query.passengerCount} place${query.passengerCount > 1 ? 's' : ''})',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 380 ? 14.0 : 18.0;

    return Scaffold(
      backgroundColor: SirayaColors.background,
      body: CustomScrollView(
        slivers: [
          // En-tête Sliver avec hero_baniere.png
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Image Hero Bannière
                Container(
                  height: 265,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: SirayaColors.darkGreen,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(SirayaSpacing.radiusLg),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(SirayaSpacing.radiusLg),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/hero_baniere.png',
                          alignment: const Alignment(0, -0.25),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) {
                            return Image.asset(
                              'assets/images/bus_hero.png',
                              alignment: const Alignment(0, -0.25),
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const SizedBox.shrink(),
                            );
                          },
                        ),
                        // Filtre assombrissant vert pour lisibilité du logo et du slogan
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                SirayaColors.darkGreen.withValues(alpha: 0.82),
                                SirayaColors.darkGreen.withValues(alpha: 0.45),
                                SirayaColors.green.withValues(alpha: 0.90),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Contenu par-dessus la bannière
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 10, horizontalPadding, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Barre supérieure : Logo + Bouton Connexion/Profil
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                SirayaLogo(size: 38),
                                SizedBox(width: SirayaSpacing.xs),
                                Text(
                                  'SIRAYA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.15),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(SirayaSpacing.radiusFull),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SirayaSpacing.sm,
                                  vertical: 6,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const AuthChoiceScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.person_outline_rounded, size: 18),
                              label: const Text('Compte', style: TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
                        const SizedBox(height: SirayaSpacing.md),

                        // Slogan Officiel
                        const Text(
                          'Voyagez sans attendre.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Trouvez et réservez votre voyage en bus partout en Afrique de l\'Ouest.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Corps de page
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formulaire de recherche (posé élégamment sous l'en-tête)
                  Transform.translate(
                    offset: const Offset(0, -16),
                    child: RouteSelectorCard(
                      key: _cardKey,
                      initialQuery: _query,
                      onSearch: _handleSearch,
                    ),
                  ),

                  // Corridors Populaires (Dakar ↔ Bamako, Touba...)
                  PopularCorridorsView(onSelectCorridor: _onCorridorSelected),
                  const SizedBox(height: SirayaSpacing.lg),

                  // Bannières de Réassurance & Avantages SIRAYA
                  Text(
                    'Pourquoi choisir SIRAYA ?',
                    style: SirayaTypography.titleMedium,
                  ),
                  const SizedBox(height: SirayaSpacing.sm),

                  const _FeatureCard(
                    icon: Icons.qr_code_2_rounded,
                    iconColor: SirayaColors.green,
                    badgeText: 'Offline-First',
                    title: 'Billet numérique sécurisé',
                    description:
                        'Accédez à votre QR Code d\'embarquement à tout moment, même sans connexion internet.',
                  ),
                  const SizedBox(height: SirayaSpacing.sm),

                  const _FeatureCard(
                    icon: Icons.payments_rounded,
                    iconColor: SirayaColors.orange,
                    badgeText: '100% Local',
                    title: 'Paiement Mobile Money instantané',
                    description:
                        'Réglez votre place en toute sécurité via Wave, Orange Money, Moov ou Free Money.',
                  ),
                  const SizedBox(height: SirayaSpacing.sm),

                  const _FeatureCard(
                    icon: Icons.schedule_rounded,
                    iconColor: SirayaColors.info,
                    badgeText: 'Zéro File',
                    title: 'La gare = Lieu d\'embarquement',
                    description:
                        'Finis les déplacements inutiles en gare pour réserver. Venez directement le jour du départ.',
                  ),
                  const SizedBox(height: SirayaSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.badgeText,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String badgeText;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(SirayaSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: SirayaSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: SirayaTypography.titleMedium.copyWith(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SirayaBadge(label: badgeText, variant: SirayaBadgeVariant.neutral),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: SirayaTypography.bodySmall,
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
