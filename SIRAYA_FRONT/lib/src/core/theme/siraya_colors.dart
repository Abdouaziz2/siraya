import 'package:flutter/material.dart';

/// Design Tokens des Couleurs SIRAYA.
/// Optimisé pour les conditions de forte luminosité et conforme WCAG 2.1 AA.
abstract class SirayaColors {
  // Couleurs Identitaires de Marque
  static const Color green = Color(0xFF004B2F);       // Vert forêt identitaire
  static const Color darkGreen = Color(0xFF003820);   // Vert très sombre (Header, Contraste)
  static const Color orange = Color(0xFFFF7900);      // Orange vif d'action
  static const Color darkOrange = Color(0xFFC85A00);  // Orange soutenu pour contraste texte (WCAG AA)

  // Couleurs de Surface & Arrière-plans
  static const Color background = Color(0xFFF8F4EE);  // Fond cassé chaud anti-éblouissement
  static const Color surface = Color(0xFFFFFFFF);     // Surface des cartes
  static const Color surfaceSubtle = Color(0xFFF1EDE6); // Surface de regroupement

  // Échelle des Neutres & Textes
  static const Color textPrimary = Color(0xFF1A221E);   // Texte principal (Contraste 13:1 sur fond)
  static const Color textSecondary = Color(0xFF4D5952); // Texte secondaire
  static const Color textMuted = Color(0xFF76827B);     // Métadonnées & placeholders
  static const Color border = Color(0xFFE2DCD2);        // Bordures douces
  static const Color divider = Color(0xFFEFECE4);       // Séparateurs discrets

  // Couleurs Sémantiques (Statuts de voyage, billets et paiements)
  static const Color success = Color(0xFF166534);       // Billet confirmé, Paiement réussi
  static const Color successBg = Color(0xFFDCFCE7);     // Fond badge succès
  static const Color warning = Color(0xFFB45309);       // Départ imminent, 15 min restantes
  static const Color warningBg = Color(0xFFFEF3C7);     // Fond badge alerte
  static const Color error = Color(0xFFB91C1C);         // Voyage complet, Annulé, Échec
  static const Color errorBg = Color(0xFFFEE2E2);       // Fond badge erreur
  static const Color info = Color(0xFF1D4ED8);          // Repère gare, Info trajet
  static const Color infoBg = Color(0xFFDBEAFE);        // Fond badge info

  // Rétrocompatibilité
  static const Color muted = Color(0xFF6D746F);
}
