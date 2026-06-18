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
}
