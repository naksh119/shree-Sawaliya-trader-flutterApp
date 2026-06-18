import 'package:sawaliyatrader/core/auth/models/employee_profile.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

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
    this.firstName,
    this.lastName,
    this.fullName,
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
      firstName: readString(json, ['first_name', 'firstName']),
      lastName: readString(json, ['last_name', 'lastName']),
      fullName: readString(json, ['full_name', 'name', 'display_name']),
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

  final String? firstName;
  final String? lastName;
  final String? fullName;

  Map<String, dynamic> toJson() => {
        'access': access,
        'id': id,
        'is_superuser': isSuperuser,
        if (employee != null) 'employee': employee!.toJson(),
        'permissions': permissions,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (fullName != null) 'full_name': fullName,
      };

  LoginResponse copyWith({String? access}) => LoginResponse(
        access: access ?? this.access,
        id: id,
        isSuperuser: isSuperuser,
        employee: employee,
        permissions: permissions,
        firstName: firstName,
        lastName: lastName,
        fullName: fullName,
      );
}
