import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class EmployeeProfile {
  const EmployeeProfile({
    required this.employeeId,
    required this.employeeCode,
    required this.role,
    required this.branch,
    this.firstName,
    this.lastName,
    this.fullName,
  });

  factory EmployeeProfile.fromJson(Map<String, dynamic> json) {
    return EmployeeProfile(
      employeeId: json['employee_id'] as int,
      employeeCode: json['employee_code'] as String,
      role: json['role'] as String,
      branch: json['branch'] as String,
      firstName: readString(json, ['first_name', 'firstName']),
      lastName: readString(json, ['last_name', 'lastName']),
      fullName: readString(json, ['full_name', 'name', 'display_name']),
    );
  }

  final int employeeId;
  final String employeeCode;
  final String role;
  final String branch;
  final String? firstName;
  final String? lastName;
  final String? fullName;

  String get displayName {
    final first = firstName?.trim();
    final last = lastName?.trim();
    if (first != null && first.isNotEmpty && last != null && last.isNotEmpty) {
      return '$first $last';
    }
    final full = fullName?.trim();
    if (full != null && full.isNotEmpty) return full;
    if (first != null && first.isNotEmpty) return first;
    return employeeCode;
  }

  String get initials {
    final first = _initialFrom(firstName) ?? _initialFrom(_firstWord(fullName));
    final last = _initialFrom(lastName) ?? _initialFrom(_lastWord(fullName));

    if (first != null && last != null) return '$first$last';
    if (first != null) return first;
    if (employeeCode.isNotEmpty) {
      return employeeCode[0].toUpperCase();
    }
    return '?';
  }

  static String? _initialFrom(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    return text[0].toUpperCase();
  }

  static String? _firstWord(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    return text.split(RegExp(r'\s+')).first;
  }

  static String? _lastWord(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    final parts = text.split(RegExp(r'\s+'));
    if (parts.length < 2) return null;
    return parts.last;
  }

  Map<String, dynamic> toJson() => {
        'employee_id': employeeId,
        'employee_code': employeeCode,
        'role': role,
        'branch': branch,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (fullName != null) 'full_name': fullName,
      };
}
