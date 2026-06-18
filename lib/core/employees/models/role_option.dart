import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';

class RoleOption {
  const RoleOption({
    required this.id,
    required this.code,
    required this.name,
    this.isActive = true,
    this.workingDescription,
  });

  factory RoleOption.fromJson(Map<String, dynamic> json) {
    final code = readString(json, ['role_code', 'code']) ?? '';
    final name = readString(json, ['role_name', 'name', 'display_name', 'label']) ??
        EmployeeRole.displayNameFor(code);

    return RoleOption(
      id: readInt(json, ['id']) ?? 0,
      code: code,
      name: name,
      isActive: readBool(json, ['is_active']) ?? true,
      workingDescription: readString(json, ['working_description', 'description']),
    );
  }

  final int id;
  final String code;
  final String name;
  final bool isActive;
  final String? workingDescription;

  static List<RoleOption> fallbackRoles() {
    return EmployeeRole.values
        .map(
          (role) => RoleOption(
            id: 0,
            code: role.code,
            name: role.displayName,
          ),
        )
        .toList();
  }
}
