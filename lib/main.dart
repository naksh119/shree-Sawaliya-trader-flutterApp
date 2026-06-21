import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/l10n/app_localizations.dart';
import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/session_notifier.dart';
import 'package:sawaliyatrader/core/locale/locale_notifier.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/notifications/notification_notifier.dart';
import 'package:sawaliyatrader/core/routing/app_router.dart';
import 'package:sawaliyatrader/core/storage/auth_storage.dart';
import 'package:sawaliyatrader/core/theme/app_themes.dart';
import 'package:sawaliyatrader/core/theme/theme_notifier.dart';
import 'package:sawaliyatrader/core/theme/theme_scope.dart';
import 'package:sawaliyatrader/core/widgets/dismiss_keyboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env', isOptional: true);

  final authStorage = AuthStorage();
  late final AuthService authService;
  await ApiClient.initialize(
    getAccessToken: authStorage.getAccessToken,
    onRefresh: () => authService.refreshSession(),
    onRefreshFailed: () => authService.handleRefreshFailed(),
  );
  authService = AuthService(authStorage: authStorage);

  appSessionNotifier = SessionNotifier();
  appNotificationNotifier = NotificationNotifier();
  appThemeNotifier = await ThemeNotifier.load();
  appLocaleNotifier = await LocaleNotifier.load();
  final router = createAppRouter(appSessionNotifier!);

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = appThemeNotifier!;
    final localeNotifier = appLocaleNotifier!;

    return ThemeScope(
      notifier: themeNotifier,
      child: ListenableBuilder(
        listenable: Listenable.merge([themeNotifier, localeNotifier]),
        builder: (context, _) {
          return MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.light(),
            darkTheme: AppThemes.dark(),
            themeMode: themeNotifier.mode,
            locale: localeNotifier.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            themeAnimationDuration: Duration.zero,
            builder: (context, child) {
              return DismissKeyboard(
                child: AppLoadingHost(child: child ?? const SizedBox.shrink()),
              );
            },
            routerConfig: router,
          );
        },
      ),
    );
  }
}
