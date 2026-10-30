import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/constants/app_constants.dart';
import 'package:nioudem/core/constants/siraya_cities.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/domain/entities/city_entity.dart';
import 'package:nioudem/presentation/pages/home/city_selection_page.dart';

/// Écran 9 de la maquette Figma : Accueil SIRAYA.
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.userName = 'Baye',
  });

  /// Nom de l'utilisateur pour la salutation personnalisée ("Bonjour, Baye 👋").
  final String userName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;

  // Villes sélectionnées par défaut (conformes à la maquette Figma)
  CityEntity _departureCity = SirayaCities.dakar;
  CityEntity _arrivalCity = SirayaCities.bamako;

  /// Inverse la ville de départ et la ville d'arrivée.
  void _swapCities() {
    setState(() {
      final temp = _departureCity;
      _departureCity = _arrivalCity;
      _arrivalCity = temp;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Trajet inversé : ${_departureCity.name} ➔ ${_arrivalCity.name}',
          style: GoogleFonts.plusJakartaSans(color: Colors.white),
        ),
        backgroundColor: SirayaColors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Ouvre la sélection de ville de départ.
  Future<void> _selectDepartureCity() async {
    final selected = await Navigator.of(context).push<CityEntity>(
      MaterialPageRoute(
        builder: (context) => CitySelectionPage(
          title: 'Ville de départ',
          initialCity: _departureCity,
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _departureCity = selected;
      });
    }
  }

  /// Ouvre la sélection de ville d'arrivée.
  Future<void> _selectArrivalCity() async {
    final selected = await Navigator.of(context).push<CityEntity>(
      MaterialPageRoute(
        builder: (context) => CitySelectionPage(
          title: "Ville d'arrivée",
          initialCity: _arrivalCity,
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _arrivalCity = selected;
      });
    }
  }

  /// Applique une destination populaire directement dans les champs de recherche.
  void _applyPopularRoute(PopularDestination route) {
    setState(() {
      _departureCity = route.departure;
      _arrivalCity = route.arrival;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Trajet sélectionné : ${route.label}',
          style: GoogleFonts.plusJakartaSans(color: Colors.white),
        ),
        backgroundColor: SirayaColors.darkGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSearchPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Recherche des départs de ${_departureCity.name} vers ${_arrivalCity.name}...',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: SirayaColors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SirayaColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header vert supérieur avec salutation et cloche
                    _buildHeader(),

                    // Formulaire de recherche flottant (Écran 9 Figma)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SirayaSpacing.md,
                      ),
                      child: _buildSearchCard(),
                    ),

                    const SizedBox(height: 24),

                    // Section : Destinations populaires
                    _buildPopularDestinationsSection(),

                    const SizedBox(height: 24),

                    // Section : Compagnies partenaires
                    _buildPartnerCompaniesSection(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Barre de navigation principale inférieure
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        SirayaSpacing.lg,
        MediaQuery.of(context).padding.top + 16,
        SirayaSpacing.lg,
        36,
      ),
      decoration: const BoxDecoration(
        color: SirayaColors.darkGreen,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Bonjour, ${widget.userName} 👋',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          // Bouton Notifications avec pastille orange
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Aucune nouvelle notification pour le moment.',
                          style: GoogleFonts.plusJakartaSans(),
                        ),
                        backgroundColor: SirayaColors.darkGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: SirayaColors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Transform.translate(
      offset: const Offset(0, -18),
      child: Container(
        padding: const EdgeInsets.all(SirayaSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: SirayaColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre et bouton Inverser
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Où souhaitez-vous aller ?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: SirayaColors.textPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: _swapCities,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: SirayaColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: SirayaColors.border),
                    ),
                    child: const Icon(
                      Icons.sync_rounded,
                      color: SirayaColors.green,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Champ Départ
            _buildCityInputTile(
              label: 'Départ',
              city: _departureCity,
              iconColor: SirayaColors.green,
              onTap: _selectDepartureCity,
            ),

            const SizedBox(height: 12),

            // Champ Arrivée
            _buildCityInputTile(
              label: 'Arrivée',
              city: _arrivalCity,
              iconColor: SirayaColors.orange,
              onTap: _selectArrivalCity,
            ),

            const SizedBox(height: 18),

            // Bouton Rechercher
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _onSearchPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SirayaColors.orange,
                  foregroundColor: SirayaColors.darkGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Rechercher',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: SirayaColors.darkGreen,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityInputTile({
    required String label,
    required CityEntity city,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: SirayaColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SirayaColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SirayaColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city.fullLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: SirayaColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              city.flagEmoji,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularDestinationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Destinations populaires',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: SirayaColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _selectDepartureCity();
                },
                child: Text(
                  'Voir tout',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: SirayaColors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 82,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: SirayaCities.popularRoutes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final route = SirayaCities.popularRoutes[index];
              return _buildDestinationCard(route);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard(PopularDestination route) {
    return InkWell(
      onTap: () => _applyPopularRoute(route),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SirayaColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    route.departure.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: SirayaColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  route.departure.flagEmoji,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.arrow_forward,
                  size: 13,
                  color: SirayaColors.orange,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    route.arrival.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: SirayaColors.textMuted,
                    ),
                  ),
                ),
                Text(
                  route.arrival.flagEmoji,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerCompaniesSection() {
    final partners = [
      (name: 'SENECAR', asset: AppConstants.logoSenecar),
      (name: 'ORABUS', asset: AppConstants.logoOrabus),
      (name: 'MALI BUS', asset: AppConstants.logoMaliBus),
      (name: 'SAHEL EXPRESS', asset: AppConstants.logoSahel),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Compagnies partenaires',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: SirayaColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Plus de 50 compagnies partenaires en Afrique de l\'Ouest.',
                        style: GoogleFonts.plusJakartaSans(),
                      ),
                      backgroundColor: SirayaColors.darkGreen,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text(
                  'Voir tout',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: SirayaColors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 64,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: partners.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final partner = partners[index];
              return Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: SirayaColors.border, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    partner.asset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text(
                        partner.name[0],
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          color: SirayaColors.darkGreen,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: SirayaColors.background,
        border: Border(
          top: BorderSide(color: SirayaColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Accueil',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.search_rounded,
                label: 'Recherche',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.calendar_month_outlined,
                label: 'Mes voyages',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentTabIndex == index;
    // Conforme à Figma : la couleur active de l'accueil est orange foncé (#A94700)
    final activeColor = SirayaColors.orangeDeep;
    final inactiveColor = SirayaColors.textPrimary;

    return InkWell(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
