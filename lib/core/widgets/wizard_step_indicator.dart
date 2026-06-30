import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Step progress bar with double-circle highlight on the current step.
class WizardStepIndicator extends StatelessWidget {
  const WizardStepIndicator({
    required this.steps,
    required this.currentStep,
    super.key,
  });

  final List<String> steps;
  final int currentStep;

  static const _nodeGradient = BoxDecoration(
    shape: BoxShape.circle,
    gradient: AppColors.brandGradient,
  );

  Widget _buildStepNode(BuildContext context, int index) {
    const nodeSize = 36.0;
    const innerSize = 28.0;
    final isCurrent = index == currentStep;
    final isActive = index <= currentStep;

    final numberStyle = AppTextStyles.subtitle(context).copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );

    if (!isActive) {
      return SizedBox(
        width: nodeSize,
        height: nodeSize,
        child: Center(
          child: CircleAvatar(
            radius: innerSize / 2,
            backgroundColor: context.appColors.progressTrack,
            child: Text(
              '${index + 1}',
              style: numberStyle.copyWith(
                color: context.appColors.textPrimary,
              ),
            ),
          ),
        ),
      );
    }

    if (isCurrent) {
      return SizedBox(
        width: nodeSize,
        height: nodeSize,
        child: Center(
          child: Container(
            width: nodeSize,
            height: nodeSize,
            decoration: _nodeGradient,
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: _nodeGradient,
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: numberStyle.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: nodeSize,
      height: nodeSize,
      child: Center(
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: _nodeGradient,
          alignment: Alignment.center,
          child: Text(
            '${index + 1}',
            style: numberStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                if (i > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient:
                            i <= currentStep ? AppColors.brandGradient : null,
                        color: i <= currentStep
                            ? null
                            : context.appColors.progressTrack,
                      ),
                    ),
                  ),
                _buildStepNode(context, i),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.stepProgress(
              currentStep + 1,
              steps.length,
              steps[currentStep],
            ),
            style: AppTextStyles.subtitle(context),
          ),
        ],
      ),
    );
  }
}
