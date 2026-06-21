import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
class CustomerStatusChip extends StatelessWidget {
  const CustomerStatusChip({
    required this.status,
    super.key,
    this.compact = false,
  });

  final CustomerStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withValues(alpha: 0.35)),
      ),
      child: Text(
        status.localizedLabel(context),
        style: AppTextStyles.subtitle(context).copyWith(
          fontSize: compact ? 13 : 14,
          color: status.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
