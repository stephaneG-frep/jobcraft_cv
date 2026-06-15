import '../models/user_profile.dart';

class LocalAiResult {
  const LocalAiResult({
    required this.score,
    required this.title,
    required this.suggestions,
    required this.generatedSummary,
  });

  final int score;
  final String title;
  final List<String> suggestions;
  final String generatedSummary;
}

class LocalAiService {
  LocalAiResult analyzeProfile(UserProfile profile) {
    var score = 20;
    final suggestions = <String>[];

    void reward(bool condition, int points, String suggestion) {
      if (condition) {
        score += points;
      } else {
        suggestions.add(suggestion);
      }
    }

    reward(
      profile.fullName.isNotEmpty,
      8,
      'Ajoutez votre prénom et votre nom pour que le CV soit identifiable.',
    );
    reward(
      profile.email.contains('@'),
      8,
      'Vérifiez l’email: il doit être professionnel et facile à lire.',
    );
    reward(
      profile.phone.length >= 10,
      8,
      'Ajoutez un numéro de téléphone complet pour être rappelé rapidement.',
    );
    reward(
      profile.targetJob.length >= 3,
      10,
      'Indiquez clairement le métier ou le poste recherché.',
    );
    reward(
      profile.summary.length >= 80,
      16,
      'Ajoutez un résumé de 3 à 4 phrases pour présenter votre profil.',
    );
    reward(
      profile.experiences.isNotEmpty,
      14,
      'Ajoutez au moins une expérience: emploi, stage, bénévolat ou mission.',
    );
    reward(
      profile.skills.length >= 4,
      10,
      'Ajoutez au moins 4 compétences concrètes et utiles pour le poste.',
    );
    reward(
      profile.education.isNotEmpty,
      6,
      'Ajoutez une formation, un diplôme, un permis ou une certification.',
    );

    final cappedScore = score.clamp(0, 100);
    final title = switch (cappedScore) {
      >= 80 => 'CV solide',
      >= 55 => 'Bonne base',
      >= 35 => 'À compléter',
      _ => 'Départ guidé',
    };

    return LocalAiResult(
      score: cappedScore,
      title: title,
      suggestions: suggestions.take(5).toList(),
      generatedSummary: generateProfessionalSummary(profile),
    );
  }

  String generateProfessionalSummary(UserProfile profile) {
    final job = profile.targetJob.trim().isEmpty
        ? 'le poste recherché'
        : profile.targetJob.trim();
    final skills = _joinReadable(
      profile.skills.take(3).toList(),
      fallback: 'organisation, sérieux et travail en équipe',
    );
    final experience = profile.experiences.isEmpty
        ? 'Je suis prêt(e) à apprendre rapidement et à m’impliquer dans mes missions.'
        : 'Mon parcours m’a permis de développer une expérience concrète et une bonne capacité d’adaptation.';
    final qualities = _inferQualities(profile);

    return 'Candidat(e) motivé(e), je recherche un poste de $job. '
        '$experience '
        'Je peux apporter mes compétences en $skills. '
        'Reconnu(e) pour $qualities, je souhaite m’investir dans une équipe professionnelle et contribuer efficacement aux objectifs de l’entreprise.';
  }

  List<String> smartSkillIdeas(UserProfile profile) {
    final text = [
      profile.targetJob,
      ...profile.experiences,
      ...profile.skills,
    ].join(' ').toLowerCase();

    if (_containsAny(text, ['vente', 'commerce', 'client', 'caisse'])) {
      return [
        'Accueil client',
        'Conseil et vente',
        'Encaissement',
        'Gestion des priorités',
      ];
    }
    if (_containsAny(text, ['restauration', 'cuisine', 'serveur', 'bar'])) {
      return [
        'Service client',
        'Respect des règles d’hygiène',
        'Travail en équipe',
        'Gestion du rythme',
      ];
    }
    if (_containsAny(text, [
      'administratif',
      'bureau',
      'assistant',
      'accueil',
    ])) {
      return [
        'Organisation administrative',
        'Accueil téléphonique',
        'Rédaction de documents',
        'Classement et suivi',
      ];
    }
    if (_containsAny(text, [
      'logistique',
      'stock',
      'préparateur',
      'livraison',
    ])) {
      return [
        'Préparation de commandes',
        'Rangement du stock',
        'Respect des consignes',
        'Ponctualité',
      ];
    }

    return [
      'Ponctualité',
      'Travail en équipe',
      'Autonomie',
      'Respect des consignes',
    ];
  }

  String _inferQualities(UserProfile profile) {
    final text = [
      profile.summary,
      ...profile.skills,
      ...profile.experiences,
    ].join(' ').toLowerCase();

    if (_containsAny(text, ['client', 'accueil', 'vente'])) {
      return 'mon sens du contact, mon écoute et mon sérieux';
    }
    if (_containsAny(text, ['stock', 'logistique', 'commande'])) {
      return 'ma rigueur, ma ponctualité et mon sens de l’organisation';
    }
    if (_containsAny(text, ['équipe', 'collectif', 'collaboration'])) {
      return 'mon esprit d’équipe, mon autonomie et ma fiabilité';
    }
    return 'mon sérieux, ma motivation et ma capacité d’adaptation';
  }

  String _joinReadable(List<String> values, {required String fallback}) {
    final cleanValues = values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
    if (cleanValues.isEmpty) return fallback;
    if (cleanValues.length == 1) return cleanValues.first;
    if (cleanValues.length == 2) {
      return '${cleanValues.first} et ${cleanValues.last}';
    }
    return '${cleanValues.take(cleanValues.length - 1).join(', ')} et ${cleanValues.last}';
  }

  bool _containsAny(String text, List<String> words) {
    return words.any(text.contains);
  }
}
