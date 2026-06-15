import 'package:flutter/material.dart';

import '../models/document_models.dart';
import '../models/user_profile.dart';
import '../services/hive_storage_service.dart';
import '../services/pdf_export_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/cv_preview.dart';
import '../widgets/form_section.dart';
import 'cv_help_screen.dart';

class CvBuilderScreen extends StatefulWidget {
  const CvBuilderScreen({super.key});

  @override
  State<CvBuilderScreen> createState() => _CvBuilderScreenState();
}

class _CvBuilderScreenState extends State<CvBuilderScreen> {
  final _storage = HiveStorageService.instance;
  final _pdfService = PdfExportService();

  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _targetJobController = TextEditingController();
  final _summaryController = TextEditingController();
  final _experiencesController = TextEditingController();
  final _educationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _languagesController = TextEditingController();
  final _interestsController = TextEditingController();

  CvTemplate _template = CvTemplate.classic;

  @override
  void initState() {
    super.initState();
    _fillControllers(_storage.getProfile());
  }

  @override
  void dispose() {
    for (final controller in [
      _lastNameController,
      _firstNameController,
      _emailController,
      _phoneController,
      _addressController,
      _targetJobController,
      _summaryController,
      _experiencesController,
      _educationController,
      _skillsController,
      _languagesController,
      _interestsController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = _readProfile();

    return Scaffold(
      appBar: AppBar(title: const Text('Créer mon CV')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Besoin d’aide pour remplir le CV ?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Un guide simple explique quoi écrire dans chaque partie, avec des exemples prêts à adapter.',
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CvHelpScreen()),
                      ),
                      icon: const Icon(Icons.school_outlined),
                      label: const Text('Ouvrir le mode d’emploi'),
                    ),
                  ],
                ),
              ),
            ),
            FormSection(
              title: 'Profil utilisateur',
              children: [
                AppTextField(
                  controller: _firstNameController,
                  label: 'Prénom',
                  icon: Icons.person_outline,
                ),
                AppTextField(
                  controller: _lastNameController,
                  label: 'Nom',
                  icon: Icons.badge_outlined,
                ),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                ),
                AppTextField(
                  controller: _phoneController,
                  label: 'Téléphone',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                AppTextField(
                  controller: _addressController,
                  label: 'Adresse',
                  icon: Icons.place_outlined,
                ),
                AppTextField(
                  controller: _targetJobController,
                  label: 'Métier recherché',
                  icon: Icons.work_outline,
                ),
                AppTextField(
                  controller: _summaryController,
                  label: 'Résumé professionnel',
                  icon: Icons.notes_outlined,
                  maxLines: 4,
                ),
              ],
            ),
            FormSection(
              title: 'Parcours et compétences',
              children: [
                AppTextField(
                  controller: _experiencesController,
                  label: 'Expériences professionnelles',
                  hint: 'Une expérience par ligne',
                  maxLines: 5,
                ),
                AppTextField(
                  controller: _educationController,
                  label: 'Formations',
                  hint: 'Une formation par ligne',
                  maxLines: 4,
                ),
                AppTextField(
                  controller: _skillsController,
                  label: 'Compétences',
                  hint: 'Une compétence par ligne',
                  maxLines: 4,
                ),
                AppTextField(
                  controller: _languagesController,
                  label: 'Langues',
                  hint: 'Une langue par ligne',
                  maxLines: 3,
                ),
                AppTextField(
                  controller: _interestsController,
                  label: 'Centres d’intérêt',
                  hint: 'Un centre d’intérêt par ligne',
                  maxLines: 3,
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Modèle de CV',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<CvTemplate>(
                      segments: CvTemplate.values
                          .map(
                            (template) => ButtonSegment(
                              value: template,
                              label: Text(template.label),
                            ),
                          )
                          .toList(),
                      selected: {_template},
                      onSelectionChanged: (selection) =>
                          setState(() => _template = selection.first),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Enregistrer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _exportPdf(profile),
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Exporter PDF'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Aperçu du CV',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            CvPreview(profile: profile, template: _template),
          ],
        ),
      ),
    );
  }

  void _fillControllers(UserProfile profile) {
    _lastNameController.text = profile.lastName;
    _firstNameController.text = profile.firstName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _addressController.text = profile.address;
    _targetJobController.text = profile.targetJob;
    _summaryController.text = profile.summary;
    _experiencesController.text = profile.experiences.join('\n');
    _educationController.text = profile.education.join('\n');
    _skillsController.text = profile.skills.join('\n');
    _languagesController.text = profile.languages.join('\n');
    _interestsController.text = profile.interests.join('\n');
  }

  UserProfile _readProfile() {
    return UserProfile(
      lastName: _lastNameController.text.trim(),
      firstName: _firstNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      targetJob: _targetJobController.text.trim(),
      summary: _summaryController.text.trim(),
      experiences: _lines(_experiencesController.text),
      education: _lines(_educationController.text),
      skills: _lines(_skillsController.text),
      languages: _lines(_languagesController.text),
      interests: _lines(_interestsController.text),
    );
  }

  List<String> _lines(String value) {
    return value
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  Future<void> _saveProfile() async {
    await _storage.saveProfile(_readProfile());
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil enregistré localement.')),
    );
  }

  Future<void> _exportPdf(UserProfile profile) async {
    await _storage.saveProfile(profile);
    await _pdfService.exportCv(profile: profile, template: _template);
  }
}
