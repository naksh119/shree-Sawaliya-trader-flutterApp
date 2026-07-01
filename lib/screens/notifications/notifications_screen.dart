import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/notifications/notification_notifier.dart';
import 'package:sawaliyatrader/core/notifications/notification_role_policy.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _authService = AuthService();
  LoginResponse? _session;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final session =
        await _authService.getSession();
    if (!mounted) return;

    setState(() => _session = session);
    if (session != null &&
        NotificationRolePolicy.canAccessNotifications(session)) {
      appNotificationNotifier?.bindSession(session);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = _session;
    final notifier = appNotificationNotifier;

    if (session == null) {
      return const Scaffold(
        body: Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    final permissions = PermissionService(session);
    if (!permissions.canViewNotifications) {
      return Scaffold(
        appBar: ThemedAppBar(title: l10n.notifications),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.notificationsNoAccess,
            style: AppTextStyles.body(context),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: ThemedAppBar(
        title: l10n.notifications,
        actions: [
          if (notifier != null)
            ListenableBuilder(
              listenable: notifier,
              builder: (context, _) {
                if (notifier.unreadCount == 0) return const SizedBox.shrink();
                return TextButton(
                  onPressed: notifier.markAllAsRead,
                  child: Text(l10n.markAllRead),
                );
              },
            ),
        ],
      ),
      body: notifier == null
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.notificationsInboxPending,
                style: AppTextStyles.body(context),
              ),
            )
          : ListenableBuilder(
              listenable: notifier,
              builder: (context, _) {
                if (notifier.isLoading && notifier.items.isEmpty) {
                  return const Center(
                    child: AppLoader(size: kAppPageLoaderSize),
                  );
                }

                if (notifier.items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.noNotificationsYet,
                          style: AppTextStyles.body(context),
                        ),
                        if (notifier.error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            l10n.notificationsApiPending,
                            style: AppTextStyles.subtitle(context),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: notifier.refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifier.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = notifier.items[index];
                      return _NotificationTile(
                        title: item.title,
                        body: item.body,
                        subtitle: item.typeDisplayName,
                        isRead: item.isRead,
                        onTap: () async {
                          if (!item.isRead) {
                            await notifier.markAsRead(item.id);
                          }
                          final route = item.actionRoute;
                          if (route != null &&
                              route.isNotEmpty &&
                              context.mounted) {
                            context.push(route);
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.body,
    required this.subtitle,
    required this.isRead,
    required this.onTap,
  });

  final String title;
  final String body;
  final String subtitle;
  final bool isRead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isRead ? context.appColors.card : context.appColors.goldHighlight,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.appColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.label(context)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.subtitle(context)),
              const SizedBox(height: 8),
              Text(body, style: AppTextStyles.body(context)),
            ],
          ),
        ),
      ),
    );
  }
}
