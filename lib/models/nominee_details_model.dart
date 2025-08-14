import 'nominee_model.dart';

class NomineeDetailsModel {
  final String employeeCode;
  final List<NomineeModel> nominees;

  NomineeDetailsModel({
    required this.employeeCode,
    required this.nominees,
  });

  factory NomineeDetailsModel.fromJson(Map<String, dynamic> json) {
    final nRaw = json['nominees'] as List<dynamic>? ?? json['nominee'] as List<dynamic>? ?? [];
    final list = nRaw.map((n) {
      if (n is Map<String, dynamic>) return NomineeModel.fromJson(n);
      return NomineeModel.fromJson(Map<String, dynamic>.from(n as Map));
    }).toList();
    return NomineeDetailsModel(employeeCode: json['employee_code']?.toString() ?? '', nominees: list);
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_code': employeeCode,
      'nominees': nominees.map((n) => n.toJson()).toList(),
    };
  }

  /// Validates that if there are multiple nominees the total share equals 100.0
  bool validateTotalPercentage({double epsilon = 0.01}) {
    if (nominees.isEmpty) return false;
    final total = nominees.fold<double>(0.0, (sum, n) => sum + n.sharePercentage);
    if (nominees.length == 1) {
      final s = nominees.first.sharePercentage;
      return s > 0 && s <= 100;
    }
    return (total - 100.0).abs() <= epsilon;
  }
}
