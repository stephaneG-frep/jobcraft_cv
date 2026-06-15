enum CvTemplate {
  classic('Classique'),
  modern('Moderne'),
  creative('Créatif');

  const CvTemplate(this.label);

  final String label;
}

enum LetterTone {
  formal('Formel'),
  natural('Naturel'),
  dynamic('Dynamique');

  const LetterTone(this.label);

  final String label;
}

enum MessageType {
  applicationEmail('Email de candidature'),
  linkedIn('Message LinkedIn'),
  followUp('Relance après candidature'),
  thankYou('Remerciement après entretien'),
  spontaneous('Candidature spontanée');

  const MessageType(this.label);

  final String label;
}
