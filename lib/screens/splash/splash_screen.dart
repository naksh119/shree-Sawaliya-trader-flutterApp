import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/app_background.dart';
import 'package:sawaliyatrader/core/theme/app_themes.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _typingDelay = Duration(milliseconds: 70);
  static const _typingStartDelay = Duration(milliseconds: 350);
  static const _logoAnimationDuration = Duration(milliseconds: 700);

  Timer? _typingTimer;
  String _visibleTitle = '';
  String _titleText = '';
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: _logoAnimationDuration,
    );
    _logoScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );
    _logoController.forward();
    _navigateNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final title = context.l10n.splashTitle;
    if (_titleText == title) return;
    _titleText = title;
    _typingTimer?.cancel();
    _visibleTitle = '';
    _startTypewriterAnimation();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _logoController.dispose();
    super.dispose();
  }

  double _titleBlockHeight(TextStyle style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: _titleText, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 3,
    )..layout(maxWidth: maxWidth);
    return painter.height;
  }

  void _startTypewriterAnimation() {
    final title = _titleText;
    if (title.isEmpty) return;

    Future<void>.delayed(_typingStartDelay, () {
      if (!mounted) return;

      var index = 0;
      _typingTimer = Timer.periodic(_typingDelay, (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        index += 1;
        if (index > title.length) {
          timer.cancel();
          return;
        }

        setState(() {
          _visibleTitle = title.substring(0, index);
        });
      });
    });
  }

  Future<void> _navigateNext() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authService = AuthService();
    final hasStoredSession = await authService.isLoggedIn();
    if (!mounted) return;

    if (!hasStoredSession) {
      context.go(AppRoutes.login);
      return;
    }

    final sessionReady = await authService.warmUpSession();
    if (!mounted) return;

    context.go(sessionReady ? AppRoutes.dashboard : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemes.light(),
      child: Scaffold(
        backgroundColor: context.appColors.card,
        body: AppBackground(
          imageUrl: AppAssets.splashBackgroundUrl,
          showOverlay: false,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 680;
                final contentWidth = constraints.maxWidth - 48;
                final logoWidth = (contentWidth * 0.68).clamp(140.0, 240.0);
                final titleStyle = AppTextStyles.highlightedRaw(
                  fontSize: compact ? 17 : 22,
                  letterSpacing: compact ? 0.8 : 1.2,
                  fontWeight: FontWeight.w700,
                );
                final titleHeight = _titleBlockHeight(titleStyle, contentWidth);
                final contentGap = compact ? 16.0 : 24.0;
                final loaderGap = compact ? 24.0 : 36.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeTransition(
                          opacity: _logoOpacity,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 28,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                AppAssets.logoUrl,
                                width: logoWidth,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                gaplessPlayback: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: contentGap),
                        SizedBox(
                          height: titleHeight,
                          width: contentWidth,
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: 0,
                                  child: Text(
                                    _titleText,
                                    textAlign: TextAlign.center,
                                    style: titleStyle,
                                  ),
                                ),
                                BrandGradientText(
                                  text: _visibleTitle,
                                  style: titleStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: loaderGap),
                        AppLoader(
                          size: compact
                              ? AppLoaderSize.medium
                              : AppLoaderSize.large,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
