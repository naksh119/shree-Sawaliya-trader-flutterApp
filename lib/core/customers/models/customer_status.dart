import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';

enum CustomerStatus {
  sourced('SOURCED', 'Sourced'),
  applied('APPLIED', 'Applied'),
  underReview('UNNDER_REVIEW', 'Under Review'),
  approved('APPROVED', 'Approved'),
  rejected('REJECTED', 'Rejected'),
  active('ACTIVE', 'Active'),
  closed('CLOSED', 'Closed');

  const CustomerStatus(this.value, this.label);

  final String value;
  final String label;

  static CustomerStatus? fromValue(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final status in CustomerStatus.values) {
      if (status.value == raw) return status;
    }
    return null;
  }

  static List<CustomerStatus> get filterOptions => CustomerStatus.values;

  Color get color {
    return switch (this) {
      CustomerStatus.sourced => const Color(0xFF8B7355),
      CustomerStatus.applied => AppColors.gold,
      CustomerStatus.underReview => AppColors.navy,
      CustomerStatus.approved => const Color(0xFF4CAF50),
      CustomerStatus.rejected => const Color(0xFFE57373),
      CustomerStatus.active => AppColors.brown,
      CustomerStatus.closed => const Color(0xFFB0A090),
    };
  }

  bool get canApproveOrReject =>
      this == CustomerStatus.applied || this == CustomerStatus.underReview;
}
