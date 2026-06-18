import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Device-level app settings that survive restarts (theme, etc.).
class AppSettingsStorage {
  AppSettingsStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _themeModeKey = 'theme_mode';
  static const _localeKey = 'app_locale';

  final FlutterSecureStorage _storage;

  Future<String?> getThemeMode() => _read(_themeModeKey);

  Future<void> saveThemeMode(String value) => _write(_themeModeKey, value);

  Future<String?> getLocale() => _read(_localeKey);

  Future<void> saveLocale(String value) => _write(_localeKey, value);

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } on MissingPluginException {
      return null;
    }
  }

  Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on MissingPluginException {
      // Ignore when plugin channel is unavailable (e.g. hot restart).
    }
  }
}
