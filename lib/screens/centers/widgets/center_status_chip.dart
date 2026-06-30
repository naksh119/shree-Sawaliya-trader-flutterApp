import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/centers/models/center_status.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/widgets/app_status_chip.dart';

class CenterStatusChip extends StatelessWidget {
  const CenterStatusChip({
    required this.status,
    super.key,
    this.compact = false,
  });

  final CenterStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppStatusChip(
      label: status.localizedLabel(context),
      compact: compact,
    );
  }
}
