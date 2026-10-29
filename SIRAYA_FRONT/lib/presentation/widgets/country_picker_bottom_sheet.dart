import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/constants/siraya_countries.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';
import 'package:nioudem/domain/entities/country_entity.dart';

/// Modal Bottom Sheet dynamique pour la sélection de pays SIRAYA.
class CountryPickerBottomSheet extends StatefulWidget {
  const CountryPickerBottomSheet({
    super.key,
    required this.selectedCountry,
    this.countries = SirayaCountries.all,
  });

  final CountryEntity selectedCountry;
  final List<CountryEntity> countries;

  static Future<CountryEntity?> show(
    BuildContext context, {
    required CountryEntity currentCountry,
    List<CountryEntity>? availableCountries,
  }) {
    return showModalBottomSheet<CountryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CountryPickerBottomSheet(
        selectedCountry: currentCountry,
        countries: availableCountries ?? SirayaCountries.all,
      ),
    );
  }

  @override
  State<CountryPickerBottomSheet> createState() => _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<CountryEntity> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
  }

  void _onSearch(String query) {
    setState(() {
      _filteredCountries = SirayaCountries.search(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFCF9F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barre de drag
            const SizedBox(height: SirayaSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: SirayaSpacing.md),

            // En-tête
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.xl),
              child: Row(
                children: [
                  Text(
                    'Sélectionnez un pays',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF141F1A),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: const Color(0xFF4B5563),
                  ),
                ],
              ),
            ),

            // Barre de recherche
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SirayaSpacing.xl,
                vertical: SirayaSpacing.xs,
              ),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.md),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                    const SizedBox(width: SirayaSpacing.xs),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearch,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF141F1A),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Rechercher un pays ou indicatif...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: const Color(0xFF9CA3AF),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: SirayaSpacing.xs),

            // Liste des pays
            Flexible(
              child: _filteredCountries.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(SirayaSpacing.xxl),
                      child: Text(
                        'Aucun pays trouvé',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SirayaSpacing.lg,
                        vertical: SirayaSpacing.xs,
                      ),
                      itemCount: _filteredCountries.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: Color(0xFFF3F4F6),
                      ),
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        final isSelected = country.isoCode == widget.selectedCountry.isoCode;

                        return InkWell(
                          onTap: () => Navigator.of(context).pop(country),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SirayaSpacing.md,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? SirayaColors.green.withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // Drapeau emoji
                                Text(
                                  country.flagEmoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: SirayaSpacing.md),

                                // Nom du pays
                                Expanded(
                                  child: Text(
                                    country.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? SirayaColors.green
                                          : const Color(0xFF141F1A),
                                    ),
                                  ),
                                ),

                                // Indicatif téléphonique
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    country.dialCode,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                ),

                                if (isSelected) ...[
                                  const SizedBox(width: SirayaSpacing.sm),
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: SirayaColors.green,
                                    size: 20,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
