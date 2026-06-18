import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Build-time and environment configuration loaded from `.env`.
class EnvConfig {
  EnvConfig._();

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL']?.trim().isNotEmpty == true
          ? dotenv.env['API_BASE_URL']!.trim()
          : 'https://api.sawaliyamultitrade.com';

  static String? get sentryDsn {
    final value = dotenv.env['SENTRY_DSN']?.trim();
    return value != null && value.isNotEmpty ? value : null;
  }

  static String? get googleMapsApiKey {
    final value = dotenv.env['GOOGLE_MAPS_API_KEY']?.trim();
    return value != null && value.isNotEmpty ? value : null;
  }
}
