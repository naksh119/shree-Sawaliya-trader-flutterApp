import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Brand-gold status badge shared across customers, employees, centers, and branches.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    required this.label,
    super.key,
    this.compact = false,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.gold;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(compact ? 8 : 20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: AppTextStyles.subtitle(context).copyWith(
          fontSize: compact ? 11 : 14,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
