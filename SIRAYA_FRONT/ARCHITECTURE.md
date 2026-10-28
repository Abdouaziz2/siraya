# 🏗️ SIRAYA — Clean Architecture Guide

## Structure du Projet

```
lib/
├── core/                              # Éléments transverses partagés
│   ├── config/                        # Configuration générale
│   ├── constants/                     # Constantes (AppConstants, durées, assets)
│   ├── errors/                        # Failures & exceptions
│   ├── extensions/                    # ContextExtensions, StringExtensions
│   ├── network/                       # ApiException, ApiConfig
│   ├── theme/                         # SirayaColors, Spacing, Typography, Theme
│   └── utils/                         # InputValidators, Helpers
│
├── data/                              # Couche Données (Implémentations externes)
│   ├── datasources/                   # Sources distantes (Firebase, REST) & locales
│   │   ├── auth_remote_data_source.dart
│   │   └── trip_remote_data_source.dart
│   ├── models/                        # Modèles sérialisables (DTOs)
│   │   ├── user_model.dart
│   │   ├── trip_model.dart
│   │   └── search_query_model.dart
│   └── repositories/                  # Implémentations concrètes des repositories
│       ├── auth_repository_impl.dart
│       └── trip_repository_impl.dart
│
├── domain/                            # Couche Domaine (Règles Métier pures)
│   ├── entities/                      # Entités métier immutables
│   │   ├── user_entity.dart
│   │   └── trip_entity.dart
│   ├── repositories/                  # Interfaces abstraites des repositories
│   │   ├── auth_repository.dart
│   │   └── trip_repository.dart
│   └── usecases/                      # Cas d'utilisation métier
│       ├── auth/
│       │   ├── send_otp_usecase.dart
│       │   ├── verify_otp_usecase.dart
│       │   ├── sign_in_with_google_usecase.dart
│       │   └── sign_out_usecase.dart
│       └── trips/
│           └── search_trips_usecase.dart
│
├── presentation/                      # Couche Présentation (UI & State)
│   ├── app.dart                       # SirayaApp (MaterialApp racine)
│   ├── bloc/                          # Contrôleurs d'état / BLoC / Notifiers
│   │   └── splash_bloc.dart
│   ├── pages/                         # Écrans de l'application
│   │   ├── splash/
│   │   │   └── splash_page.dart       # Écran 1 Splash Screen
│   │   ├── auth/
│   │   │   ├── phone_page.dart
│   │   │   ├── otp_page.dart
│   │   │   └── register_page.dart
│   │   └── home/
│   │       └── home_page.dart
│   └── widgets/                       # Widgets réutilisables du Design System
│       ├── siraya_logo.dart
│       ├── siraya_buttons.dart
│       ├── siraya_badge.dart
│       └── siraya_text_field.dart
│
├── firebase_options.dart              # Credentials Firebase
└── main.dart                          # Point d'entrée de l'application
```

---

## Règles d'Or Clean Architecture

1. **Règle de Dépendance** : Le code de la couche externe dépend uniquement de la couche interne.
   `Presentation` & `Data` $\to$ `Domain` (le Domaine n'importe jamais `data/` ou `presentation/`).
2. **UseCases** : Chaque action métier est encapsulée dans un UseCase dédié.
3. **Abstraction** : Les repositories sont déclarés dans `domain/repositories/` et implémentés dans `data/repositories/`.
