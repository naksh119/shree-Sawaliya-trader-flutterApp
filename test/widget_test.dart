import 'package:flutter_test/flutter_test.dart';
import 'package:sawaliyatrader/core/auth/session_notifier.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/routing/app_router.dart';
import 'package:sawaliyatrader/main.dart';

void main() {
  testWidgets('App shows splash screen on launch', (WidgetTester tester) async {
    appSessionNotifier = SessionNotifier();
    final router = createAppRouter(appSessionNotifier!);

    await tester.pumpWidget(MyApp(router: router));
    await tester.pump();

    expect(find.byType(AppLoader), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
  });
}
