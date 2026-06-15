import '../models/document_models.dart';
import '../models/user_profile.dart';

class TextGeneratorService {
  String generateLetter({
    required UserProfile profile,
    required String companyName,
    required String position,
    required String jobOffer,
    required LetterTone tone,
  }) {
    final company = companyName.trim().isEmpty
        ? 'votre entreprise'
        : companyName.trim();
    final job = position.trim().isEmpty ? profile.targetJob : position.trim();
    final intro = switch (tone) {
      LetterTone.formal => 'Madame, Monsieur,',
      LetterTone.natural => 'Bonjour,',
      LetterTone.dynamic => 'Bonjour,',
    };
    final energy = switch (tone) {
      LetterTone.formal => 'Je souhaite vous soumettre ma candidature',
      LetterTone.natural =>
        'Je vous adresse ma candidature avec beaucoup d’intérêt',
      LetterTone.dynamic =>
        'Je suis très motivé(e) à l’idée de rejoindre vos équipes',
    };
    final offerSentence = jobOffer.trim().isEmpty
        ? 'Votre environnement et vos enjeux correspondent à mon projet professionnel.'
        : 'Votre offre met en avant des besoins auxquels je peux répondre avec sérieux et méthode.';

    return '''
$intro

$energy pour le poste de $job au sein de $company. ${profile.summary.isEmpty ? 'Mon parcours m’a permis de développer une approche fiable, organisée et orientée résultats.' : profile.summary}

$offerSentence Mes expériences m’ont permis de renforcer mes compétences en ${profile.skills.take(4).join(', ').ifEmpty('organisation, communication et autonomie')}.

Je serais heureux(se) d’échanger avec vous afin de vous présenter plus précisément ma motivation et la manière dont je pourrais contribuer à vos objectifs.

Je vous remercie pour l’attention portée à ma candidature.

Cordialement,
${profile.fullName.ifEmpty('Votre nom')}
''';
  }

  String generateMessage({
    required MessageType type,
    required UserProfile profile,
    required String companyName,
    required String position,
  }) {
    final company = companyName.trim().isEmpty
        ? 'votre entreprise'
        : companyName.trim();
    final job = position.trim().isEmpty
        ? profile.targetJob.ifEmpty('le poste proposé')
        : position.trim();
    final name = profile.fullName.ifEmpty('Votre nom');

    return switch (type) {
      MessageType.applicationEmail =>
        '''
Objet : Candidature au poste de $job

Bonjour,

Je vous adresse ma candidature pour le poste de $job au sein de $company. Mon profil correspond aux missions proposées et je serais ravi(e) de pouvoir échanger avec vous.

Vous trouverez mon CV en pièce jointe.

Cordialement,
$name
''',
      MessageType.linkedIn =>
        '''
Bonjour,

Je me permets de vous contacter au sujet du poste de $job chez $company. Votre activité m’intéresse beaucoup et je serais heureux(se) d’échanger quelques minutes avec vous sur cette opportunité.

Bonne journée,
$name
''',
      MessageType.followUp =>
        '''
Bonjour,

Je me permets de revenir vers vous concernant ma candidature au poste de $job chez $company. Je reste très intéressé(e) par cette opportunité et disponible pour un échange.

Cordialement,
$name
''',
      MessageType.thankYou =>
        '''
Bonjour,

Je vous remercie pour notre échange concernant le poste de $job. Il a renforcé mon intérêt pour $company et pour les missions présentées.

Je reste à votre disposition pour toute information complémentaire.

Cordialement,
$name
''',
      MessageType.spontaneous =>
        '''
Objet : Candidature spontanée - $job

Bonjour,

Je souhaite vous proposer ma candidature spontanée pour rejoindre $company. Mon expérience et mes compétences en ${profile.skills.take(3).join(', ').ifEmpty('organisation, communication et polyvalence')} pourraient être utiles à vos équipes.

Je serais ravi(e) d’échanger avec vous sur vos besoins actuels ou futurs.

Cordialement,
$name
''',
    };
  }
}

extension _TextFallback on String {
  String ifEmpty(String fallback) => trim().isEmpty ? fallback : this;
}
