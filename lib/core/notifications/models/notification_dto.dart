import 'package:sawaliyatrader/core/notifications/models/notification_priority.dart';
import 'package:sawaliyatrader/core/notifications/models/notification_type.dart';

/// API notification payload. Backend may scope delivery by role, permission, or branch.
class NotificationDto {
  const NotificationDto({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.priority = NotificationPriority.normal,
    this.targetRoles = const [],
    this.targetPermissions = const [],
    this.branch,
    this.actionRoute,
    this.metadata = const {},
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'] as int,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      priority: json['priority'] as String? ?? NotificationPriority.normal,
      targetRoles: _parseStringList(json['target_roles']),
      targetPermissions: _parseStringList(json['target_permissions']),
      branch: json['branch'] as String?,
      actionRoute: json['action_route'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? const {},
    );
  }

  final int id;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String priority;
  final List<String> targetRoles;
  final List<String> targetPermissions;
  final String? branch;
  final String? actionRoute;
  final Map<String, dynamic> metadata;

  String get typeDisplayName => NotificationType.displayName(type);

  NotificationDto copyWith({bool? isRead}) {
    return NotificationDto(
      id: id,
      type: type,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      priority: priority,
      targetRoles: targetRoles,
      targetPermissions: targetPermissions,
      branch: branch,
      actionRoute: actionRoute,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'body': body,
        'is_read': isRead,
        'created_at': createdAt.toIso8601String(),
        'priority': priority,
        'target_roles': targetRoles,
        'target_permissions': targetPermissions,
        if (branch != null) 'branch': branch,
        if (actionRoute != null) 'action_route': actionRoute,
        'metadata': metadata,
      };

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item as String).toList();
  }
}
