import 'package:flutter_test/flutter_test.dart';

import 'package:jobcraft_cv/main.dart';
import 'package:jobcraft_cv/models/user_profile.dart';
import 'package:jobcraft_cv/services/local_ai_service.dart';

void main() {
  testWidgets('JobCraft CV affiche les accès principaux', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JobCraftApp());

    expect(find.text('JobCraft CV'), findsOneWidget);
    expect(find.text('Mode d’emploi CV'), findsOneWidget);
    expect(find.text('Créer mon CV'), findsOneWidget);
    expect(find.text('Lettre de motivation'), findsOneWidget);
    expect(find.text('Messages de candidature'), findsOneWidget);
    expect(find.text('Mes candidatures'), findsOneWidget);
  });

  test('L’assistant IA local propose un résumé', () {
    final service = LocalAiService();
    final result = service.analyzeProfile(
      const UserProfile(
        firstName: 'Samira',
        lastName: 'Martin',
        targetJob: 'vendeuse',
        skills: ['Accueil client', 'Caisse', 'Organisation'],
      ),
    );

    expect(result.generatedSummary, contains('vendeuse'));
    expect(result.suggestions, isNotEmpty);
  });
}
