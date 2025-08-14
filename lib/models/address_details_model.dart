class AddressDetailsModel {
  final int? id;
  final String employeeCode;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String district;
  final String pincode;
  final String? landmark;

  AddressDetailsModel({
    this.id,
    required this.employeeCode,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.district,
    required this.pincode,
    this.landmark,
  });

  factory AddressDetailsModel.fromJson(Map<String, dynamic> json) {
    return AddressDetailsModel(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      employeeCode: json['employee_code']?.toString() ?? '',
      addressLine1: json['address1']?.toString() ?? json['address_line1']?.toString() ?? '',
      addressLine2: json['address2']?.toString(),
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      landmark: json['landmark']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_code': employeeCode,
      'address1': addressLine1,
      'address2': addressLine2,
      'city': city,
      'state': state,
      'district': district,
      'pincode': pincode,
      'landmark': landmark,
    };
  }

  static bool isValidPincode(String pincode) {
    final re = RegExp(r'^\d{6}$');
    return re.hasMatch(pincode);
  }
}
