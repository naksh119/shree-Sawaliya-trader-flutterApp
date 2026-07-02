import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/widgets/app_wizard_nav_button_metrics.dart';

/// Outlined wizard action with the same pill shape as [AppNextButton].
class AppWizardOutlineButton extends StatelessWidget {
  const AppWizardOutlineButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.width = AppWizardNavButtonMetrics.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: AppWizardNavButtonMetrics.height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.teal500,
          side: const BorderSide(color: AppColors.teal500),
          minimumSize: Size(width, AppWizardNavButtonMetrics.height),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: AppWizardNavButtonMetrics.shape,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
