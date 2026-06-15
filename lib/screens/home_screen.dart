import 'package:flutter/material.dart';

import '../widgets/app_action_card.dart';
import 'applications_screen.dart';
import 'cv_builder_screen.dart';
import 'cv_help_screen.dart';
import 'messages_screen.dart';
import 'motivation_letter_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JobCraft CV')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Bonjour, prêt à créer une candidature claire et professionnelle ?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Tous vos documents restent stockés localement sur votre appareil.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CvHelpScreen()),
              ),
              icon: const Icon(Icons.school_outlined),
              label: const Text('Mode d’emploi CV'),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final useGrid = constraints.maxWidth > 620;
                final cards = [
                  AppActionCard(
                    title: 'Créer mon CV',
                    subtitle: 'Profil, modèles et export PDF',
                    icon: Icons.description_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CvBuilderScreen(),
                      ),
                    ),
                  ),
                  AppActionCard(
                    title: 'Lettre de motivation',
                    subtitle: 'Génération locale et modification',
                    icon: Icons.edit_note_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MotivationLetterScreen(),
                      ),
                    ),
                  ),
                  AppActionCard(
                    title: 'Messages de candidature',
                    subtitle: 'Email, LinkedIn, relance, entretien',
                    icon: Icons.mark_email_read_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MessagesScreen()),
                    ),
                  ),
                  AppActionCard(
                    title: 'Mes candidatures',
                    subtitle: 'Statut, dates et notes personnelles',
                    icon: Icons.work_outline,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ApplicationsScreen(),
                      ),
                    ),
                  ),
                ];

                if (!useGrid) {
                  return Column(
                    children: cards
                        .map(
                          (card) => SizedBox(
                            height: 156,
                            width: double.infinity,
                            child: card,
                          ),
                        )
                        .toList(),
                  );
                }

                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: cards,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
