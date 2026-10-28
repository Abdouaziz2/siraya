import 'package:flutter/material.dart';
import 'package:nioudem/core/theme/siraya_colors.dart';
import 'package:nioudem/core/theme/siraya_spacing.dart';

/// Extensions pratiques sur [BuildContext].
extension ContextExtensions on BuildContext {
  // ── Dimensions ──────────────────────────────────────────────────────────
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  // ── Thème ────────────────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // ── Navigation ───────────────────────────────────────────────────────────
  NavigatorState get navigator => Navigator.of(this);
  void pop<T>([T? result]) => navigator.pop(result);
  Future<T?> push<T>(Route<T> route) => navigator.push(route);

  // ── Snackbar ─────────────────────────────────────────────────────────────
  void showError(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: SirayaColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(SirayaSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
        ),
      ),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: SirayaColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(SirayaSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SirayaSpacing.radiusSm),
        ),
      ),
    );
  }
}
