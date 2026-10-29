import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';

/// Échelle Typographique SIRAYA (Plus Jakarta Sans).
abstract class SirayaTypography {
  // Grands Titres & Hero
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    height: 1.2,
    color: SirayaColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.25,
    color: SirayaColors.textPrimary,
  );

  // Titres de sections & Cartes de voyage
  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: SirayaColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: SirayaColors.textPrimary,
  );

  // Corps de texte
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: SirayaColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: SirayaColors.textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: SirayaColors.textMuted,
  );

  // Boutons, Badges, Prix
  static TextStyle get button => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    color: Colors.white,
  );

  static TextStyle get badge => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static TextStyle get price => GoogleFonts.plusJakartaSans(
    fontSize: 19,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    color: SirayaColors.green,
  );
}

