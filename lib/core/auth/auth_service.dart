import 'package:flutter/foundation.dart';
import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/session_notifier.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/notifications/notification_notifier.dart';
import 'package:sawaliyatrader/core/storage/auth_storage.dart';

class AuthService {
  AuthService({ApiClient? apiClient, AuthStorage? authStorage})
    : _apiClient = apiClient ?? ApiClient(),
      _authStorage = authStorage ?? AuthStorage();

  final ApiClient _apiClient;
  final AuthStorage _authStorage;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final body = await _apiClient.post(
      ApiConfig.loginPath,
      data: {'email': email.trim(), 'password': password},
    );

    debugPrint('Login API response: $body');

    if (body['success'] != true) {
      debugPrint('Login API error: ${body['error']}');
      throw ApiException(
        body['error'] as String? ?? 'Login failed. Please try again.',
      );
    }

    final response = LoginResponse.fromJson(body);
    debugPrint('Login API parsed response: ${response.toJson()}');
    await _authStorage.saveSession(response);
    appSessionNotifier?.refresh();
    appNotificationNotifier?.bindSession(response);
    return response;
  }

  /// **POST** `/employees/session/refresh/` — uses the HttpOnly `refresh_token` cookie.
  Future<String> refreshSession() async {
    final body = await _apiClient.post(ApiConfig.refreshPath);

    if (body['success'] != true) {
      throw ApiException(
        body['error'] as String? ?? 'Session expired. Please sign in again.',
      );
    }

    final access = body['access'] as String?;
    if (access == null || access.isEmpty) {
      throw const ApiException('Invalid refresh response from server.');
    }

    await _authStorage.updateAccessToken(access);
    debugPrint('Session refreshed successfully');
    return access;
  }

  /// Clears local session when refresh fails (e.g. expired refresh cookie).
  Future<void> handleRefreshFailed() async {
    debugPrint('Session refresh failed; clearing local session');
    await _apiClient.clearCookies();
    await _authStorage.clearSession();
    appNotificationNotifier?.bindSession(null);
    appSessionNotifier?.refresh();
  }

  Future<bool> isLoggedIn() => _authStorage.hasSession();

  Future<LoginResponse?> getSession() async {
    final session = await _authStorage.getSession();
    if (session == null) return null;

    final token = await _authStorage.getAccessToken();
    if (token != null && token.isNotEmpty && token != session.access) {
      return session.copyWith(access: token);
    }
    return session;
  }

  Future<void> logout() async {
    final token = await _authStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      try {
        final body = await _apiClient.post(ApiConfig.logoutPath);

        if (body['success'] != true) {
          debugPrint('Logout API error: ${body['error']}');
        }
      } catch (error) {
        debugPrint('Logout API call failed: $error');
      }
    }

    await _apiClient.clearCookies();
    await _authStorage.clearSession();
    appNotificationNotifier?.bindSession(null);
    appSessionNotifier?.refresh();
  }
}
