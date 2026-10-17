# Architecture & Guide de Collaboration SIRAYA Front-End

Ce document définit les normes architecturales, la structure des dossiers et les conventions de code pour l'équipe de développement de **SIRAYA**.

---

## 1. Philosophie & Structure Globale (Feature-First)

Le projet adopte une approche **Feature-Driven Development (FDD)** couplée aux principes de la **Clean Architecture**. Chaque fonctionnalité métier vit dans son propre module isolé.

```text
lib/
├── firebase_options.dart      # Configuration Firebase multiplateforme
├── main.dart                  # Point d'entrée & initialisation Firebase
└── src/
    ├── app/                   # Configuration racine de l'application (Theme, MaterialApp)
    │   └── siraya_app.dart
    ├── core/                  # Transversal, réutilisable partout sans dépendance métier
    │   ├── config/            # Clés d'API, endpoints, constantes d'environnement
    │   ├── network/           # Gestion des erreurs et exceptions réseau
    │   └── theme/             # Design System (SirayaColors, Typography, Spacing, Theme)
    ├── features/              # Fonctionnalités métier isolées (1 dossier = 1 feature)
    │   ├── auth/              # Authentification (Téléphone OTP, Google, Email)
    │   │   ├── data/          # Appels Firebase Auth, synchronisation Firestore
    │   │   └── presentation/  # Écrans et widgets spécifiques à l'auth
    │   ├── search/            # Recherche de trajets
    │   │   ├── data/          # Repositories Firestore
    │   │   ├── domain/        # Modèles de données purs (SearchQuery, Trip)
    │   │   └── presentation/  # Écrans et composants de recherche
    │   ├── booking/           # (À venir) Réservation & sélection des sièges
    │   └── tickets/           # (À venir) Affichage des billets & QR Code
    └── shared/                # Composants atomiques partagés entre features
        ├── validators/        # Validateurs de formulaires (téléphone, email, code)
        └── widgets/           # SirayaPrimaryButton, SirayaBadge, SirayaTextField, SirayaLogo
```

---

## 2. Règle d'or pour le travail en équipe

### A. Travail en parallèle sans conflits Git
- **Chaque développeur travaille dans sa feature** : par exemple, le développeur A travaille dans `lib/src/features/search/` et le développeur B dans `lib/src/features/booking/`.
- Les fichiers partagés (`lib/src/core/theme/` ou `lib/src/shared/widgets/`) ne doivent être modifiés que lors d'un accord d'équipe pour préserver la cohérence visuelle.

### B. Découpage interne d'une Feature
Chaque dossier dans `features/<nom>/` doit respecter cette séparation :
1. **`domain/`** : Les modèles Dart purs (ex: `trip.dart`, `seat.dart`). Pas de dépendance Flutter UI.
2. **`data/`** : L'accès aux données (Firebase Auth, Firestore, APIs REST). C'est ici que l'on manipule Firestore et les exceptions.
3. **`presentation/`** : 
   - `screens/` : Les pages complètes.
   - `widgets/` : Les composants visuels spécifiques à cet écran (qui ne servent nulle part ailleurs).

---

## 3. Conventions du Design System SIRAYA

Pour garantir un rendu homogène et fidèle à la maquette Figma :

1. **Couleurs** : Ne jamais écrire de `Color(0xFF...)` en dur dans les widgets. Toujours utiliser :
   ```dart
   SirayaColors.green;       // 0xFF134E35 (Vert principal)
   SirayaColors.orange;      // 0xFFF27420 (Orange accent)
   SirayaColors.background;  // 0xFFF8F5EE (Fond doux)
   ```
2. **Typographie** : Ne pas utiliser `TextStyle` directement. Toujours passer par `SirayaTypography` ou `GoogleFonts.plusJakartaSans` :
   ```dart
   SirayaTypography.displayLarge;
   SirayaTypography.titleMedium;
   SirayaTypography.bodyMedium;
   ```
3. **Espacements** : Toujours utiliser la grille de 8dp de `SirayaSpacing` :
   ```dart
   SirayaSpacing.xs  // 8.0
   SirayaSpacing.sm  // 12.0
   SirayaSpacing.md  // 16.0
   SirayaSpacing.lg  // 24.0
   ```
4. **Boutons & Entrées** : Réutiliser `SirayaPrimaryButton` et `SirayaTextField` qui intègrent déjà les contraintes tactiles (>= 50dp) et l'accessibilité sémantique.

---

## 4. Pipeline de Validation avant Commit

Avant de pousser votre code ou d'ouvrir une Pull Request, **exécutez obligatoirement** :

```bash
# 1. Vérification des erreurs et des règles de style (doit afficher: No issues found!)
flutter analyze

# 2. Exécution de tous les tests unitaires et widgets
flutter test
```

---

## 5. Conventions de Branches Git

- `main` : Branche de production / version stable testée.
- `feature/<nom-de-la-feature>` : Branche de travail (ex: `feature/onboarding-figma`, `feature/phone-auth`).
- `fix/<nom-du-bug>` : Correction de bugs ciblés.
