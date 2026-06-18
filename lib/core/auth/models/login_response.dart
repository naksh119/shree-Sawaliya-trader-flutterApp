import 'package:sawaliyatrader/core/auth/models/employee_profile.dart';

/// Parsed body of a successful **POST** `/employees/login/` response.
///
/// ```json
/// {
///   "success": true,
///   "access": "<JWT>",
///   "id": 1,
///   "is_superuser": false,
///   "employee": {
///     "employee_id": 12,
///     "employee_code": "JAIPUR-EMP001",
///     "role": "FO",
///     "branch": "JAIPUR"
///   },
///   "permissions": []
/// }
/// ```
///
/// `success` and `error` are handled in [AuthService.login] before parsing.
class LoginResponse {
  const LoginResponse({
    required this.access,
    required this.id,
    required this.isSuperuser,
    this.employee,
    required this.permissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final employeeJson = json['employee'];
    return LoginResponse(
      access: json['access'] as String,
      id: json['id'] as int,
      isSuperuser: json['is_superuser'] as bool? ?? false,
      employee: employeeJson is Map<String, dynamic>
          ? EmployeeProfile.fromJson(employeeJson)
          : null,
      permissions: (json['permissions'] as List<dynamic>? ?? [])
          .map((item) => item as String)
          .toList(),
    );
  }

  /// JWT access token; sent as `Authorization: Bearer <access>` on API calls.
  final String access;

  /// Django user id (`employees.User` primary key).
  final int id;

  /// When true, bypasses granular permission checks.
  final bool isSuperuser;

  /// Logged-in employee profile; null when the user has no linked employee record.
  final EmployeeProfile? employee;

  /// Permission strings (e.g. `customer.view`, `emi.collect`) for route and UI gating.
  final List<String> permissions;

  Map<String, dynamic> toJson() => {
        'access': access,
        'id': id,
        'is_superuser': isSuperuser,
        if (employee != null) 'employee': employee!.toJson(),
        'permissions': permissions,
      };

  LoginResponse copyWith({String? access}) => LoginResponse(
        access: access ?? this.access,
        id: id,
        isSuperuser: isSuperuser,
        employee: employee,
        permissions: permissions,
      );
}
