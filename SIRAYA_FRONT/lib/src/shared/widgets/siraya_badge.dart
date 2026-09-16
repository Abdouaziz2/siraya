import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/core/theme/siraya_typography.dart';

enum SirayaBadgeVariant {
  success,
  warning,
  error,
  info,
  neutral,
  primary,
}

/// Badge d'état, de confort ou d'équipement SIRAYA.
class SirayaBadge extends StatelessWidget {
  const SirayaBadge({
    super.key,
    required this.label,
    this.icon,
    this.variant = SirayaBadgeVariant.neutral,
  });

  final String label;
  final IconData? icon;
  final SirayaBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor) = switch (variant) {
      SirayaBadgeVariant.success => (SirayaColors.successBg, SirayaColors.success),
      SirayaBadgeVariant.warning => (SirayaColors.warningBg, SirayaColors.warning),
      SirayaBadgeVariant.error => (SirayaColors.errorBg, SirayaColors.error),
      SirayaBadgeVariant.info => (SirayaColors.infoBg, SirayaColors.info),
      SirayaBadgeVariant.primary => (SirayaColors.green.withValues(alpha: 0.12), SirayaColors.green),
      SirayaBadgeVariant.neutral => (SirayaColors.surfaceSubtle, SirayaColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SirayaSpacing.xs + 2,
        vertical: SirayaSpacing.xxs + 1,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(SirayaSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: SirayaSpacing.xxs),
          ],
          Text(
            label,
            style: SirayaTypography.badge.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
