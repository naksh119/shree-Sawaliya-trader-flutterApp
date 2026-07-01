import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/centers/models/center_dto.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/screens/centers/widgets/center_status_chip.dart';

class CenterListTile extends StatelessWidget {
  const CenterListTile({
    required this.center,
    required this.onTap,
    super.key,
  });

  final CenterDto center;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final subtitle = center.subtitleLine;

    return Material(
      color: context.appColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.appColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: context.appColors.goldTint,
                child: BrandGradientText(
                  text: center.initials,
                  style: AppTextStyles.label(context),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(center.name, style: AppTextStyles.label(context)),
                    const SizedBox(height: 4),
                    Text(
                      center.displayCode,
                      style: AppTextStyles.subtitle(context),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(subtitle, style: AppTextStyles.body(context)),
                    ],
                    if (center.loanAmount != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        currency.format(center.loanAmount),
                        style: AppTextStyles.body(context).copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CenterStatusChip(status: center.status, compact: true),
                  if (center.emiGenerated) ...[
                    const SizedBox(height: 6),
                    BrandGradientIcon(
                      Icons.event_available_outlined,
                      size: 16,
                      opacity: 0.8,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
