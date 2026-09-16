import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/core/theme/siraya_typography.dart';
import 'package:nioudem/src/features/search/domain/models/search_query.dart';

/// Bottom Sheet permettant de rechercher et sélectionner une ville de départ ou d'arrivée.
class CityPickerSheet extends StatefulWidget {
  const CityPickerSheet({
    super.key,
    required this.title,
    this.excludedCity,
  });

  final String title;
  final String? excludedCity;

  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? excludedCity,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CityPickerSheet(
        title: title,
        excludedCity: excludedCity,
      ),
    );
  }

  @override
  State<CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<CityPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableCities = SearchQuery.westAfricanCities.where((c) {
      final name = c['name'] ?? '';
      final country = c['country'] ?? '';
      if (widget.excludedCity != null && name.toLowerCase() == widget.excludedCity!.toLowerCase()) {
        return false;
      }
      if (_filter.isEmpty) return true;
      return name.toLowerCase().contains(_filter.toLowerCase()) ||
          country.toLowerCase().contains(_filter.toLowerCase());
    }).toList();

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.78,
      decoration: const BoxDecoration(
        color: SirayaColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(SirayaSpacing.radiusLg)),
      ),
      child: Column(
        children: [
          // Poignée de glissement
          const SizedBox(height: SirayaSpacing.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: SirayaColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: SirayaSpacing.md),

          // En-tête avec titre et bouton fermer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: SirayaTypography.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: SirayaColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const SizedBox(height: SirayaSpacing.xs),

          // Champ de filtre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SirayaSpacing.md),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              onChanged: (val) => setState(() => _filter = val),
              decoration: InputDecoration(
                hintText: 'Rechercher une ville ou un pays...',
                prefixIcon: const Icon(Icons.search_rounded, color: SirayaColors.green),
                suffixIcon: _filter.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _filter = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: SirayaSpacing.sm),

          // Liste des villes
          Expanded(
            child: availableCities.isEmpty
                ? Center(
                    child: Text(
                      'Aucune ville trouvée',
                      style: SirayaTypography.bodyMedium.copyWith(color: SirayaColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SirayaSpacing.md,
                      vertical: SirayaSpacing.xs,
                    ),
                    itemCount: availableCities.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final city = availableCities[index];
                      final cityName = city['name'] ?? '';
                      final country = city['country'] ?? '';
                      final flag = city['flag'] ?? '📍';
                      final hub = city['hub'] ?? '';

                      return InkWell(
                        onTap: () => Navigator.of(context).pop(cityName),
                        borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: SirayaSpacing.sm,
                            horizontal: SirayaSpacing.xs,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
                                  border: Border.all(color: SirayaColors.border),
                                ),
                                alignment: Alignment.center,
                                child: Text(flag, style: const TextStyle(fontSize: 20)),
                              ),
                              const SizedBox(width: SirayaSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cityName, style: SirayaTypography.titleMedium),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$country • $hub',
                                      style: SirayaTypography.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: SirayaColors.textMuted,
                                size: 20,
                              ),
                            ],
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
