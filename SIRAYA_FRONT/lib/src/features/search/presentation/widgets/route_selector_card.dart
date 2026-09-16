import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/core/theme/siraya_typography.dart';
import 'package:nioudem/src/features/search/domain/models/search_query.dart';
import 'package:nioudem/src/features/search/presentation/widgets/city_picker_sheet.dart';
import 'package:nioudem/src/shared/widgets/siraya_buttons.dart';

/// Carte principale de configuration de la recherche de voyage.
class RouteSelectorCard extends StatefulWidget {
  const RouteSelectorCard({
    super.key,
    required this.initialQuery,
    required this.onSearch,
  });

  final SearchQuery initialQuery;
  final ValueChanged<SearchQuery> onSearch;

  @override
  State<RouteSelectorCard> createState() => RouteSelectorCardState();
}

class RouteSelectorCardState extends State<RouteSelectorCard> {
  late SearchQuery _query;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
  }

  void updateCities(String departure, String destination) {
    setState(() {
      _query = _query.copyWith(
        departureCity: departure,
        destinationCity: destination,
      );
      _errorMessage = null;
    });
  }

  Future<void> _pickDeparture() async {
    final city = await CityPickerSheet.show(
      context,
      title: 'Ville de départ',
      excludedCity: _query.destinationCity,
    );
    if (city != null) {
      setState(() {
        _query = _query.copyWith(departureCity: city);
        _errorMessage = null;
      });
    }
  }

  Future<void> _pickDestination() async {
    final city = await CityPickerSheet.show(
      context,
      title: 'Ville d\'arrivée',
      excludedCity: _query.departureCity,
    );
    if (city != null) {
      setState(() {
        _query = _query.copyWith(destinationCity: city);
        _errorMessage = null;
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _query.departureDate.isBefore(now) ? now : _query.departureDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: SirayaColors.green,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: SirayaColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _query = _query.copyWith(departureDate: picked);
      });
    }
  }

  void _adjustPassengers(int delta) {
    final newCount = (_query.passengerCount + delta).clamp(1, 9);
    setState(() {
      _query = _query.copyWith(passengerCount: newCount);
    });
  }

  void _submit() {
    if (_query.departureCity == null || _query.departureCity!.isEmpty) {
      setState(() => _errorMessage = 'Veuillez choisir une ville de départ');
      return;
    }
    if (_query.destinationCity == null || _query.destinationCity!.isEmpty) {
      setState(() => _errorMessage = 'Veuillez choisir une ville d\'arrivée');
      return;
    }
    setState(() => _errorMessage = null);
    widget.onSearch(_query);
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Aujourd\'hui, ${d.day}/${d.month}';
    }
    final tomorrow = now.add(const Duration(days: 1));
    if (d.year == tomorrow.year && d.month == tomorrow.month && d.day == tomorrow.day) {
      return 'Demain, ${d.day}/${d.month}';
    }
    const months = [
      '', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(SirayaSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bloc Villes (Départ et Arrivée avec bouton swap)
            Container(
              decoration: BoxDecoration(
                color: SirayaColors.background,
                borderRadius: BorderRadius.circular(SirayaSpacing.radiusMd),
                border: Border.all(color: SirayaColors.border),
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Column(
                    children: [
                      _CityTile(
                        label: 'Départ',
                        value: _query.departureCity ?? 'D\'où partez-vous ?',
                        isPlaceholder: _query.departureCity == null,
                        icon: Icons.trip_origin_rounded,
                        iconColor: SirayaColors.green,
                        onTap: _pickDeparture,
                      ),
                      const Divider(height: 1),
                      _CityTile(
                        label: 'Destination',
                        value: _query.destinationCity ?? 'Où allez-vous ?',
                        isPlaceholder: _query.destinationCity == null,
                        icon: Icons.location_on_rounded,
                        iconColor: SirayaColors.orange,
                        onTap: _pickDestination,
                      ),
                    ],
                  ),
                  // Bouton Swap
                  Positioned(
                    right: SirayaSpacing.md,
                    child: Material(
                      color: Colors.white,
                      elevation: 1,
                      shape: const CircleBorder(
                        side: BorderSide(color: SirayaColors.border),
                      ),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          setState(() {
                            _query = _query.swapCities();
                            _errorMessage = null;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.swap_vert_rounded,
                            color: SirayaColors.green,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SirayaSpacing.sm),

            // Bloc Date & Passagers adaptatif
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 320;

                final dateWidget = InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SirayaSpacing.sm,
                      vertical: SirayaSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: SirayaColors.background,
                      borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
                      border: Border.all(color: SirayaColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: SirayaColors.green,
                          size: 20,
                        ),
                        const SizedBox(width: SirayaSpacing.xs),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date de départ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: SirayaColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatDate(_query.departureDate),
                                style: SirayaTypography.titleMedium.copyWith(fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                final passengerWidget = Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: SirayaSpacing.sm - 4,
                  ),
                  decoration: BoxDecoration(
                    color: SirayaColors.background,
                    borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
                    border: Border.all(color: SirayaColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _query.passengerCount > 1 ? () => _adjustPassengers(-1) : null,
                        borderRadius: BorderRadius.circular(SirayaSpacing.radiusFull),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.remove_circle_outline_rounded,
                            size: 20,
                            color: _query.passengerCount > 1
                                ? SirayaColors.green
                                : SirayaColors.textMuted,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_query.passengerCount}',
                            style: SirayaTypography.titleLarge.copyWith(fontSize: 15),
                          ),
                          Text(
                            _query.passengerCount > 1 ? 'places' : 'place',
                            style: const TextStyle(
                              fontSize: 10,
                              color: SirayaColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: _query.passengerCount < 9 ? () => _adjustPassengers(1) : null,
                        borderRadius: BorderRadius.circular(SirayaSpacing.radiusFull),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.add_circle_outline_rounded,
                            size: 20,
                            color: _query.passengerCount < 9
                                ? SirayaColors.green
                                : SirayaColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (isCompact) {
                  return Column(
                    children: [
                      dateWidget,
                      const SizedBox(height: SirayaSpacing.xs),
                      passengerWidget,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(flex: 3, child: dateWidget),
                    const SizedBox(width: SirayaSpacing.xs),
                    Expanded(flex: 2, child: passengerWidget),
                  ],
                );
              },
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: SirayaSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: SirayaColors.error),
                  const SizedBox(width: SirayaSpacing.xs),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: SirayaTypography.bodySmall.copyWith(color: SirayaColors.error),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: SirayaSpacing.md),

            // Bouton Principal de recherche
            SirayaPrimaryButton(
              label: 'Rechercher des voyages',
              icon: Icons.search_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  const _CityTile({
    required this.label,
    required this.value,
    required this.isPlaceholder,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool isPlaceholder;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SirayaSpacing.md,
          vertical: SirayaSpacing.sm + 2,
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: SirayaSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: SirayaColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: SirayaTypography.titleMedium.copyWith(
                      color: isPlaceholder
                          ? SirayaColors.textMuted
                          : SirayaColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40), // Espace réservé pour ne pas chevaucher le bouton Swap
          ],
        ),
      ),
    );
  }
}
