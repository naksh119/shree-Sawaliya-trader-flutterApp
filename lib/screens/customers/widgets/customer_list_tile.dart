import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/customers/models/customer_dto.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_status_chip.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class CustomerListTile extends StatelessWidget {
  const CustomerListTile({
    required this.customer,
    required this.onTap,
    super.key,
  });

  final CustomerDto customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: context.appColors.gold.withValues(alpha: 0.18),
                child: Text(
                  customer.fullName.isNotEmpty
                      ? customer.fullName[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.label(context).copyWith(color: context.appColors.shinyGold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.fullName, style: AppTextStyles.label(context)),
                    const SizedBox(height: 4),
                    Text(
                      customer.displayCode,
                      style: AppTextStyles.subtitle(context),
                    ),
                    if (customer.mobile != null) ...[
                      const SizedBox(height: 4),
                      Text(customer.mobile!, style: AppTextStyles.body(context)),
                    ],
                    if (customer.locationLine.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(customer.locationLine, style: AppTextStyles.subtitle(context)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CustomerStatusChip(status: customer.status, compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
