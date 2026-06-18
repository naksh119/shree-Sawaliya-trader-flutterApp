import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/storage/app_settings_storage.dart';

final class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier._(this._mode, this._storage);

  final AppSettingsStorage _storage;

  ThemeMode _mode;

  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  static Future<ThemeNotifier> load({AppSettingsStorage? storage}) async {
    final settings = storage ?? AppSettingsStorage();
    final stored = await settings.getThemeMode();
    final mode = switch (stored) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.light,
    };
    return ThemeNotifier._(mode, settings);
  }

  void toggle() {
    setMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    _persistMode(mode);
  }

  Future<void> _persistMode(ThemeMode mode) {
    return _storage.saveThemeMode(mode == ThemeMode.dark ? 'dark' : 'light');
  }
}

ThemeNotifier? appThemeNotifier;
