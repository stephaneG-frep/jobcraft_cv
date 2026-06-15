import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/job_application.dart';
import '../services/hive_storage_service.dart';
import '../widgets/app_text_field.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  final _storage = HiveStorageService.instance;
  late List<JobApplication> _applications;

  @override
  void initState() {
    super.initState();
    _applications = _storage.getApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes candidatures')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openApplicationForm(),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: SafeArea(
        child: _applications.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Aucune candidature enregistrée pour le moment.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: _applications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final application = _applications[index];
                  return Card(
                    child: ListTile(
                      onTap: () =>
                          _openApplicationForm(application: application),
                      leading: CircleAvatar(
                        child: Text(
                          application.companyName.characters.firstOrNull
                                  ?.toUpperCase() ??
                              '?',
                        ),
                      ),
                      title: Text(application.companyName),
                      subtitle: Text(
                        '${application.position}\nEnvoyée le ${application.formattedDate}',
                      ),
                      isThreeLine: true,
                      trailing: Chip(label: Text(application.status.label)),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _openApplicationForm({JobApplication? application}) async {
    final companyController = TextEditingController(
      text: application?.companyName ?? '',
    );
    final positionController = TextEditingController(
      text: application?.position ?? '',
    );
    final notesController = TextEditingController(
      text: application?.notes ?? '',
    );
    var selectedDate = application?.sentDate ?? DateTime.now();
    var selectedStatus = application?.status ?? ApplicationStatus.toSend;

    final saved = await showModalBottomSheet<JobApplication>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 18,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      application == null
                          ? 'Nouvelle candidature'
                          : 'Modifier la candidature',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: companyController,
                      label: 'Nom entreprise',
                      icon: Icons.business_outlined,
                    ),
                    AppTextField(
                      controller: positionController,
                      label: 'Poste',
                      icon: Icons.work_outline,
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setSheetState(() => selectedDate = date);
                        }
                      },
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text(
                        'Date d’envoi : ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ApplicationStatus>(
                      initialValue: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Statut',
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      items: ApplicationStatus.values
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.label),
                            ),
                          )
                          .toList(),
                      onChanged: (status) => setSheetState(
                        () => selectedStatus = status ?? selectedStatus,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: notesController,
                      label: 'Notes personnelles',
                      maxLines: 4,
                    ),
                    Row(
                      children: [
                        if (application != null)
                          IconButton(
                            tooltip: 'Supprimer',
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteApplication(application);
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              JobApplication(
                                id:
                                    application?.id ??
                                    DateTime.now().microsecondsSinceEpoch
                                        .toString(),
                                companyName: companyController.text.trim(),
                                position: positionController.text.trim(),
                                sentDate: selectedDate,
                                status: selectedStatus,
                                notes: notesController.text.trim(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Enregistrer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    companyController.dispose();
    positionController.dispose();
    notesController.dispose();

    if (saved == null || saved.companyName.isEmpty || saved.position.isEmpty) {
      return;
    }

    setState(() {
      final index = _applications.indexWhere((item) => item.id == saved.id);
      if (index == -1) {
        _applications = [..._applications, saved];
      } else {
        _applications[index] = saved;
      }
      _applications.sort((a, b) => b.sentDate.compareTo(a.sentDate));
    });
    await _storage.saveApplications(_applications);
  }

  Future<void> _deleteApplication(JobApplication application) async {
    setState(
      () => _applications = _applications
          .where((item) => item.id != application.id)
          .toList(),
    );
    await _storage.saveApplications(_applications);
  }
}
