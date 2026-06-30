import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';

Future<void> _precacheNetworkImage(String url) async {
  final provider = NetworkImage(url);
  final completer = Completer<void>();
  final stream = provider.resolve(const ImageConfiguration());
  late ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, _) {
      if (!completer.isCompleted) completer.complete();
      stream.removeListener(listener);
    },
    onError: (_, __) {
      if (!completer.isCompleted) completer.complete();
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  await completer.future.timeout(
    const Duration(seconds: 12),
    onTimeout: () {},
  );
}

/// Warms remote splash/login assets into Flutter's image cache at startup.
Future<void> precacheSplashBackground() =>
    _precacheNetworkImage(AppAssets.splashBackgroundUrl);

Future<void> precacheAppLogo() => _precacheNetworkImage(AppAssets.logoUrl);
