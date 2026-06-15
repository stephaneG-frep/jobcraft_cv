class UserProfile {
  const UserProfile({
    this.lastName = '',
    this.firstName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.targetJob = '',
    this.summary = '',
    this.experiences = const [],
    this.education = const [],
    this.skills = const [],
    this.languages = const [],
    this.interests = const [],
  });

  final String lastName;
  final String firstName;
  final String email;
  final String phone;
  final String address;
  final String targetJob;
  final String summary;
  final List<String> experiences;
  final List<String> education;
  final List<String> skills;
  final List<String> languages;
  final List<String> interests;

  String get fullName => '$firstName $lastName'.trim();

  UserProfile copyWith({
    String? lastName,
    String? firstName,
    String? email,
    String? phone,
    String? address,
    String? targetJob,
    String? summary,
    List<String>? experiences,
    List<String>? education,
    List<String>? skills,
    List<String>? languages,
    List<String>? interests,
  }) {
    return UserProfile(
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      targetJob: targetJob ?? this.targetJob,
      summary: summary ?? this.summary,
      experiences: experiences ?? this.experiences,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      interests: interests ?? this.interests,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'phone': phone,
      'address': address,
      'targetJob': targetJob,
      'summary': summary,
      'experiences': experiences,
      'education': education,
      'skills': skills,
      'languages': languages,
      'interests': interests,
    };
  }

  factory UserProfile.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const UserProfile();

    List<String> readList(String key) {
      return List<String>.from(map[key] ?? const <String>[]);
    }

    return UserProfile(
      lastName: map['lastName'] ?? '',
      firstName: map['firstName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      targetJob: map['targetJob'] ?? '',
      summary: map['summary'] ?? '',
      experiences: readList('experiences'),
      education: readList('education'),
      skills: readList('skills'),
      languages: readList('languages'),
      interests: readList('interests'),
    );
  }
}
