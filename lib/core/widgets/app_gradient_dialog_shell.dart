import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_border.dart';

/// Shared layout for gradient-bordered popups (messages, confirmations, etc.).
abstract final class AppGradientDialogMetrics {
  static const double borderRadius = 12;
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(24, 28, 24, 16);
}

class AppGradientDialogShell extends StatelessWidget {
  const AppGradientDialogShell({
    required this.child,
    super.key,
    this.width = 300,
    this.contentPadding = AppGradientDialogMetrics.contentPadding,
  });

  final Widget child;
  final double width;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const radius = AppGradientDialogMetrics.borderRadius;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: colors.textPrimary.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AppGradientBorder(
            backgroundColor: colors.card,
            borderRadius: radius,
            child: Padding(
              padding: contentPadding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
