import 'package:hive_flutter/hive_flutter.dart';

import '../models/job_application.dart';
import '../models/user_profile.dart';

class HiveStorageService {
  HiveStorageService._();

  static final HiveStorageService instance = HiveStorageService._();

  static const _boxName = 'jobcraft_cv';
  static const _profileKey = 'profile';
  static const _letterKey = 'motivation_letter';
  static const _messageKey = 'generated_message';
  static const _applicationsKey = 'applications';

  late final Box<dynamic> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  UserProfile getProfile() {
    return UserProfile.fromMap(_box.get(_profileKey));
  }

  Future<void> saveProfile(UserProfile profile) {
    return _box.put(_profileKey, profile.toMap());
  }

  String getLetter() {
    return _box.get(_letterKey, defaultValue: '') as String;
  }

  Future<void> saveLetter(String letter) {
    return _box.put(_letterKey, letter);
  }

  String getMessage() {
    return _box.get(_messageKey, defaultValue: '') as String;
  }

  Future<void> saveMessage(String message) {
    return _box.put(_messageKey, message);
  }

  List<JobApplication> getApplications() {
    final rawItems = List<dynamic>.from(
      _box.get(_applicationsKey, defaultValue: const <dynamic>[]),
    );
    return rawItems
        .map((item) => JobApplication.fromMap(Map<dynamic, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveApplications(List<JobApplication> applications) {
    return _box.put(
      _applicationsKey,
      applications.map((application) => application.toMap()).toList(),
    );
  }
}
