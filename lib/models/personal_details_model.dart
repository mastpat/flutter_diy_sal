import 'package:intl/intl.dart';

class PersonalDetailsModel {
  final int? id;
  final String employeeCode;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String gender;
  final String? email;
  final String phone;

  PersonalDetailsModel({
    this.id,
    required this.employeeCode,
    required this.firstName,
    this.lastName = '',
    required this.dob,
    required this.gender,
    this.email,
    required this.phone,
  });

  factory PersonalDetailsModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDob;
    final dobRaw = json['dob']?.toString() ?? json['date_of_birth']?.toString() ?? '';
    if (dobRaw.contains('-')) {
      // Try ISO or yyyy-MM-dd
      parsedDob = DateTime.tryParse(dobRaw) ?? DateTime.now();
    } else {
      parsedDob = DateTime.now();
    }

    return PersonalDetailsModel(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      employeeCode: json['employee_code']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      dob: parsedDob,
      gender: json['gender']?.toString() ?? 'Other',
      email: json['email']?.toString(),
      phone: json['phone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final df = DateFormat('yyyy-MM-dd');
    return {
      'id': id,
      'employee_code': employeeCode,
      'first_name': firstName,
      'last_name': lastName,
      'dob': df.format(dob),
      'gender': gender,
      'email': email,
      'phone': phone,
    };
  }

  PersonalDetailsModel copyWith({
    int? id,
    String? employeeCode,
    String? firstName,
    String? lastName,
    DateTime? dob,
    String? gender,
    String? email,
    String? phone,
  }) {
    return PersonalDetailsModel(
      id: id ?? this.id,
      employeeCode: employeeCode ?? this.employeeCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final re = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return re.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final re = RegExp(r'^\d{10}$');
    return re.hasMatch(phone);
  }

  static bool isAdult(DateTime dob) {
    final now = DateTime.now();
    final age = now.year - dob.year - ((now.month < dob.month || (now.month == dob.month && now.day < dob.day)) ? 1 : 0);
    return age >= 18;
  }
}
