import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/core/theme/siraya_typography.dart';

/// Champ de formulaire standard SIRAYA.
/// Conforme à la zone tactile minimale de 48dp et aux retours d'erreurs visuels clairs.
class SirayaTextField extends StatelessWidget {
  const SirayaTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLength;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: SirayaTypography.titleMedium.copyWith(
            fontSize: 14,
            color: SirayaColors.textPrimary,
          ),
        ),
        const SizedBox(height: SirayaSpacing.xs),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          style: SirayaTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            helperStyle: SirayaTypography.bodySmall,
            counterText: '',
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SirayaSpacing.md,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
