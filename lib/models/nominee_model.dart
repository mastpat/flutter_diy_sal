class NomineeModel {
  final int? id;
  late final String name;
  late final String relation;
  late final int age;
  late final double sharePercentage;

  NomineeModel({
    this.id,
    required this.name,
    required this.relation,
    required this.age,
    required this.sharePercentage,
  });

  factory NomineeModel.fromJson(Map<String, dynamic> json) {
    return NomineeModel(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      name: json['name']?.toString() ?? '',
      relation: json['relation']?.toString() ?? '',
      age: json['age'] is int ? json['age'] : (json['age'] != null ? int.tryParse(json['age'].toString()) ?? 0 : 0),
      sharePercentage: json['share_percentage'] is num ? (json['share_percentage'] as num).toDouble() : (json['sharePercentage'] is num ? (json['sharePercentage'] as num).toDouble() : double.tryParse(json['share_percentage']?.toString() ?? '0') ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'age': age,
      'share_percentage': sharePercentage,
    };
  }

  bool isValid() {
    return name.trim().isNotEmpty && age > 0 && sharePercentage > 0 && sharePercentage <= 100;
  }
}
