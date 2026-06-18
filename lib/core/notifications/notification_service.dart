import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/notifications/models/notification_dto.dart';
import 'package:sawaliyatrader/core/notifications/models/notification_list_response.dart';
import 'package:sawaliyatrader/core/notifications/notification_filter.dart';

class NotificationService {
  NotificationService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;
  final List<NotificationDto> _cachedItems = [];

  List<NotificationDto> get cachedItems => List.unmodifiable(_cachedItems);

  Future<NotificationListResponse> fetchNotifications({
    required LoginResponse session,
    int page = 1,
    int pageSize = 20,
    bool unreadOnly = false,
  }) async {
    final body = await _apiClient.get(
      ApiConfig.notificationsPath,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (unreadOnly) 'is_read': false,
        if (session.employee != null) ...{
          'role': session.employee!.role,
          'branch': session.employee!.branch,
        },
      },
    );

    if (body['success'] != true) {
      throw ApiException(body['error'] as String? ?? 'Failed to load notifications');
    }

    final response = NotificationListResponse.fromJson(body);
    final visible = NotificationFilter.forSession(session, response.items);

    if (page == 1) {
      _cachedItems
        ..clear()
        ..addAll(visible);
    } else {
      _cachedItems.addAll(visible);
    }

    return NotificationListResponse(
      items: visible,
      total: response.total,
      unreadCount: NotificationFilter.unreadCountForSession(session, visible),
      page: response.page,
      pageSize: response.pageSize,
    );
  }

  Future<void> markAsRead({
    required LoginResponse session,
    required int notificationId,
  }) async {
    final body = await _apiClient.patch(
      ApiConfig.notificationMarkReadPath(notificationId),
      data: {'is_read': true},
    );

    if (body['success'] != true) {
      throw ApiException(
        body['error'] as String? ?? 'Failed to mark notification as read',
      );
    }

    final index = _cachedItems.indexWhere((item) => item.id == notificationId);
    if (index != -1) {
      _cachedItems[index] = _cachedItems[index].copyWith(isRead: true);
    }
  }

  Future<void> markAllAsRead({required LoginResponse session}) async {
    final body = await _apiClient.patch(
      ApiConfig.notificationsMarkAllReadPath,
      data: {'is_read': true},
    );

    if (body['success'] != true) {
      throw ApiException(
        body['error'] as String? ?? 'Failed to mark all notifications as read',
      );
    }

    for (var i = 0; i < _cachedItems.length; i++) {
      _cachedItems[i] = _cachedItems[i].copyWith(isRead: true);
    }
  }
}
