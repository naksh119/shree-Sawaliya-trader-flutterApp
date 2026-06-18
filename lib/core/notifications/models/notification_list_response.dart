import 'package:sawaliyatrader/core/notifications/models/notification_dto.dart';

class NotificationListResponse {
  const NotificationListResponse({
    required this.items,
    required this.total,
    required this.unreadCount,
    required this.page,
    required this.pageSize,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return NotificationListResponse(
      items: (data['results'] as List<dynamic>? ?? [])
          .map(
            (item) => NotificationDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      total: data['total'] as int? ?? 0,
      unreadCount: data['unread_count'] as int? ?? 0,
      page: data['page'] as int? ?? 1,
      pageSize: data['page_size'] as int? ?? 20,
    );
  }

  final List<NotificationDto> items;
  final int total;
  final int unreadCount;
  final int page;
  final int pageSize;

  bool get hasMore => page * pageSize < total;
}
