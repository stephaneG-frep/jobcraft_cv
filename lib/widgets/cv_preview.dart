import 'package:flutter/material.dart';

import '../models/document_models.dart';
import '../models/user_profile.dart';

class CvPreview extends StatelessWidget {
  const CvPreview({super.key, required this.profile, required this.template});

  final UserProfile profile;
  final CvTemplate template;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = switch (template) {
      CvTemplate.classic => colors.primary,
      CvTemplate.modern => colors.secondary,
      CvTemplate.creative => colors.tertiary,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: template == CvTemplate.classic
                    ? Colors.transparent
                    : accent.withValues(
                        alpha: Theme.of(context).brightness == Brightness.dark
                            ? 0.13
                            : 0.08,
                      ),
                border: Border(
                  left: BorderSide(
                    color: accent,
                    width: template == CvTemplate.classic ? 0 : 4,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  template == CvTemplate.classic ? 0 : 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName.isEmpty ? 'Votre nom' : profile.fullName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.targetJob.isEmpty
                          ? 'Métier recherché'
                          : profile.targetJob,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      [
                        profile.email,
                        profile.phone,
                        profile.address,
                      ].where((item) => item.isNotEmpty).join(' • '),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _PreviewSection(
              title: 'Résumé',
              items: [profile.summary],
              accent: accent,
            ),
            _PreviewSection(
              title: 'Expériences',
              items: profile.experiences,
              accent: accent,
            ),
            _PreviewSection(
              title: 'Formations',
              items: profile.education,
              accent: accent,
            ),
            _PreviewSection(
              title: 'Compétences',
              items: profile.skills,
              accent: accent,
              chips: true,
            ),
            _PreviewSection(
              title: 'Langues',
              items: profile.languages,
              accent: accent,
              chips: true,
            ),
            _PreviewSection(
              title: 'Centres d’intérêt',
              items: profile.interests,
              accent: accent,
              chips: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({
    required this.title,
    required this.items,
    required this.accent,
    this.chips = false,
  });

  final String title;
  final List<String> items;
  final Color accent;
  final bool chips;

  @override
  Widget build(BuildContext context) {
    final cleanItems = items.where((item) => item.trim().isNotEmpty).toList();
    if (cleanItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          if (chips)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: cleanItems
                  .map((item) => Chip(label: Text(item)))
                  .toList(),
            )
          else
            ...cleanItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(item),
              ),
            ),
        ],
      ),
    );
  }
}
