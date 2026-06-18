import 'package:flutter/foundation.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/notifications/models/notification_dto.dart';
import 'package:sawaliyatrader/core/notifications/notification_filter.dart';
import 'package:sawaliyatrader/core/notifications/notification_service.dart';

/// In-memory notification state for the signed-in session.
///
/// Wire to push/local storage when the backend and FCM are available.
class NotificationNotifier extends ChangeNotifier {
  NotificationNotifier({NotificationService? service})
    : _service = service ?? NotificationService();

  final NotificationService _service;

  LoginResponse? _session;
  List<NotificationDto> _items = const [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  List<NotificationDto> get items => List.unmodifiable(_items);
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void bindSession(LoginResponse? session) {
    _session = session;
    if (session == null) {
      _clear();
      return;
    }
    refresh();
  }

  Future<void> refresh() async {
    final session = _session;
    if (session == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = _items.isEmpty
          ? await awaitWithMinPageLoaderDuration(
              _service.fetchNotifications(session: session),
            )
          : await _service.fetchNotifications(session: session);
      _items = response.items;
      _unreadCount = response.unreadCount;
    } catch (error) {
      _error = error.toString();
      _items = NotificationFilter.forSession(session, _service.cachedItems);
      _unreadCount = NotificationFilter.unreadCountForSession(session, _items);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final session = _session;
    if (session == null) return;

    await _service.markAsRead(session: session, notificationId: notificationId);

    _items = _items
        .map(
          (item) =>
              item.id == notificationId ? item.copyWith(isRead: true) : item,
        )
        .toList();
    _unreadCount = NotificationFilter.unreadCountForSession(session, _items);
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    final session = _session;
    if (session == null) return;

    await _service.markAllAsRead(session: session);

    _items = _items.map((item) => item.copyWith(isRead: true)).toList();
    _unreadCount = 0;
    notifyListeners();
  }

  void _clear() {
    _items = const [];
    _unreadCount = 0;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}

/// Global notifier initialized in [main].
NotificationNotifier? appNotificationNotifier;
