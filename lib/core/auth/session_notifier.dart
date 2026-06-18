import 'package:flutter/foundation.dart';

/// Notifies [GoRouter] when login state changes so redirects re-run.
final class SessionNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

/// Set once from [main] so [AuthService] can trigger router redirects.
SessionNotifier? appSessionNotifier;
