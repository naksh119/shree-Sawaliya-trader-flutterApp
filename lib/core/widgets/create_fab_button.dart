import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';

class CreateFabButton extends StatelessWidget {
  const CreateFabButton({required this.onTap, super.key});

  final VoidCallback onTap;

  static const _borderRadius = BorderRadius.all(Radius.circular(12));

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        gradient: AppColors.brandGradient,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: _borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add_rounded,
                  size: 22,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  context.l10n.create,
                  style: AppTextStyles.label(context).copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
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
