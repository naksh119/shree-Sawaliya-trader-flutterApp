import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/notifications/models/notification_dto.dart';
import 'package:sawaliyatrader/core/notifications/notification_role_policy.dart';

abstract final class NotificationFilter {
  static List<NotificationDto> forSession(
    LoginResponse session,
    Iterable<NotificationDto> notifications,
  ) {
    return notifications
        .where((notification) => NotificationRolePolicy.canView(session, notification))
        .toList();
  }

  static int unreadCountForSession(
    LoginResponse session,
    Iterable<NotificationDto> notifications,
  ) {
    return forSession(session, notifications).where((n) => !n.isRead).length;
  }
}
