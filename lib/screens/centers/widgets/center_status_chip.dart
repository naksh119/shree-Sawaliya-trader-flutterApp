import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/centers/models/center_status.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';

class CenterStatusChip extends StatelessWidget {
  const CenterStatusChip({
    required this.status,
    super.key,
    this.compact = false,
  });

  final CenterStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.localizedLabel(context),
        style: AppTextStyles.subtitle(context).copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: compact ? 11 : 12,
        ),
      ),
    );
  }
}
