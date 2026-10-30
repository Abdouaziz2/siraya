import 'package:flutter/material.dart';
import 'package:nioudem/core/constants/app_constants.dart';

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
  final bool dark;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? size ?? 54.0;
    // Ratio exact extrait de Figma (W=281, H=112) ~ 2.5 : 1
    final effectiveWidth = width ?? (effectiveHeight * 2.5);

    return Semantics(
      label: 'Logo SIRAYA',
      image: true,
      child: Image.asset(
        AppConstants.logoAsset,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
