import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.tooltip,
    this.padding,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final chip = FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: AppTextStyles.subtitle(context).copyWith(
        color: selected ? colors.gold : colors.textPrimary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
      selectedColor: colors.goldTint,
      backgroundColor: colors.card,
      side: BorderSide(
        color: selected ? colors.goldSelected : colors.border,
      ),
      showCheckmark: false,
      padding: padding,
    );

    if (tooltip == null || tooltip!.isEmpty) return chip;

    return Tooltip(message: tooltip!, child: chip);
  }
}
