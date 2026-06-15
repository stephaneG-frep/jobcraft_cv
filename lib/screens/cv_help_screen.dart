import 'package:flutter/material.dart';

class CvHelpScreen extends StatelessWidget {
  const CvHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mode d’emploi CV')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _IntroCard(),
            _HelpSection(
              title: '1. Commence simple',
              icon: Icons.flag_outlined,
              lines: [
                'Un CV sert à montrer rapidement qui vous êtes, ce que vous savez faire et le poste que vous cherchez.',
                'Il n’a pas besoin d’être parfait dès le début. Remplissez d’abord les champs avec des phrases simples.',
              ],
            ),
            _HelpSection(
              title: '2. Résumé professionnel',
              icon: Icons.notes_outlined,
              lines: [
                'Écrivez 3 ou 4 phrases courtes.',
                'Dites votre métier ou votre objectif, vos qualités principales et ce que vous pouvez apporter.',
                'Exemple : “Candidat sérieux et motivé, je recherche un poste dans la vente. J’aime le contact client, le travail en équipe et les missions bien organisées.”',
              ],
            ),
            _HelpSection(
              title: '3. Expériences',
              icon: Icons.work_outline,
              lines: [
                'Indiquez les emplois, stages, missions, bénévolat ou périodes d’aide familiale utiles.',
                'Pour chaque ligne, notez : poste, entreprise, dates, puis 1 ou 2 actions réalisées.',
                'Exemple : “Employé polyvalent - Supermarché ABC - 2024 : mise en rayon, accueil client, rangement du stock.”',
              ],
            ),
            _HelpSection(
              title: '4. Formations',
              icon: Icons.school_outlined,
              lines: [
                'Ajoutez vos diplômes, formations, permis, certificats ou formations courtes.',
                'Si vous n’avez pas beaucoup de diplômes, ce n’est pas grave : mettez ce qui aide à comprendre votre parcours.',
              ],
            ),
            _HelpSection(
              title: '5. Compétences',
              icon: Icons.build_outlined,
              lines: [
                'Mettez des compétences concrètes : accueil client, caisse, nettoyage, Word, Excel, conduite, organisation, ponctualité.',
                'Évitez les mots trop vagues seuls comme “motivé”. Préférez “travail en équipe”, “respect des consignes”, “gestion du temps”.',
              ],
            ),
            _HelpSection(
              title: '6. À éviter',
              icon: Icons.warning_amber_outlined,
              lines: [
                'Ne mentez pas sur une expérience ou un diplôme.',
                'Évitez les phrases trop longues.',
                'Relisez les fautes, surtout le téléphone et l’email.',
                'Gardez un CV clair : une page suffit souvent.',
              ],
            ),
            _ExampleCard(),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              'Pas besoin d’être expert',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ce guide vous aide à remplir votre CV étape par étape avec des mots simples. L’objectif est d’être clair, honnête et facile à comprendre.',
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection({
    required this.title,
    required this.icon,
    required this.lines,
  });

  final String title;
  final IconData icon;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(line),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phrase prête à adapter',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const SelectableText(
              'Je suis une personne sérieuse, ponctuelle et motivée. Je recherche un poste de [métier] afin de mettre à profit mes compétences en [compétence 1], [compétence 2] et [compétence 3]. J’apprends rapidement et je souhaite m’investir dans une équipe professionnelle.',
            ),
          ],
        ),
      ),
    );
  }
}
