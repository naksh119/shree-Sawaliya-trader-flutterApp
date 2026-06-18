import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class BranchOption {
  const BranchOption({
    required this.code,
    required this.name,
    this.id,
    this.city,
  });

  factory BranchOption.fromJson(Map<String, dynamic> json) {
    final code = readString(json, ['branch_code', 'code', 'name']) ?? '';
    final name = readString(json, ['branch_name', 'name', 'branch_code']) ?? code;

    return BranchOption(
      id: readInt(json, ['id', 'branch_id']),
      code: code,
      name: name,
      city: readString(json, ['branch_city', 'city']),
    );
  }

  final int? id;
  final String code;
  final String name;
  final String? city;

  String get label {
    if (city != null && city!.isNotEmpty) return '$name · $city';
    return name;
  }

  /// Value sent to the employee register API (`branch` field).
  int? get apiValue => id;
}
