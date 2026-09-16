import 'package:flutter/material.dart';

/// Design Tokens d'espacement, d'arrondis et de dimensions tactiles pour SIRAYA.
/// Basé sur une grille stricte de 8dp (avec demi-pas de 4dp).
abstract class SirayaSpacing {
  // Grille d'espacement
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;

  // Arrondis (Border Radius)
  static const double radiusXs = 6.0;
  static const double radiusSm = 8.0;    // Champs de formulaire & petits boutons
  static const double radiusMd = 12.0;   // Cartes de voyages planifiés
  static const double radiusLg = 16.0;   // Modales & Bottom Sheets
  static const double radiusXl = 24.0;   // En-têtes arrondis
  static const double radiusFull = 999.0;// Chips & Badges pilules

  // Dimensions tactiles (Accessibilité WCAG 2.5.5 / Android touch target)
  static const double minTouchTarget = 48.0; // Zone tactile minimale absolue
  static const double buttonHeight = 50.0;   // Hauteur confortable pour le pouce
  static const double inputHeight = 52.0;    // Hauteur des champs de saisie
}

/// Raccourcis d'espacements verticaux et horizontaux
class SirayaGap {
  static const xxs = SizedBox(width: SirayaSpacing.xxs, height: SirayaSpacing.xxs);
  static const xs = SizedBox(width: SirayaSpacing.xs, height: SirayaSpacing.xs);
  static const sm = SizedBox(width: SirayaSpacing.sm, height: SirayaSpacing.sm);
  static const md = SizedBox(width: SirayaSpacing.md, height: SirayaSpacing.md);
  static const lg = SizedBox(width: SirayaSpacing.lg, height: SirayaSpacing.lg);
  static const xl = SizedBox(width: SirayaSpacing.xl, height: SirayaSpacing.xl);
}
