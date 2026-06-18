abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/';
  static const branches = '/branches';
  static const customers = '/customers';
  static const customerNew = '/customers/new';
  static const centers = '/centers';
  static const emis = '/emis';
  static const employees = '/employees';
  static const reports = '/reports';
  static const more = '/more';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const accessDenied = '/access-denied';

  static String customerDetail(int id) => '/customers/$id';
}
