import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';

/// Shared all / active / inactive filter used across list screens.
enum ActiveStatusFilter { all, active, inactive }

extension ActiveStatusFilterX on ActiveStatusFilter {
  /// API query value: `null` means no filter.
  bool? get isActiveParam => switch (this) {
        ActiveStatusFilter.all => null,
        ActiveStatusFilter.active => true,
        ActiveStatusFilter.inactive => false,
      };

  bool get isFiltering => this != ActiveStatusFilter.all;
}

/// Preconfigured filter icon for [ActiveStatusFilter] (All / Active / Inactive).
class ActiveStatusFilterButton extends StatelessWidget {
  const ActiveStatusFilterButton({
    required this.value,
    required this.onSelected,
    super.key,
  });

  final ActiveStatusFilter value;
  final ValueChanged<ActiveStatusFilter?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppFilterIconButton<ActiveStatusFilter>(
      tooltip: l10n.filterByStatus,
      value: value,
      isActive: value.isFiltering,
      icon: Icons.filter_list_rounded,
      onSelected: onSelected,
      items: [
        DropdownMenuItem(
          value: ActiveStatusFilter.all,
          child: Text(l10n.all),
        ),
        DropdownMenuItem(
          value: ActiveStatusFilter.active,
          child: Text(l10n.active),
        ),
        DropdownMenuItem(
          value: ActiveStatusFilter.inactive,
          child: Text(l10n.inactive),
        ),
      ],
    );
  }
}
