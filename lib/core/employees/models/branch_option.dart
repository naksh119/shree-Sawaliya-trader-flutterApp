import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class BranchOption {
  const BranchOption({
    required this.code,
    required this.name,
    this.id,
    this.city,
  });

  factory BranchOption.fromJson(Map<String, dynamic> json) {
    final code = readString(json, ['branch_code', 'code']) ?? '';
    final name =
        readString(json, ['branch_name']) ??
        readString(json, ['name']) ??
        code;

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
    final branchName = name.isNotEmpty ? name : code;
    if (city != null && city!.isNotEmpty) return '$branchName · $city';
    return branchName;
  }

  /// Value sent to the employee register API (`branch` field).
  int? get apiValue => id;
}
