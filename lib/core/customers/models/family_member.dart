import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    this.relationship,
    this.mobile,
    this.occupation,
    this.age,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: readInt(json, ['id']) ?? 0,
      name: readString(json, ['name', 'full_name']) ?? 'Family Member',
      relationship: readString(json, ['relationship', 'relation']),
      mobile: readString(json, ['mobile', 'phone']),
      occupation: readString(json, ['occupation']),
      age: readInt(json, ['age']),
    );
  }

  final int id;
  final String name;
  final String? relationship;
  final String? mobile;
  final String? occupation;
  final int? age;

  Map<String, dynamic> toPayload() {
    return {
      'name': name,
      if (relationship != null) 'relationship': relationship,
      if (mobile != null) 'mobile': mobile,
      if (occupation != null) 'occupation': occupation,
      if (age != null) 'age': age,
    };
  }
}
