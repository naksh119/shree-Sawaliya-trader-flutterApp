import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';

class CreateFabButton extends StatelessWidget {
  const CreateFabButton({required this.onTap, super.key});

  final VoidCallback onTap;

  static const _borderRadius = BorderRadius.all(Radius.circular(12));

  static const _labelShadow = [
    Shadow(
      color: Color(0xFF6D5416),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5E08A),
              Color(0xFFE5B82E),
              Color(0xFFD4A62A),
              Color(0xFFB8891A),
            ],
            stops: [0.0, 0.35, 0.72, 1.0],
          ),
          border: Border.all(
            color: const Color(0xFFFFF3C4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shinyGold.withValues(alpha: 0.5),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.brown.withValues(alpha: 0.22),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: _borderRadius,
          splashColor: Colors.white.withValues(alpha: 0.28),
          highlightColor: Colors.white.withValues(alpha: 0.14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add_rounded,
                  size: 22,
                  color: Colors.white,
                  shadows: _labelShadow,
                ),
                const SizedBox(width: 6),
                Text(
                  context.l10n.create,
                  style: AppTextStyles.label(context).copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    shadows: _labelShadow,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
