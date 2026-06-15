import 'package:flutter/material.dart';

import '../models/document_models.dart';
import '../models/user_profile.dart';
import '../services/hive_storage_service.dart';
import '../services/pdf_export_service.dart';
import '../services/text_generator_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/form_section.dart';

class MotivationLetterScreen extends StatefulWidget {
  const MotivationLetterScreen({super.key});

  @override
  State<MotivationLetterScreen> createState() => _MotivationLetterScreenState();
}

class _MotivationLetterScreenState extends State<MotivationLetterScreen> {
  final _storage = HiveStorageService.instance;
  final _generator = TextGeneratorService();
  final _pdfService = PdfExportService();

  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _offerController = TextEditingController();
  final _letterController = TextEditingController();

  LetterTone _tone = LetterTone.formal;
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = _storage.getProfile();
    _positionController.text = _profile.targetJob;
    _letterController.text = _storage.getLetter();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _offerController.dispose();
    _letterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lettre de motivation')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FormSection(
              title: 'Informations de l’offre',
              children: [
                AppTextField(
                  controller: _companyController,
                  label: 'Nom de l’entreprise',
                  icon: Icons.business_outlined,
                ),
                AppTextField(
                  controller: _positionController,
                  label: 'Poste recherché',
                  icon: Icons.work_outline,
                ),
                AppTextField(
                  controller: _offerController,
                  label: 'Offre d’emploi copiée/collée',
                  maxLines: 5,
                ),
                DropdownButtonFormField<LetterTone>(
                  initialValue: _tone,
                  decoration: const InputDecoration(
                    labelText: 'Ton souhaité',
                    prefixIcon: Icon(Icons.record_voice_over_outlined),
                  ),
                  items: LetterTone.values
                      .map(
                        (tone) => DropdownMenuItem(
                          value: tone,
                          child: Text(tone.label),
                        ),
                      )
                      .toList(),
                  onChanged: (tone) => setState(() => _tone = tone ?? _tone),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.auto_awesome_outlined),
                    label: const Text('Générer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportPdf,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Exporter PDF'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _letterController,
              maxLines: 18,
              decoration: const InputDecoration(
                labelText: 'Lettre modifiable',
                alignLabelWithHint: true,
              ),
              onChanged: _storage.saveLetter,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    final letter = _generator.generateLetter(
      profile: _profile,
      companyName: _companyController.text,
      position: _positionController.text,
      jobOffer: _offerController.text,
      tone: _tone,
    );
    _letterController.text = letter;
    await _storage.saveLetter(letter);
    setState(() {});
  }

  Future<void> _exportPdf() async {
    await _storage.saveLetter(_letterController.text);
    await _pdfService.exportLetter(
      letter: _letterController.text,
      profile: _profile,
    );
  }
}
