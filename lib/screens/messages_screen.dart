import 'package:flutter/material.dart';

import '../models/document_models.dart';
import '../models/user_profile.dart';
import '../services/hive_storage_service.dart';
import '../services/text_generator_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/form_section.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _storage = HiveStorageService.instance;
  final _generator = TextGeneratorService();

  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _messageController = TextEditingController();

  MessageType _type = MessageType.applicationEmail;
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = _storage.getProfile();
    _positionController.text = _profile.targetJob;
    _messageController.text = _storage.getMessage();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages de candidature')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FormSection(
              title: 'Type de message',
              children: [
                DropdownButtonFormField<MessageType>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    labelText: 'Message à générer',
                    prefixIcon: Icon(Icons.chat_bubble_outline),
                  ),
                  items: MessageType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.label),
                        ),
                      )
                      .toList(),
                  onChanged: (type) => setState(() => _type = type ?? _type),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _companyController,
                  label: 'Nom de l’entreprise',
                  icon: Icons.business_outlined,
                ),
                AppTextField(
                  controller: _positionController,
                  label: 'Poste concerné',
                  icon: Icons.work_outline,
                ),
              ],
            ),
            FilledButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.auto_awesome_outlined),
              label: const Text('Générer le texte'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 14,
              decoration: const InputDecoration(
                labelText: 'Texte généré et modifiable',
                alignLabelWithHint: true,
              ),
              onChanged: _storage.saveMessage,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    final message = _generator.generateMessage(
      type: _type,
      profile: _profile,
      companyName: _companyController.text,
      position: _positionController.text,
    );
    _messageController.text = message;
    await _storage.saveMessage(message);
    setState(() {});
  }
}
