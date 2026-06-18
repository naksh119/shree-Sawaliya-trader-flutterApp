import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/storage/app_settings_storage.dart';

final class LocaleNotifier extends ChangeNotifier {
  LocaleNotifier._(this._locale, this._storage);

  final AppSettingsStorage _storage;

  Locale _locale;

  Locale get locale => _locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  static Future<LocaleNotifier> load({AppSettingsStorage? storage}) async {
    final settings = storage ?? AppSettingsStorage();
    final stored = await settings.getLocale();
    final locale = switch (stored) {
      'hi' => const Locale('hi'),
      _ => const Locale('en'),
    };
    return LocaleNotifier._(locale, settings);
  }

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    _persistLocale(locale);
  }

  Future<void> _persistLocale(Locale locale) {
    return _storage.saveLocale(locale.languageCode);
  }
}

LocaleNotifier? appLocaleNotifier;
