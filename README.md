# JobCraft CV

Application Flutter locale pour créer des CV, lettres de motivation, emails de candidature, messages LinkedIn, relances et suivre ses candidatures.

## Fonctionnalités

- Création d’un profil utilisateur complet.
- Mode d’emploi pédagogique pour aider les débutants à remplir leur CV.
- Assistant IA local pour améliorer le résumé, noter le CV et suggérer des compétences.
- Générateur de CV avec aperçu, 3 modèles et export PDF.
- Générateur de lettre de motivation modifiable avec export PDF.
- Générateur local de messages de candidature.
- Suivi des candidatures avec statut, date et notes.
- Stockage local uniquement avec Hive, sans backend.

## Architecture

- `lib/models` : modèles de données simples.
- `lib/screens` : écrans principaux de l’application.
- `lib/services` : stockage Hive, génération de textes et export PDF.
- `lib/widgets` : composants réutilisables.

## Lancer l’application

```bash
cd jobcraft_cv
flutter pub get
flutter run
```

## Vérifier le projet

```bash
flutter analyze
flutter test
```

## Dépendances principales

- `hive` et `hive_flutter` pour le stockage local.
- `pdf` et `printing` pour l’export PDF.
- `path_provider` pour la compatibilité stockage local.
- `intl` pour le formatage des dates.
