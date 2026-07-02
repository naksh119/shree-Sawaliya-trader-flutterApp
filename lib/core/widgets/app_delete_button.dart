import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_filled_button.dart';

/// Branded delete action with the shared gradient fill.
class AppDeleteButton extends StatelessWidget {
  const AppDeleteButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon = Icons.delete_outline,
    this.width = double.infinity,
    this.height = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppGradientFilledButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      width: width,
      height: height,
    );
  }
}
