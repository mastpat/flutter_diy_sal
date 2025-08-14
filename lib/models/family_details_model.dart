import 'family_member_model.dart';

class FamilyDetailsModel {
  final String employeeCode;
  final List<FamilyMemberModel> members;

  FamilyDetailsModel({
    required this.employeeCode,
    required this.members,
  });

  factory FamilyDetailsModel.fromJson(Map<String, dynamic> json) {
    final membersRaw = json['members'] as List<dynamic>? ?? [];
    final members = membersRaw.map((m) {
      if (m is Map<String, dynamic>) return FamilyMemberModel.fromJson(m);
      return FamilyMemberModel.fromJson(Map<String, dynamic>.from(m as Map));
    }).toList();
    return FamilyDetailsModel(employeeCode: json['employee_code']?.toString() ?? '', members: members);
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_code': employeeCode,
      'members': members.map((m) => m.toJson()).toList(),
    };
  }

  int count() => members.length;

  bool validate() {
    for (final m in members) {
      if (!m.isValid()) return false;
    }
    return true;
  }
}
