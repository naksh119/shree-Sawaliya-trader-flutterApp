import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';

/// Reads a [LoginResponse] passed via [GoRouterState.extra] from a list screen.
LoginResponse? loginResponseFromRouteExtra(GoRouterState state) =>
    state.extra is LoginResponse ? state.extra! as LoginResponse : null;
