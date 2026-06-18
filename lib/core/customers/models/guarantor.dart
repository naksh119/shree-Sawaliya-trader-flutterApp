import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class Guarantor {
  const Guarantor({
    required this.id,
    required this.name,
    this.mobile,
    this.aadhaarNumber,
    this.address,
    this.relationship,
    this.occupation,
  });

  factory Guarantor.fromJson(Map<String, dynamic> json) {
    return Guarantor(
      id: readInt(json, ['id']) ?? 0,
      name: readString(json, ['name', 'full_name']) ?? 'Guarantor',
      mobile: readString(json, ['mobile', 'phone']),
      aadhaarNumber: readString(json, ['aadhaar_number', 'aadhaar']),
      address: readString(json, ['address', 'address_line1']),
      relationship: readString(json, ['relationship', 'relation']),
      occupation: readString(json, ['occupation']),
    );
  }

  final int id;
  final String name;
  final String? mobile;
  final String? aadhaarNumber;
  final String? address;
  final String? relationship;
  final String? occupation;

  Map<String, dynamic> toPayload() {
    return {
      'name': name,
      if (mobile != null) 'mobile': mobile,
      if (aadhaarNumber != null) 'aadhaar_number': aadhaarNumber,
      if (address != null) 'address': address,
      if (relationship != null) 'relationship': relationship,
      if (occupation != null) 'occupation': occupation,
    };
  }
}
