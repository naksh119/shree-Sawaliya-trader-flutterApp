import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
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

  Widget _buildStepNode(BuildContext context, int index) {
    const nodeSize = 36.0;
    const innerSize = 28.0;
    final isCurrent = index == currentStep;
    final isActive = index <= currentStep;

    return SizedBox(
      width: nodeSize,
      height: nodeSize,
      child: Center(
        child: isCurrent
            ? Container(
                width: nodeSize,
                height: nodeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.appColors.gold, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: innerSize,
                    height: innerSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.appColors.gold,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.subtitle(context).copyWith(
                        fontSize: 12,
                        color: context.appColors.card,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            : CircleAvatar(
                radius: innerSize / 2,
                backgroundColor: isActive
                    ? context.appColors.gold
                    : context.appColors.progressTrack,
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.subtitle(context).copyWith(
                    fontSize: 12,
                    color: isActive
                        ? Colors.white
                        : context.appColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
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
                      color: i <= currentStep
                          ? context.appColors.gold
                          : context.appColors.progressTrack,
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
