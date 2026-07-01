import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_border.dart';

/// Date picker integrated with [FormField] so [FormState.validate] includes it.
class AppDateFormField extends StatelessWidget {
  const AppDateFormField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
    this.errorText,
    this.validator,
    this.compact = false,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? errorText;
  final FormFieldValidator<DateTime?>? validator;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime?>(
      key: ValueKey<DateTime?>(value),
      initialValue: value,
      validator: (fieldValue) {
        if (errorText != null && errorText!.isNotEmpty) {
          return errorText;
        }
        return validator?.call(fieldValue);
      },
      builder: (field) {
        final displayValue = field.value ?? value;
        final effectiveError = errorText ?? field.errorText;
        final hasError = effectiveError != null;
        final formatted = displayValue == null
            ? context.l10n.selectDate
            : '${displayValue.year}-${displayValue.month.toString().padLeft(2, '0')}-${displayValue.day.toString().padLeft(2, '0')}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.label(context),
              maxLines: compact ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            AppDropdownDecoration.fieldBorder(
              context,
              hasError: hasError,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(AppInputMetrics.borderRadius),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 10 : 16,
                      vertical: compact ? 12 : 14,
                    ),
                    child: Row(
                      children: [
                        BrandGradientIcon(
                          Icons.calendar_today_outlined,
                          size: compact ? 16 : 18,
                          opacity: 0.8,
                        ),
                        SizedBox(width: compact ? 8 : 12),
                        Expanded(
                          child: Text(
                            formatted,
                            style: AppTextStyles.body(context).copyWith(
                              color: displayValue == null
                                  ? context.appColors.textSecondary
                                  : context.appColors.textPrimary,
                              fontSize: compact ? 14 : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (onClear != null)
                          IconButton(
                            icon: BrandGradientIcon(
                              Icons.close,
                              size: 18,
                              opacity: 0.7,
                            ),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            onPressed: () {
                              field.didChange(null);
                              onClear?.call();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Text(
            effectiveError,
            style: AppTextStyles.body(context).copyWith(
              color: context.appColors.errorText,
              fontSize: 12,
            ),
          ),
        ],
          ],
        );
      },
    );
  }
}
