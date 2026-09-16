import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/core/theme/siraya_typography.dart';

/// Bouton Principal d'action SIRAYA (Orange d'accentuation).
/// Respecte la taille tactile minimale de 50dp et les contrastes WCAG.
class SirayaPrimaryButton extends StatelessWidget {
  const SirayaPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: SirayaSpacing.buttonHeight,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: SirayaColors.orange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: SirayaColors.border,
          disabledForegroundColor: SirayaColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
          ),
          elevation: 0,
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: SirayaSpacing.xs),
                  ],
                  Text(label, style: SirayaTypography.button),
                ],
              ),
      ),
    );
  }
}

/// Bouton Secondaire SIRAYA (Bordure verte sur fond transparent).
class SirayaSecondaryButton extends StatelessWidget {
  const SirayaSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: SirayaSpacing.buttonHeight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: SirayaColors.green,
          side: const BorderSide(color: SirayaColors.green, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: SirayaSpacing.xs),
            ],
            Text(
              label,
              style: SirayaTypography.button.copyWith(color: SirayaColors.green),
            ),
          ],
        ),
      ),
    );
  }
}
