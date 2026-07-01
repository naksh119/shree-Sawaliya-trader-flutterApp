import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class UserHeaderBadge extends StatelessWidget {
  const UserHeaderBadge({
    required this.initials,
    this.onTap,
    super.key,
  });

  final String initials;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: colors.goldAvatar,
            child: Text(
              initials,
              style: AppTextStyles.label(context).copyWith(
                color: colors.navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
