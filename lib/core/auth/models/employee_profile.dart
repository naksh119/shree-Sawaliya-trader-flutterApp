class EmployeeProfile {
  const EmployeeProfile({
    required this.employeeId,
    required this.employeeCode,
    required this.role,
    required this.branch,
  });

  factory EmployeeProfile.fromJson(Map<String, dynamic> json) {
    return EmployeeProfile(
      employeeId: json['employee_id'] as int,
      employeeCode: json['employee_code'] as String,
      role: json['role'] as String,
      branch: json['branch'] as String,
    );
  }

  final int employeeId;
  final String employeeCode;
  final String role;
  final String branch;

  Map<String, dynamic> toJson() => {
        'employee_id': employeeId,
        'employee_code': employeeCode,
        'role': role,
        'branch': branch,
      };
}
