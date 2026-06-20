abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/';
  static const branches = '/branches';
  static const branchNew = '/branches/new';

  static String branchEdit(int id) => '/branches/$id/edit';
  static const customers = '/customers';
  static const customerNew = '/customers/new';
  static const centers = '/centers';
  static const centerNew = '/centers/new';
  static const emis = '/emis';
  static const employees = '/employees';
  static const employeeNew = '/employees/new';
  static const reports = '/reports';
  static const more = '/more';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const accessDenied = '/access-denied';

  static String customerDetail(int id) => '/customers/$id';

  static String employeeDetail(int id) => '/employees/$id';

  static String branchDetail(int id) => '/branches/$id';

  static String centerDetail(int id) => '/centers/$id';
}
