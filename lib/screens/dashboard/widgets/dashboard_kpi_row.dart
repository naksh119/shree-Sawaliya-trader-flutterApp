import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/dashboard/models/dashboard_stats.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class DashboardKpiRow extends StatelessWidget {
  const DashboardKpiRow({
    required this.stats,
    required this.permissions,
    super.key,
  });

  final DashboardStats stats;
  final PermissionService permissions;

  static final _currency = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  List<({String label, String value, IconData icon})> _visibleCards(
    BuildContext context,
  ) {
    final l10n = context.l10n;
    final cards = <({String label, String value, IconData icon})>[];
    if (permissions.canViewCustomers) {
      cards.add((
        label: l10n.customers,
        value: '${stats.customerTotal}',
        icon: Icons.people_outline,
      ));
    }
    if (permissions.canViewCenters) {
      cards.add((
        label: l10n.centers,
        value: '${stats.centerTotal}',
        icon: Icons.hub_outlined,
      ));
    }
    if (permissions.canCollectEmi) {
      cards.add((
        label: l10n.pendingEmi,
        value: '${stats.pendingEmiCount}',
        icon: Icons.payments_outlined,
      ));
      cards.add((
        label: l10n.collected,
        value: _currency.format(stats.totalCollected),
        icon: Icons.currency_rupee_rounded,
      ));
    }
    if (permissions.canViewEmployees) {
      cards.add((
        label: l10n.employees,
        value: '${stats.employeeTotal}',
        icon: Icons.badge_outlined,
      ));
    }
    if (permissions.canManageBranches) {
      cards.add((
        label: l10n.branches,
        value: '${stats.branchTotal}',
        icon: Icons.store_outlined,
      ));
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    final cards = _visibleCards(context);

    if (cards.isEmpty) {
      return Text(
        context.l10n.noOverviewMetrics,
        style: AppTextStyles.subtitle(context),
      );
    }

    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final card = cards[index];
          return _KpiCard(
            label: card.label,
            value: card.value,
            icon: card.icon,
          );
        },
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.appColors.shinyGold, size: 22),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.heading(context).copyWith(fontSize: 22),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.subtitle(context).copyWith(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
