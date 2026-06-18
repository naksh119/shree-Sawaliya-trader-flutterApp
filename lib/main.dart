import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/session_notifier.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/notifications/notification_notifier.dart';
import 'package:sawaliyatrader/core/routing/app_router.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env', isOptional: true);

  late final AuthService authService;
  await ApiClient.initialize(
    onRefresh: () => authService.refreshSession(),
    onRefreshFailed: () => authService.handleRefreshFailed(),
  );
  authService = AuthService();

  appSessionNotifier = SessionNotifier();
  appNotificationNotifier = NotificationNotifier();
  final router = createAppRouter(appSessionNotifier!);

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sawaliya Trader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.gold),
        scaffoldBackgroundColor: AppColors.cream,
        useMaterial3: true,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.gold,
          circularTrackColor: AppColors.progressTrack,
        ),
      ),
      builder: (context, child) {
        return AppLoadingHost(child: child ?? const SizedBox.shrink());
      },
      routerConfig: router,
    );
  }
}
