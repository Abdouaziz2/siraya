import 'package:flutter/material.dart';

class SirayaLogo extends StatelessWidget {
  const SirayaLogo({
    super.key,
    this.size,
    double? width,
    this.height,
    this.dark = false,
  }) : width = width ?? size ?? 180;

  final double? size;
  final double width;
  final double? height;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Logo SIRAYA',
      image: true,
      child: Image.asset(
        'assets/images/siraya_logo.png',
        width: width,
        height: height ?? size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback sur le logo transparent existant si siraya_logo.png n'est pas encore copié
          return Image.asset(
            'assets/images/siraya_logo_transparent.png',
            width: width,
            height: height ?? size,
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
