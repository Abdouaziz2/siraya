import 'package:flutter/material.dart';
import 'package:nioudem/src/core/theme/siraya_colors.dart';
import 'package:nioudem/src/core/theme/siraya_spacing.dart';
import 'package:nioudem/src/core/theme/siraya_typography.dart';

/// Thème global officiel de l'application SIRAYA.
class SirayaTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: SirayaColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: SirayaColors.green,
        primary: SirayaColors.green,
        onPrimary: Colors.white,
        secondary: SirayaColors.orange,
        onSecondary: Colors.white,
        surface: SirayaColors.surface,
        onSurface: SirayaColors.textPrimary,
        error: SirayaColors.error,
        onError: Colors.white,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: SirayaColors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: SirayaColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SirayaSpacing.radiusMd),
          side: const BorderSide(color: SirayaColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SirayaSpacing.md,
          vertical: 14,
        ),
        hintStyle: SirayaTypography.bodyMedium.copyWith(color: SirayaColors.textMuted),
        labelStyle: SirayaTypography.bodyMedium.copyWith(color: SirayaColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
          borderSide: const BorderSide(color: SirayaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
          borderSide: const BorderSide(color: SirayaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
          borderSide: const BorderSide(color: SirayaColors.green, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
          borderSide: const BorderSide(color: SirayaColors.error, width: 1.2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: SirayaColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
