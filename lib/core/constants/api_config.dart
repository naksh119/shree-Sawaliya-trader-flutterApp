import 'package:sawaliyatrader/core/constants/env_config.dart';

class ApiConfig {
  ApiConfig._();

  static String get baseUrl => EnvConfig.apiBaseUrl;

  static const String loginPath = '/employees/login/';
  static const String refreshPath = '/employees/session/refresh/';
  static const String logoutPath = '/employees/session/logout/';

  static const String notificationsPath = '/employees/api/notifications/';
  static const String notificationsMarkAllReadPath =
      '/employees/api/notifications/mark-all-read/';

  static String notificationMarkReadPath(int id) =>
      '/employees/api/notifications/$id/mark-read/';

  static const customersPath = '/customers/api/';

  static String customerPath(int id) => '/customers/api/$id/';

  static String customerFamilyMembersPath(int customerId) =>
      '/customers/api/$customerId/family-members/';

  static String customerFamilyMemberPath(int customerId, int memberId) =>
      '/customers/api/$customerId/family-members/$memberId/';

  static String customerGuarantorsPath(int customerId) =>
      '/customers/api/$customerId/guarantors/';

  static String customerGuarantorPath(int customerId, int guarantorId) =>
      '/customers/api/$customerId/guarantors/$guarantorId/';

  static String customerMaternalHousePath(int customerId) =>
      '/customers/api/$customerId/maternal-house/';

  static String customerOtherLoansPath(int customerId) =>
      '/customers/api/$customerId/other-loans/';

  static String customerOtherLoanPath(int customerId, int loanId) =>
      '/customers/api/$customerId/other-loans/$loanId/';

  static String customerDocumentsPath(int customerId) =>
      '/customers/api/$customerId/documents/';

  static const employeesPath = '/employees/api/';
  static const employeeRegisterPath = '/employees/register/';
  static const employeeRolesPath = '/employees/api/roles/';
  static const branchesPath = '/branches/api';

  static String branchPath(int id) => '/branches/api/$id';

  static String employeePath(int id) => '/employees/api/$id/';
}
