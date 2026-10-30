import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/constants/siraya_cities.dart';
import 'package:nioudem/core/constants/siraya_countries.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/domain/entities/city_entity.dart';
import 'package:nioudem/domain/entities/country_entity.dart';

/// Écran 10 de la maquette Figma : Sélection ville (départ ou arrivée).
class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({
    super.key,
    required this.title,
    this.initialCity,
  });

  final String title;
  final CityEntity? initialCity;

  @override
  State<CitySelectionPage> createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<CityEntity> _recentCities = List.of(SirayaCities.defaultRecent);
  String? _selectedCountryFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CityEntity> get _filteredCities {
    final query = _searchController.text.trim().toLowerCase();
    return SirayaCities.all.where((city) {
      final matchesQuery = query.isEmpty ||
          city.name.toLowerCase().contains(query) ||
          city.country.toLowerCase().contains(query);
      final matchesCountry = _selectedCountryFilter == null ||
          city.country.toLowerCase() == _selectedCountryFilter!.toLowerCase();
      return matchesQuery && matchesCountry;
    }).toList();
  }

  void _selectCity(CityEntity city) {
    Navigator.of(context).pop(city);
  }

  void _clearRecent() {
    setState(() {
      _recentCities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();

    return Scaffold(
      backgroundColor: SirayaColors.background,
      appBar: AppBar(
        backgroundColor: SirayaColors.darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Barre de recherche dans bandeau vert sombre
          Container(
            color: SirayaColors.darkGreen,
            padding: const EdgeInsets.fromLTRB(
              SirayaSpacing.md,
              0,
              SirayaSpacing.md,
              SirayaSpacing.md,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: SirayaColors.textPrimary,
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: SirayaColors.textMuted,
                    size: 22,
                  ),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  hintText: 'Rechercher une ville...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: SirayaColors.textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Contenu déroulant
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: SirayaSpacing.md,
                vertical: SirayaSpacing.md,
              ),
              children: [
                // Villes récentes (visible si recherche vide)
                if (query.isEmpty && _recentCities.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Villes récentes',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: SirayaColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: _clearRecent,
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: SirayaColors.orange,
                        ),
                        child: Text(
                          'Effacer',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._recentCities.map((city) => _buildRecentCityTile(city)),
                  const SizedBox(height: 20),
                ],

                // Pays voisins (filtre interactif)
                if (query.isEmpty) ...[
                  Text(
                    'Pays voisins et autres pays d’Afrique',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: SirayaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCountryFilterChips(),
                  const SizedBox(height: 24),
                ],

                // Titre Toutes les villes
                Text(
                  _selectedCountryFilter != null
                      ? 'Villes ($_selectedCountryFilter)'
                      : 'Toutes les villes',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: SirayaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                // Liste filtrée des villes
                if (_filteredCities.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Aucune ville trouvée pour cette recherche.',
                        style: GoogleFonts.plusJakartaSans(
                          color: SirayaColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                else
                  ..._filteredCities.map((city) => _buildCityItem(city)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCityTile(CityEntity city) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SirayaColors.border),
      ),
      child: ListTile(
        onTap: () => _selectCity(city),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: SirayaColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.location_on_outlined,
            color: SirayaColors.green,
            size: 20,
          ),
        ),
        title: Text(
          city.name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: SirayaColors.textPrimary,
          ),
        ),
        subtitle: Text(
          city.country,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: SirayaColors.textMuted,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: SirayaColors.textMuted,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCountryFilterChips() {
    final popularCountries = SirayaCountries.all.take(8).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: Text(
            'Tous',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: _selectedCountryFilter == null,
          selectedColor: SirayaColors.green,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: _selectedCountryFilter == null
                ? Colors.white
                : SirayaColors.textPrimary,
          ),
          onSelected: (_) {
            setState(() {
              _selectedCountryFilter = null;
            });
          },
        ),
        ...popularCountries.map((CountryEntity country) {
          final isSelected = _selectedCountryFilter == country.name;
          return ChoiceChip(
            avatar: Text(
              country.flagEmoji,
              style: const TextStyle(fontSize: 14),
            ),
            label: Text(
              country.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            selected: isSelected,
            selectedColor: SirayaColors.green,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : SirayaColors.textPrimary,
            ),
            onSelected: (selected) {
              setState(() {
                _selectedCountryFilter = selected ? country.name : null;
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildCityItem(CityEntity city) {
    final isCurrent = widget.initialCity?.name == city.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isCurrent
            ? SirayaColors.green.withValues(alpha: 0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? SirayaColors.green : SirayaColors.border,
          width: isCurrent ? 1.5 : 1.0,
        ),
      ),
      child: ListTile(
        onTap: () => _selectCity(city),
        leading: Text(
          city.flagEmoji,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          city.name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: SirayaColors.textPrimary,
          ),
        ),
        subtitle: Text(
          city.country,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: SirayaColors.textMuted,
          ),
        ),
        trailing: isCurrent
            ? const Icon(
                Icons.check_circle,
                color: SirayaColors.green,
                size: 20,
              )
            : const Icon(
                Icons.arrow_forward_ios,
                color: SirayaColors.textMuted,
                size: 14,
              ),
      ),
    );
  }
}
