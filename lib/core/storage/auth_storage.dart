import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';

class AuthStorage {
  AuthStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _sessionKey = 'session';

  final FlutterSecureStorage _storage;

  Future<void> saveSession(LoginResponse response) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: response.access),
      _storage.write(
        key: _sessionKey,
        value: jsonEncode(response.toJson()),
      ),
    ]);
  }

  Future<String?> getAccessToken() => _read(_accessTokenKey);

  Future<LoginResponse?> getSession() async {
    final raw = await _read(_sessionKey);
    if (raw == null) return null;

    return LoginResponse.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  Future<bool> hasSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _sessionKey),
    ]);
  }

  Future<void> updateAccessToken(String access) async {
    final session = await getSession();
    await _storage.write(key: _accessTokenKey, value: access);
    if (session != null) {
      await _storage.write(
        key: _sessionKey,
        value: jsonEncode(session.copyWith(access: access).toJson()),
      );
    }
  }

  /// Platform plugins are not re-registered on hot restart; treat as no data.
  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } on MissingPluginException {
      return null;
    }
  }
}
