import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/widgets/app_status_chip.dart';

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
    return AppStatusChip(
      label: status.localizedLabel(context),
      compact: compact,
    );
  }
}
