import 'package:intl/intl.dart';

enum ApplicationStatus {
  toSend('à envoyer'),
  sent('envoyée'),
  followUp('relance'),
  interview('entretien'),
  rejected('refus'),
  accepted('accepté');

  const ApplicationStatus(this.label);

  final String label;

  static ApplicationStatus fromName(String name) {
    return ApplicationStatus.values.firstWhere(
      (status) => status.name == name,
      orElse: () => ApplicationStatus.toSend,
    );
  }
}

class JobApplication {
  const JobApplication({
    required this.id,
    required this.companyName,
    required this.position,
    required this.sentDate,
    required this.status,
    this.notes = '',
  });

  final String id;
  final String companyName;
  final String position;
  final DateTime sentDate;
  final ApplicationStatus status;
  final String notes;

  String get formattedDate => DateFormat('dd/MM/yyyy').format(sentDate);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'position': position,
      'sentDate': sentDate.toIso8601String(),
      'status': status.name,
      'notes': notes,
    };
  }

  factory JobApplication.fromMap(Map<dynamic, dynamic> map) {
    return JobApplication(
      id: map['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
      companyName: map['companyName'] ?? '',
      position: map['position'] ?? '',
      sentDate: DateTime.tryParse(map['sentDate'] ?? '') ?? DateTime.now(),
      status: ApplicationStatus.fromName(map['status'] ?? ''),
      notes: map['notes'] ?? '',
    );
  }
}
