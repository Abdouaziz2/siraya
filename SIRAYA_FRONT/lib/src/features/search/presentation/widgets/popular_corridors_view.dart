import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/core/theme/siraya_typography.dart';

class CorridorItem {
  const CorridorItem({
    required this.departure,
    required this.destination,
    required this.flag,
    this.tag,
  });

  final String departure;
  final String destination;
  final String flag;
  final String? tag;
}

/// Affiche les corridors routiers les plus demandés en Afrique de l'Ouest
class PopularCorridorsView extends StatelessWidget {
  const PopularCorridorsView({
    super.key,
    required this.onSelectCorridor,
  });

  final void Function(String departure, String destination) onSelectCorridor;

  static const List<CorridorItem> corridors = [
    CorridorItem(
      departure: 'Dakar',
      destination: 'Bamako',
      flag: '🇸🇳 ➔ 🇲🇱',
      tag: 'Corridor Express',
    ),
    CorridorItem(
      departure: 'Dakar',
      destination: 'Touba',
      flag: '🇸🇳',
      tag: 'Fréquent',
    ),
    CorridorItem(
      departure: 'Dakar',
      destination: 'Saint-Louis',
      flag: '🇸🇳',
    ),
    CorridorItem(
      departure: 'Bamako',
      destination: 'Kayes',
      flag: '🇲🇱',
    ),
    CorridorItem(
      departure: 'Dakar',
      destination: 'Ziguinchor',
      flag: '🇸🇳',
    ),
    CorridorItem(
      departure: 'Abidjan',
      destination: 'Bouaké',
      flag: '🇨🇮',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.trending_up_rounded, color: SirayaColors.green, size: 20),
            const SizedBox(width: SirayaSpacing.xs),
            Expanded(
              child: Text(
                'Liaisons fréquentes',
                style: SirayaTypography.titleMedium.copyWith(color: SirayaColors.textPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: SirayaSpacing.sm),
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: corridors.length,
            separatorBuilder: (_, _) => const SizedBox(width: SirayaSpacing.sm),
            itemBuilder: (context, index) {
              final item = corridors[index];
              return InkWell(
                onTap: () => onSelectCorridor(item.departure, item.destination),
                borderRadius: BorderRadius.circular(SirayaSpacing.radiusMd),
                child: Container(
                  width: 184,
                  padding: const EdgeInsets.all(SirayaSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SirayaSpacing.radiusMd),
                    border: Border.all(color: SirayaColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.flag, style: const TextStyle(fontSize: 12)),
                          if (item.tag != null)
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: SirayaColors.orange.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(SirayaSpacing.radiusFull),
                                ),
                                child: Text(
                                  item.tag!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: SirayaColors.darkOrange,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: SirayaSpacing.xs),
                      Text(
                        '${item.departure} ➔ ${item.destination}',
                        style: SirayaTypography.titleMedium.copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
