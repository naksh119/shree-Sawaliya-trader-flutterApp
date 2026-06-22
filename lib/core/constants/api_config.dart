import 'package:sawaliyatrader/core/constants/env_config.dart';

class ApiConfig {
  ApiConfig._();

  static String get baseUrl => EnvConfig.apiBaseUrl;

  // employee api start
  static const String loginPath = '/employees/login/'; // ✓ POST
  static const String refreshPath = '/employees/session/refresh/'; // ✓ POST
  static const String logoutPath = '/employees/session/logout/'; // ✓ POST
  static const String notificationsPath = '/employees/api/notifications/'; // ✓ GET
  static const String notificationsMarkAllReadPath =
      '/employees/api/notifications/mark-all-read/'; // ✓ PATCH
  static String notificationMarkReadPath(int id) =>
      '/employees/api/notifications/$id/mark-read/'; // ✓ PATCH
  static const employeesPath = '/employees/api/'; // ✓ GET
  static const employeeRegisterPath = '/employees/register/'; // ✓ POST
  static const employeeRolesPath = '/employees/api/roles/'; // ✓ GET
  static String employeePath(int id) => '/employees/api/$id/'; // ✓ GET, PATCH, DELETE
  static String employeeEmploymentHistoryPath(int employeeId) =>
      '/employees/api/employment-history/$employeeId/'; // ✓ POST
  // employee api end

  static const customersPath = '/customers/api/'; // ✓ GET, POST
  static String customerPath(int id) => '/customers/api/$id/'; // ✓ GET, PATCH
  static String customerFamilyMembersPath(int customerId) =>
      '/customers/api/$customerId/family-members/'; // ✓ POST
  static String customerFamilyMemberPath(int customerId, int memberId) =>
      '/customers/api/$customerId/family-members/$memberId/'; // path only
  static String customerGuarantorsPath(int customerId) =>
      '/customers/api/$customerId/guarantors/'; // ✓ POST
  static String customerGuarantorPath(int customerId, int guarantorId) =>
      '/customers/api/$customerId/guarantors/$guarantorId/'; // path only
  static String customerMaternalHousePath(int customerId) =>
      '/customers/api/$customerId/maternal-house/'; // ✓ POST, PATCH
  static String customerOtherLoansPath(int customerId) =>
      '/customers/api/$customerId/other-loans/'; // ✓ POST
  static String customerOtherLoanPath(int customerId, int loanId) =>
      '/customers/api/$customerId/other-loans/$loanId/'; // path only
  static String customerDocumentsPath(int customerId) =>
      '/customers/api/$customerId/documents/'; // ✓ POST multipart

  static const branchesPath = '/branches/api/'; // ✓ GET, POST
  static String branchPath(int id) => '/branches/api/$id/'; // ✓ GET, PUT, PATCH, DELETE

  static const centersPath = '/operations/api/centers/'; // ✓ GET, POST
  static String centerPath(int id) => '/operations/api/centers/$id/'; // ✓ GET
  static String centerMembersPath(int centerId) =>
      '/operations/api/centers/$centerId/members/'; // ✓ POST
  static String centerMemberPath(int centerId, int memberId) =>
      '/operations/api/centers/$centerId/members/$memberId/'; // ✓ DELETE
  static String centerGenerateEmiPath(int centerId) =>
      '/operations/api/centers/$centerId/generate-emi/'; // ✓ POST
}
