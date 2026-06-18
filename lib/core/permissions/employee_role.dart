/// Employee role codes returned in the login `employee.role` field.
enum EmployeeRole {
  admin('ADMIN'),
  ao('AO'),
  hrm('HRM'),
  am('AM'),
  bm('BM'),
  abm('ABM'),
  fo('FO'),
  cm('CM');

  const EmployeeRole(this.code);

  final String code;

  static EmployeeRole? fromCode(String? code) {
    if (code == null || code.isEmpty) return null;
    for (final role in EmployeeRole.values) {
      if (role.code == code) return role;
    }
    return null;
  }

  static String displayNameFor(String? code) =>
      fromCode(code)?.displayName ?? code ?? '';

  String get displayName => switch (this) {
        EmployeeRole.admin => 'Admin',
        EmployeeRole.ao => 'Administrative Officer',
        EmployeeRole.hrm => 'HR Manager',
        EmployeeRole.am => 'Area Manager',
        EmployeeRole.bm => 'Branch Manager',
        EmployeeRole.abm => 'Assistant Branch Manager',
        EmployeeRole.fo => 'Field Officer',
        EmployeeRole.cm => 'Collection Manager',
      };

  static const monitoringRoles = [admin, ao, am];
}
