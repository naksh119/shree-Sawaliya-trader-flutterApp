import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/widgets/app_background.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _titleText = 'SHREE SAWALIYA MULTITRADE';
  static const _typingDelay = Duration(milliseconds: 70);
  static const _typingStartDelay = Duration(milliseconds: 350);

  Timer? _typingTimer;
  String _visibleTitle = '';

  @override
  void initState() {
    super.initState();
    _startTypewriterAnimation();
    _navigateNext();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void _startTypewriterAnimation() {
    Future<void>.delayed(_typingStartDelay, () {
      if (!mounted) return;

      var index = 0;
      _typingTimer = Timer.periodic(_typingDelay, (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        index += 1;
        if (index > _titleText.length) {
          timer.cancel();
          return;
        }

        setState(() {
          _visibleTitle = _titleText.substring(0, index);
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
    final screenSize = MediaQuery.sizeOf(context);
    final logoWidth = (screenSize.width * 0.88).clamp(0.0, 360.0);
    final logoMaxHeight = (screenSize.height * 0.34).clamp(160.0, 280.0);

    return Scaffold(
      backgroundColor: context.appColors.card,
      body: AppBackground(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: logoWidth,
                        maxHeight: logoMaxHeight,
                      ),
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
                        child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _GoldenShimmerText(
                      text: _visibleTitle,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 22,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: (screenSize.height * 0.24).clamp(96.0, 160.0),
                  ),
                  child: const AppLoader(size: AppLoaderSize.large),
                ),
              ),
            ),
          ],
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
