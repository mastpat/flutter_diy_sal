class FamilyMemberModel {
  final int? id;
  late final String name;
  late final String relation;
  late final int age;
  late final String? occupation;

  FamilyMemberModel({
    this.id,
    required this.name,
    required this.relation,
    required this.age,
    this.occupation,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      name: json['name']?.toString() ?? '',
      relation: json['relation']?.toString() ?? '',
      age: json['age'] is int ? json['age'] : (json['age'] != null ? int.tryParse(json['age'].toString()) ?? 0 : 0),
      occupation: json['occupation']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'age': age,
      'occupation': occupation,
    };
  }

  bool isValid() {
    return name.trim().isNotEmpty && age > 0;
  }
}
