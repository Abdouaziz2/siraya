# Etat actuel du projet SIRAYA

## Vue d'ensemble

Le projet actuel est un backend Spring Boot fonctionnel, mais il est encore a un stade tres initial.

Il ne contient pas encore la majorite des domaines metier de la plateforme SIRAYA.

Le backend correspond aujourd'hui a un starter Spring Boot avec un CRUD Agent operationnel.

## Ce qui est implemente

Le backend contient actuellement un seul vrai module metier : Agent.

Fonctionnalites disponibles :

- Creation d'un agent
- Modification d'un agent
- Consultation d'un agent par ID
- Liste paginee des agents
- Recherche et filtrage des agents
- Suppression d'un agent
- Validation basique des donnees
- Verification d'unicite de l'email cote service
- Gestion centralisee des erreurs
- Documentation Swagger / OpenAPI
- Connexion MySQL en runtime
- Base H2 pour les tests

## Endpoints disponibles

Avec le context path `/api`, les endpoints disponibles sont :

```text
POST   /api/agents
PUT    /api/agents/{id}
GET    /api/agents/{id}
GET    /api/agents/all
DELETE /api/agents/{id}
```

Swagger est disponible a l'adresse :

```text
http://localhost:8000/api/swagger-ui.html
```

## Structure technique actuelle

Le projet suit actuellement une architecture en couches classique :

```text
controller -> service -> repository -> database
```

Packages presents :

```text
com.bayecode.siraya
├── configurations
├── controller
├── entity
├── entity.enums
├── exception
├── mapper
├── model
├── repository
└── services
```

## Classes principales

- `SirayaApplication` : point d'entree Spring Boot
- `AgentController` : API REST des agents
- `AgentService` : contrat metier agent
- `AgentServiceImpl` : logique metier agent
- `AgentRepository` : acces base de donnees
- `AgentEntity` : entite JPA
- `AgentDTO` : DTO expose par l'API
- `AgentMapper` : mapping DTO / entity avec MapStruct
- `Response` : format standard des reponses API
- `GlobalExceptionHandler` : gestion globale des erreurs
- `SexType` : enum sexe

## Donnees Agent actuelles

Un agent contient actuellement les champs suivants :

```text
id
name
lastName
sexe
dni
phone
address
email
```

## Ce qui n'est pas encore implemente

Les domaines centraux de SIRAYA ne sont pas encore presents dans le code actuel :

- Authentification OTP
- Utilisateurs voyageurs
- Roles et permissions
- Compagnies de transport
- Validation des compagnies
- Documents compagnie
- Agences
- Employes et autorisations
- Bus
- Sieges
- Equipements
- Pays et villes
- Trajets
- Arrets intermediaires
- Programmes de voyage
- Tarifs
- Recherche de trajets
- Reservations
- Blocage temporaire des places
- Paiements
- Webhooks de paiement
- Billets numeriques
- QR codes
- Embarquement
- Annulations
- Remboursements
- Notifications
- Litiges
- Audit
- Statistiques
- Parametres globaux

## Qualite technique actuelle

### Points positifs

- Structure simple et lisible
- Separation controller / service / repository correcte
- DTO separe de l'entite
- Mapper MapStruct deja en place
- Exceptions centralisees
- Tests de demarrage Spring presents
- Configuration test avec H2
- Swagger configure
- Build Maven fonctionnel

### Points faibles ou incomplets

- Couverture de tests tres minimale
- Pas de securite
- Pas d'authentification
- Pas de gestion des roles
- Pas de migrations SQL type Flyway ou Liquibase
- Pas encore de vraie modelisation metier SIRAYA
- Pas de contraintes fortes en base, par exemple unicite email
- Le champ `dni` est traite comme une date, ce qui est ambigu
- `@CrossOrigin("*")` est trop permissif
- `ddl-auto: update` est pratique en developpement mais risque en production

## Conclusion

Le projet est actuellement un starter backend Spring Boot avec un CRUD Agent operationnel.

Il n'est pas encore une plateforme complete de reservation de billets de bus.

La base technique est utilisable, mais les grands modules metier de SIRAYA restent a concevoir et implementer progressivement.
