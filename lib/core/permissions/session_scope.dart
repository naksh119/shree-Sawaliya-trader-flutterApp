import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';

/// Provides [LoginResponse] and [PermissionService] to descendant widgets.
class SessionScope extends InheritedWidget {
  SessionScope({
    required this.session,
    required super.child,
    super.key,
  }) : service = PermissionService(session);

  final LoginResponse session;
  final PermissionService service;

  static SessionScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SessionScope>();
  }

  static SessionScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'SessionScope not found in widget tree');
    return scope!;
  }

  static LoginResponse sessionOf(BuildContext context) => of(context).session;

  static PermissionService permissionsOf(BuildContext context) =>
      of(context).service;

  @override
  bool updateShouldNotify(SessionScope oldWidget) =>
      oldWidget.session != session;

  /// Wraps [child] with a [SessionScope] when [session] is non-null.
  static Widget wrap({
    required LoginResponse? session,
    required Widget child,
    Widget? loading,
  }) {
    if (session == null) {
      return loading ?? const SizedBox.shrink();
    }
    return SessionScope(session: session, child: child);
  }
}
