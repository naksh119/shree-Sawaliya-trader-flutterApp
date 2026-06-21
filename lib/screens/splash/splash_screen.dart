import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/app_background.dart';
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

    final isLoggedIn = await AuthService().isLoggedIn();
    if (!mounted) return;

    context.go(isLoggedIn ? AppRoutes.dashboard : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.card,
      body: AppBackground(
        showOverlay: Theme.of(context).brightness == Brightness.dark,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 680;
              final contentWidth = constraints.maxWidth - 48;
              final logoWidth = (contentWidth * 0.68).clamp(140.0, 240.0);
              final titleStyle = GoogleFonts.cormorantGaramond(
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
                            child: Image.asset(
                              AppAssets.logo,
                              width: logoWidth,
                              fit: BoxFit.contain,
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
                              _GoldenShimmerText(
                                text: _visibleTitle,
                                style: titleStyle,
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
    );
  }
}

class _GoldenShimmerText extends StatefulWidget {
  const _GoldenShimmerText({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<_GoldenShimmerText> createState() => _GoldenShimmerTextState();
}

class _GoldenShimmerTextState extends State<_GoldenShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  static const _goldColors = <Color>[
    Color(0xFF4A3A0F),
    Color(0xFF6D5416),
    Color(0xFF8B6914),
    Color(0xFFA67C1A),
    Color(0xFFC9A227),
    Color(0xFFD4A62A),
    Color(0xFFC9A227),
    Color(0xFFA67C1A),
    Color(0xFF8B6914),
    Color(0xFF6D5416),
    Color(0xFF4A3A0F),
  ];

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final slide = _shimmerController.value * 2.4 - 1.2;

        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(slide - 1, -0.2),
              end: Alignment(slide + 1, 0.2),
              colors: _goldColors,
              stops: const [
                0.0,
                0.1,
                0.22,
                0.34,
                0.44,
                0.5,
                0.56,
                0.66,
                0.78,
                0.9,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: widget.style.copyWith(
          color: context.appColors.card,
          shadows: const [
            Shadow(
              color: Color(0xFF3D2F0A),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
            Shadow(
              color: Color(0xFF6D5416),
              offset: Offset(0, 0),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
