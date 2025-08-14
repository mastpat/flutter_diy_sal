class MainModel {
  final int? id;
  final String? employeeCode;
  final bool onboardingCompleted;
  final DateTime? createdAt;

  MainModel({
    this.id,
    this.employeeCode,
    this.onboardingCompleted = false,
    this.createdAt,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      employeeCode: json['employee_code']?.toString(),
      onboardingCompleted: (json['onboarding_completed'] == 1 || json['onboarding_completed'] == true),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employee_code': employeeCode,
        'onboarding_completed': onboardingCompleted ? 1 : 0,
        'created_at': createdAt?.toIso8601String(),
      };

  MainModel copyWith({
    int? id,
    String? employeeCode,
    bool? onboardingCompleted,
    DateTime? createdAt,
  }) {
    return MainModel(
      id: id ?? this.id,
      employeeCode: employeeCode ?? this.employeeCode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool isValid() {
    return (employeeCode != null && employeeCode!.isNotEmpty);
  }
}
