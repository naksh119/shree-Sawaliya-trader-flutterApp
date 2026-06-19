import 'package:flutter/foundation.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';

class EmployeeDto {
  const EmployeeDto({
    required this.id,
    required this.role,
    required this.branch,
    this.roleId,
    this.employeeId,
    this.employeeCode,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.mobile,
    this.isActive = true,
    this.dateOfJoining,
    this.createdAt,
    this.employeePhoto,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    final flat = flattenUserRecord(json);
    final firstName = readString(flat, ['first_name', 'firstName']);
    final lastName = readString(flat, ['last_name', 'lastName']);
    final fullName = readString(flat, ['full_name', 'name', 'display_name']);

    return EmployeeDto(
      id: readInt(flat, ['id', 'employee_id']) ?? 0,
      employeeId: readInt(flat, ['employee_id']),
      employeeCode: readString(flat, ['employee_code', 'code']),
      firstName: firstName,
      lastName: lastName,
      fullName: fullName,
      email: readString(flat, ['email']),
      mobile: readString(flat, [
        'primary_mobile_number',
        'mobile',
        'phone',
        'phone_number',
      ]),
      role: _readRoleCode(flat),
      roleId: _readRoleId(flat),
      branch: _readBranchLabel(flat),
      isActive: readBool(flat, ['is_active', 'active']) ?? true,
      dateOfJoining: readDateTime(flat, ['date_of_joining', 'joining_date']),
      createdAt: readDateTime(flat, ['created_at']),
      employeePhoto: readString(flat, ['employee_photo', 'photo']),
    );
  }

  /// Unwraps `{ id, email, is_active, employee: { ...profile } }` user records.
  static Map<String, dynamic> flattenUserRecord(Map<String, dynamic> json) {
    final employee = asJsonMap(json['employee']);
    if (employee == null) {
      if (!json.containsKey('first_name') && !json.containsKey('firstName')) {
        debugPrint(
          '[Employees] flat record missing name keys. keys=${json.keys.toList()}',
        );
      }
      return json;
    }

    debugPrint(
      '[Employees] flatten nested employee userId=${json['id']} '
      'profileId=${employee['id']}',
    );

    return {
      ...employee,
      if (json['id'] != null) 'id': json['id'],
      if (employee['id'] != null) 'employee_id': employee['id'],
      if (json['email'] != null) 'email': json['email'],
      if (json['is_active'] != null) 'is_active': json['is_active'],
      if (json['role'] != null) 'role': json['role'],
      if (json['branch'] != null) 'branch': json['branch'],
    };
  }

  final int id;
  final int? employeeId;
  final String? employeeCode;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? email;
  final String? mobile;
  final String role;
  final int? roleId;
  final String branch;
  final bool isActive;
  final DateTime? dateOfJoining;
  final DateTime? createdAt;
  final String? employeePhoto;

  String get displayName {
    final first = firstName?.trim();
    final last = lastName?.trim();
    if (first != null && first.isNotEmpty && last != null && last.isNotEmpty) {
      return '$first $last';
    }
    final full = fullName?.trim();
    if (full != null && full.isNotEmpty) return full;
    if (first != null && first.isNotEmpty) return first;
    return employeeCode ?? 'Employee #$id';
  }

  String get displayCode => employeeCode ?? '#$id';

  String get roleLabel => EmployeeRole.displayNameFor(role);

  bool matchesRole({
    int? roleId,
    required String roleCode,
    String? roleName,
  }) {
    if (roleId != null && this.roleId != null && this.roleId == roleId) {
      return true;
    }
    final normalizedRole = role.toUpperCase();
    if (normalizedRole == roleCode.toUpperCase()) return true;
    if (roleName != null &&
        roleLabel.toUpperCase() == roleName.toUpperCase()) {
      return true;
    }
    return false;
  }

  String get locationLine {
    final parts = [branch, roleLabel].where((v) => v.isNotEmpty);
    return parts.join(' · ');
  }

  String get initials {
    final first = _initialFrom(firstName) ?? _initialFrom(_firstWord(fullName));
    final last = _initialFrom(lastName) ?? _initialFrom(_lastWord(fullName));

    if (first != null && last != null) return '$first$last';
    if (first != null) return first;
    if (displayName.isNotEmpty) return displayName[0].toUpperCase();
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
    return parts.length > 1 ? parts.last : null;
  }

  static String _readRoleCode(Map<String, dynamic> json) {
    final role = json['role'];
    final roleMap = asJsonMap(role);
    if (roleMap != null) {
      return readString(roleMap, ['role_code', 'code']) ?? '';
    }
    if (role is int) {
      return readString(json, ['role_code']) ?? '';
    }
    return readString(json, ['role', 'role_code']) ?? '';
  }

  static int? _readRoleId(Map<String, dynamic> json) {
    final role = json['role'];
    final roleMap = asJsonMap(role);
    if (roleMap != null) {
      return readInt(roleMap, ['id']);
    }
    if (role is int) return role;
    return readInt(json, ['role_id']);
  }

  static String _readBranchLabel(Map<String, dynamic> json) {
    final branch = json['branch'];
    final branchMap = asJsonMap(branch);
    if (branchMap != null) {
      return readString(branchMap, ['branch_name', 'branch_code', 'name']) ??
          '';
    }
    return readString(json, ['branch', 'branch_name', 'branch_code']) ?? '';
  }
}
