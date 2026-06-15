import 'package:flutter_test/flutter_test.dart';

import 'package:jobcraft_cv/main.dart';

void main() {
  testWidgets('JobCraft CV affiche les accès principaux', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JobCraftApp());

    expect(find.text('JobCraft CV'), findsOneWidget);
    expect(find.text('Créer mon CV'), findsOneWidget);
    expect(find.text('Lettre de motivation'), findsOneWidget);
    expect(find.text('Messages de candidature'), findsOneWidget);
    expect(find.text('Mes candidatures'), findsOneWidget);
  });
}
