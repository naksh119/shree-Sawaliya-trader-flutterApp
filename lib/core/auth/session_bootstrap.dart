import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';

/// Create/detail screens that accept session from [GoRouterState.extra].
abstract interface class HasInitialSession {
  LoginResponse? get initialSession;
}

/// Resolves [session] from route extra, inherited [SessionScope], or auth storage.
mixin SessionBootstrapMixin<T extends StatefulWidget> on State<T> {
  LoginResponse? session;
  bool _sessionResolutionStarted = false;
  final AuthService _sessionAuthService = AuthService();

  LoginResponse? get _initialSessionFromRoute =>
      widget is HasInitialSession
          ? (widget as HasInitialSession).initialSession
          : null;

  /// Override to run work after [session] becomes available (e.g. load dropdowns).
  void onSessionReady(LoginResponse session) {}

  /// Override when auth storage has no session.
  void onSessionMissing() {}

  @mustCallSuper
  void initSessionBootstrap() {
    final initial = _initialSessionFromRoute;
    if (initial == null) return;
    session = initial;
    onSessionReady(initial);
  }

  @mustCallSuper
  void resolveSessionFromContext() {
    if (_sessionResolutionStarted || session != null) return;
    _sessionResolutionStarted = true;

    final inherited = SessionScope.maybeOf(context)?.session;
    if (inherited != null) {
      setState(() => session = inherited);
      onSessionReady(inherited);
      return;
    }

    unawaited(_fetchStoredSession());
  }

  Future<void> _fetchStoredSession() async {
    final loaded = await _sessionAuthService.getSession();
    if (!mounted) return;
    setState(() => session = loaded);
    if (loaded != null) {
      onSessionReady(loaded);
    } else {
      onSessionMissing();
    }
  }
}

/// Resolves [session] for list screens inside the app shell.
mixin ListSessionBootstrapMixin<T extends StatefulWidget> on State<T> {
  LoginResponse? session;
  bool _listSessionBootstrapStarted = false;
  final AuthService _listSessionAuthService = AuthService();

  void bootstrapListSession(
    FutureOr<void> Function(LoginResponse) onReady, {
    void Function()? onMissing,
  }) {
    if (_listSessionBootstrapStarted) return;

    final inherited = SessionScope.maybeOf(context)?.session;
    if (inherited != null) {
      _listSessionBootstrapStarted = true;
      session = inherited;
      onReady(inherited);
      return;
    }

    _listSessionBootstrapStarted = true;
    unawaited(_fetchListSession(onReady, onMissing: onMissing));
  }

  Future<void> _fetchListSession(
    FutureOr<void> Function(LoginResponse) onReady, {
    void Function()? onMissing,
  }) async {
    final loaded = await _listSessionAuthService.getSession();
    if (!mounted) return;
    setState(() => session = loaded);
    if (loaded != null) {
      await onReady(loaded);
    } else {
      onMissing?.call();
    }
  }
}
