import 'package:flutter/material.dart';

/// Design Tokens des Couleurs SIRAYA extraites du nouveau logo.
/// Conforme WCAG 2.1 AA pour un contraste optimal en plein soleil.
abstract class SirayaColors {
  // Couleurs Identitaires issues du nouveau logo
  static const Color green = Color(0xFF134E35);       // Vert forêt route (S, i, r, a)
  static const Color darkGreen = Color(0xFF0C2F20);   // Vert très sombre (Header, Contraste)
  static const Color orange = Color(0xFFF27420);      // Orange identitaire vif (y, a, pin bus)
  static const Color darkOrange = Color(0xFFC6550A);  // Orange soutenu pour contraste texte

  // Surfaces & Arrière-plans
  static const Color background = Color(0xFFF8F5EE);  // Fond cassé doux anti-éblouissement
  static const Color surface = Color(0xFFFFFFFF);     // Surface des cartes
  static const Color surfaceSubtle = Color(0xFFF0EAE1); // Surface de regroupement

  // Échelle des Neutres & Textes
  static const Color textPrimary = Color(0xFF141F1A);   // Texte principal
  static const Color textSecondary = Color(0xFF4C5851); // Texte secondaire
  static const Color textMuted = Color(0xFF7A8680);     // Métadonnées & placeholders
  static const Color border = Color(0xFFE2DDD5);        // Bordures
  static const Color divider = Color(0xFFEFECE4);       // Séparateurs discrets

  // Couleurs Sémantiques (Statuts de voyage)
  static const Color success = Color(0xFF15803D);       // Confirmé, Paiement réussi
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFB45309);       // Départ imminent
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFB91C1C);         // Complet, Annulé, Échec
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF1D4ED8);          // Infos trajet
  static const Color infoBg = Color(0xFFDBEAFE);

  // Rétrocompatibilité
  static const Color muted = Color(0xFF6D746F);
}
