abstract final class EmployeeRoles {
  static const admin = 'ADMIN';
  static const ao = 'AO';
  static const hrm = 'HRM';
  static const am = 'AM';
  static const bm = 'BM';
  static const abm = 'ABM';
  static const fo = 'FO';
  static const cm = 'CM';

  static const displayNames = <String, String>{
    admin: 'Admin',
    ao: 'Administrative Officer',
    hrm: 'HR Manager',
    am: 'Area Manager',
    bm: 'Branch Manager',
    abm: 'Assistant Branch Manager',
    fo: 'Field Officer',
    cm: 'Collection Manager',
  };

  static String displayName(String roleCode) =>
      displayNames[roleCode] ?? roleCode;
}
