import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/local_ai_service.dart';

class AiAssistantCard extends StatelessWidget {
  const AiAssistantCard({
    super.key,
    required this.profile,
    required this.onApplySummary,
    required this.onAddSkills,
  });

  final UserProfile profile;
  final ValueChanged<String> onApplySummary;
  final ValueChanged<List<String>> onAddSkills;

  @override
  Widget build(BuildContext context) {
    final service = LocalAiService();
    final result = service.analyzeProfile(profile);
    final skillIdeas = service.smartSkillIdeas(profile);
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.secondaryContainer,
                  foregroundColor: colors.onSecondaryContainer,
                  child: const Icon(Icons.auto_awesome_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assistant IA local',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text('${result.title} • score ${result.score}/100'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: result.score / 100,
                minHeight: 9,
                backgroundColor: colors.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 16),
            if (result.suggestions.isEmpty)
              const Text(
                'Votre CV contient déjà les informations essentielles.',
              )
            else
              ...result.suggestions.map(
                (suggestion) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.tips_and_updates_outlined,
                        size: 18,
                        color: colors.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(suggestion)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Résumé proposé',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            SelectableText(result.generatedSummary),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => onApplySummary(result.generatedSummary),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Utiliser ce résumé'),
                ),
                OutlinedButton.icon(
                  onPressed: () => onAddSkills(skillIdeas),
                  icon: const Icon(Icons.add_task_outlined),
                  label: const Text('Ajouter des compétences'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
