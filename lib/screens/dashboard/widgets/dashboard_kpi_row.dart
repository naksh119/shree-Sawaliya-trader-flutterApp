import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/dashboard/models/dashboard_stats.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';

class DashboardKpiRow extends StatelessWidget {
  const DashboardKpiRow({
    required this.stats,
    super.key,
  });

  final DashboardStats stats;

  static final _currency = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final cards = [
      _KpiData(
        label: 'Customers',
        value: '${stats.customerTotal}',
        icon: Icons.people_outline,
      ),
      _KpiData(
        label: 'Centers',
        value: '${stats.centerTotal}',
        icon: Icons.hub_outlined,
      ),
      _KpiData(
        label: 'Pending EMI',
        value: '${stats.pendingEmiCount}',
        icon: Icons.payments_outlined,
      ),
      _KpiData(
        label: 'Collected',
        value: _currency.format(stats.totalCollected),
        icon: Icons.currency_rupee_rounded,
      ),
      _KpiData(
        label: 'Employees',
        value: '${stats.employeeTotal}',
        icon: Icons.badge_outlined,
      ),
      _KpiData(
        label: 'Branches',
        value: '${stats.branchTotal}',
        icon: Icons.store_outlined,
      ),
    ];

    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _KpiCard(data: cards[index]),
      ),
    );
  }
}

class _KpiData {
  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.data});

  final _KpiData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.brown.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: AppColors.shinyGold, size: 22),
          const Spacer(),
          Text(
            data.value,
            style: AppTextStyles.heading.copyWith(fontSize: 22),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: AppTextStyles.subtitle.copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
