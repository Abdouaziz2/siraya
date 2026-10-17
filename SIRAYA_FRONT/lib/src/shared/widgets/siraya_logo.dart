import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';

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
    final effectiveHeight = height ?? size ?? 32;
    return Semantics(
      label: 'Logo SIRAYA',
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.plusJakartaSans(
            fontSize: (effectiveHeight * 0.75).clamp(16.0, 48.0),
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
    );
  }
}
