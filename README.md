# Libreville Découverte

Application mobile de guide touristique pour Libreville et ses environs proches (Pointe-Denis, Parc National de Pongara), développée avec Flutter et Dart dans le cadre du parcours D-CLIC — Développement Mobile, niveau approfondi.

## Objectif

Le Gabon renforce actuellement son ambition écotouristique, mais l'offre numérique locale reste limitée à de simples annuaires de commerces et d'informations pratiques. Libreville Découverte répond à ce manque en proposant un vrai guide touristique structuré : découverte des lieux par catégorie, fiches détaillées, favoris personnels liés à un compte, et navigation en temps réel vers chaque lieu — pensé pour les visiteurs comme pour les habitants de Libreville.

## Fonctionnalités principales

- **Authentification** : inscription et connexion par email/mot de passe (Firebase Authentication)
- **Accueil** : recherche par mot-clé, filtres par catégorie (culture, nature, plages, patrimoine religieux), section "à ne pas manquer"
- **Fiche détail d'un lieu** : photo, description, horaires, informations d'accès, ajout/retrait des favoris
- **Favoris** : liés au compte utilisateur, synchronisés en temps réel via Cloud Firestore (accessibles depuis n'importe quel appareil après connexion)
- **Carte et navigation** : affichage de la position en temps réel de l'utilisateur, marqueurs pour chaque lieu, tracé d'itinéraire avec distance et durée estimées au clic sur un marqueur
- **Profil** : informations du compte connecté, déconnexion

## Technologies et packages utilisés

| Catégorie | Choix |
|---|---|
| Framework | Flutter / Dart |
| Architecture | MVC (models / views / controllers / services / widgets) |
| Gestion d'état | Provider |
| Authentification | Firebase Authentication (email/mot de passe) |
| Base de données | Cloud Firestore |
| Carte | `flutter_map` (tuiles OpenStreetMap) |
| Calcul d'itinéraire | Service public OSRM (`router.project-osrm.org`) |
| Géolocalisation | `geolocator` |
| Images | `cached_network_image` |
| Cache local | `shared_preferences` |
| Icône de l'application | `flutter_launcher_icons` |

**Choix assumé — carte gratuite plutôt que Google Maps** : le projet utilise OpenStreetMap et le service public OSRM plutôt que Google Maps/Directions, qui nécessitent l'activation d'une facturation Google Cloud (carte bancaire). Cette alternative gratuite et sans clé API convient parfaitement à un projet étudiant, au prix d'une disponibilité de service non garantie à 100 % (serveur de démonstration public).

## Installation

1. Cloner le dépôt :
   ```bash
   git clone https://github.com/jerryetdoris-ctrl/libreville-decouverte.git
   cd libreville-decouverte
   ```

2. Installer les dépendances :
   ```bash
   flutter pub get
   ```

3. Configurer Firebase pour ton propre projet (le fichier `firebase_options.dart` n'est pas versionné, par sécurité) :
   ```bash
   flutterfire configure
   ```

4. Dans la console Firebase, activer l'authentification par email/mot de passe (Authentication → Sign-in method).

5. Créer une base Firestore (mode test suffisant pour évaluer le projet) et peupler les collections `categories` et `lieux` — structure détaillée dans le dossier de conception technique (`03_Conception_technique_LibrevilleDecouverte.docx`).

## Lancement de l'application

```bash
flutter run
```

Une version installable (APK) est également disponible :
```
build/app/outputs/flutter-apk/app-release.apk
```
(générée via `flutter build apk --release`, fournie séparément dans le ZIP de remise)

## Tests réalisés

```bash
flutter test
flutter test integration_test/app_test.dart
```

- **Tests unitaires** (`test/models/lieu_test.dart`) : vérifient que `Lieu.fromMap()` interprète correctement un document Firestore complet, et applique des valeurs par défaut sûres si des champs sont manquants.
- **Tests de widgets** (`test/widgets/lieu_card_test.dart`) : vérifient l'affichage du nom et de l'accès d'un lieu, l'état visuel du favori (cœur plein/vide), et le déclenchement correct du callback au clic.
- **Test d'intégration** (`integration_test/app_test.dart`) : vérifie que l'application démarre réellement (Firebase inclus), affiche l'écran de connexion, et que la validation du formulaire fonctionne.
- **Debugging** : observation des rebuilds et de la consommation mémoire via Flutter DevTools pendant la navigation sur l'écran carte (l'écran le plus lourd du projet) et pendant la saisie dans la barre de recherche de l'accueil.

## Captures d'écran

**Écran d'accueil** — recherche, filtres par catégorie, lieux incontournables :

![Écran d'accueil](screenshots/accueil.jpg)

**Écran d'inscription** — validation de formulaire en temps réel :

![Écran d'inscription](screenshots/inscription.jpg)

*D'autres captures (fiche détail, carte avec itinéraire, favoris) sont disponibles dans le dossier `screenshots/` du dépôt.*

## Difficultés rencontrées

Ce projet a été l'occasion de résoudre plusieurs problèmes concrets, plutôt formateurs :

- **PowerShell vs syntaxe Unix** : `mkdir` sous Windows n'accepte pas plusieurs noms de dossiers séparés par des espaces (il faut des virgules), et le collage de plusieurs commandes d'un coup dans le terminal provoquait des concaténations accidentelles de lignes.
- **FlutterFire CLI sous Windows** : l'outil ne trouvait pas correctement le Firebase CLI installé via npm lors de l'appel interne qu'il fait à `firebase --version`, un bug connu sous Windows. Résolu en pointant explicitement l'exécutable avec l'option `--firebase-executable`.
- **Sensibilité à la casse dans Firestore** : plusieurs bugs d'affichage (catégories sans nom, champ `acces` invisible) provenaient de noms de champs mal orthographiés (`Nom` au lieu de `nom`, `horaire` au lieu de `horaires`) — invisibles à l'œil nu mais bloquants pour le code, qui cherche une clé exacte.
- **Cache local Firestore obsolète** : après une succession rapide de corrections de données, l'application continuait d'afficher d'anciennes valeurs malgré les mises à jour côté serveur. Résolu en désactivant la persistance locale de Firestore (`persistenceEnabled: false`), le projet disposant déjà d'un mécanisme de cache local séparé et plus simple à maîtriser.
- **Facturation Google Maps** : l'implémentation initialement prévue avec `google_maps_flutter` nécessitait l'activation d'une facturation Google Cloud (carte bancaire), non disponible. Pivot vers `flutter_map` (OpenStreetMap) et le service gratuit OSRM pour le calcul d'itinéraire, une alternative pertinente pour un projet étudiant.

## Améliorations possibles

- Ajouter la connexion via Google Sign-In (prévue en fonctionnalité optionnelle dès la conception)
- Remplacer le service OSRM public par une solution plus robuste en cas de passage en production
- Ajouter un mode hors ligne complet pour la consultation des fiches déjà visitées
- Compléter les photos manquantes (marché du Mont-Bouët, arboretum de Sibang) avec des photos prises sur place

## Auteur

Jerry Marvin MBOUMBOU BOULINGUI — Projet réalisé dans le cadre du parcours D-CLIC (OIF), Développement Mobile niveau approfondi.