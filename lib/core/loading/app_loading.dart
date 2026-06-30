import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';
import 'package:sawaliyatrader/core/theme/app_font.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

enum AppLoaderSize {
  small(36),
  medium(64),
  large(80),
  xlarge(112);

  const AppLoaderSize(this.value);

  final double value;
}

/// Fixed size for full-page loaders (login, dashboard, shell, overlays).
const AppLoaderSize kAppPageLoaderSize = AppLoaderSize.xlarge;

/// Slower rotation for the large page feather loader.
const Duration kAppPageLoaderRotationDuration = Duration(milliseconds: 2200);

/// Standard app-wide feather spinner. Use this instead of [CircularProgressIndicator].
class AppLoader extends StatefulWidget {
  const AppLoader({
    super.key,
    this.size = AppLoaderSize.medium,
    this.rotationDuration,
  });

  final AppLoaderSize size;
  final Duration? rotationDuration;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.rotationDuration ??
          (widget.size == AppLoaderSize.xlarge
              ? kAppPageLoaderRotationDuration
              : const Duration(milliseconds: 1400)),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimension = widget.size.value;

    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        AppAssets.featherLoader,
        width: dimension,
        height: dimension,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

/// Centered loader for page or section loading states.
class AppLoaderView extends StatelessWidget {
  const AppLoaderView({
    super.key,
    this.message,
    this.size = kAppPageLoaderSize,
  });

  final String? message;
  final AppLoaderSize size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLoader(size: size),
          if (message != null) ...[
            const SizedBox(height: 18),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: AppFont.style(
                color: context.appColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Full-screen blocking overlay with the app loader.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    this.message,
    this.size = kAppPageLoaderSize,
  });

  final String? message;
  final AppLoaderSize size;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: ColoredBox(
        color: context.appColors.overlay,
        child: AppLoaderView(message: message, size: size),
      ),
    );
  }
}

class AppLoadingController extends ChangeNotifier {
  bool _isLoading = false;
  String? _message;

  bool get isLoading => _isLoading;
  String? get message => _message;

  void show([String? message]) {
    _message = message;
    if (_isLoading) {
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
  }

  void hide() {
    if (!_isLoading) return;
    _isLoading = false;
    _message = null;
    notifyListeners();
  }
}

class AppLoadingScope extends InheritedNotifier<AppLoadingController> {
  const AppLoadingScope({
    required AppLoadingController super.notifier,
    required super.child,
    super.key,
  });

  static AppLoadingController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLoadingScope>();
    assert(scope != null, 'AppLoadingScope not found in widget tree.');
    return scope!.notifier!;
  }

  static AppLoadingController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppLoadingScope>()
        ?.notifier;
  }
}

class AppLoadingHost extends StatefulWidget {
  const AppLoadingHost({required this.child, super.key});

  final Widget child;

  @override
  State<AppLoadingHost> createState() => _AppLoadingHostState();
}

class _AppLoadingHostState extends State<AppLoadingHost> {
  final _controller = AppLoadingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoadingScope(
      notifier: _controller,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              if (!_controller.isLoading) {
                return const SizedBox.shrink();
              }

              return AppLoadingOverlay(message: _controller.message);
            },
          ),
        ],
      ),
    );
  }
}

extension AppLoadingContext on BuildContext {
  void showAppLoading([String? message]) {
    AppLoadingScope.of(this).show(message);
  }

  void hideAppLoading() {
    AppLoadingScope.of(this).hide();
  }
}
