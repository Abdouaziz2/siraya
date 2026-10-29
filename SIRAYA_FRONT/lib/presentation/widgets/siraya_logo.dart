import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/constants/app_constants.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';

/// Logo officiel SIRAYA utilisant les assets images haute définition.
class SirayaLogo extends StatelessWidget {
  const SirayaLogo({
    super.key,
    this.size,
    this.width,
    this.height,
    this.dark = false,
    this.fit = BoxFit.contain,
  });

  /// Hauteur de référence ou taille carrée.
  final double? size;
  final double? width;
  final double? height;

  /// Si `true` (fond sombre ex: splash, onboarding), utilise le logo blanc + orange.
  /// Si `false` (fond clair), utilise le logo vert forêt + orange.
  final bool dark;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? size ?? 48.0;
    // Ratio officiel du logo SIRAYA ~ 2.4 : 1
    final effectiveWidth = width ?? (effectiveHeight * 2.4);

    final assetPath = dark
        ? AppConstants.logoWhiteAsset
        : AppConstants.logoGreenAsset;

    return Semantics(
      label: 'Logo SIRAYA',
      image: true,
      child: Image.asset(
        assetPath,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => RichText(
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(
              fontSize: (effectiveHeight * 0.7).clamp(16.0, 48.0),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            children: [
              TextSpan(
                text: 'Sira',
                style: TextStyle(
                  color: dark ? Colors.white : SirayaColors.green,
                ),
              ),
              const TextSpan(
                text: 'ya',
                style: TextStyle(color: SirayaColors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
