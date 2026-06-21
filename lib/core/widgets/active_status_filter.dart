import 'package:flutter/material.dart';
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

  /// Suffix for empty-state copy, e.g. `" active"` or `""`.
  String get emptyMessageSuffix => switch (this) {
        ActiveStatusFilter.all => '',
        ActiveStatusFilter.active => ' active',
        ActiveStatusFilter.inactive => ' inactive',
      };
}

/// Preconfigured filter icon for [ActiveStatusFilter] (All / Active / Inactive).
class ActiveStatusFilterButton extends StatelessWidget {
  const ActiveStatusFilterButton({
    required this.value,
    required this.onSelected,
    super.key,
    this.tooltip = 'Filter by status',
  });

  final ActiveStatusFilter value;
  final ValueChanged<ActiveStatusFilter?> onSelected;
  final String tooltip;

  static const menuItems = [
    DropdownMenuItem(
      value: ActiveStatusFilter.all,
      child: Text('All'),
    ),
    DropdownMenuItem(
      value: ActiveStatusFilter.active,
      child: Text('Active'),
    ),
    DropdownMenuItem(
      value: ActiveStatusFilter.inactive,
      child: Text('Inactive'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppFilterIconButton<ActiveStatusFilter>(
      tooltip: tooltip,
      value: value,
      isActive: value.isFiltering,
      icon: Icons.filter_list_rounded,
      onSelected: onSelected,
      items: menuItems,
    );
  }
}
