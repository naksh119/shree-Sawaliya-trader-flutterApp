import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';

enum CenterStatus {
  pending('PENDING', 'Pending EMI'),
  active('ACTIVE', 'Active'),
  closed('CLOSED', 'Closed');

  const CenterStatus(this.value, this.label);

  final String value;
  final String label;

  static CenterStatus? fromValue(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final status in CenterStatus.values) {
      if (status.value == raw) return status;
    }
    return null;
  }

  static List<CenterStatus> get filterOptions => CenterStatus.values;

  Color get color {
    return switch (this) {
      CenterStatus.pending => AppColors.gold,
      CenterStatus.active => const Color(0xFF4CAF50),
      CenterStatus.closed => const Color(0xFFB0A090),
    };
  }
}
