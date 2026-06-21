import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';

class CustomerWizardFamilyStep extends StatelessWidget {
  const CustomerWizardFamilyStep({
    super.key,
    required this.nameController,
    required this.relationController,
    required this.ageController,
    required this.mobileController,
    required this.occupationController,
    required this.apiError,
  });

  final TextEditingController nameController;
  final TextEditingController relationController;
  final TextEditingController ageController;
  final TextEditingController mobileController;
  final TextEditingController occupationController;
  final String? Function(String field) apiError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.addFamilyMember,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: nameController,
          label: l10n.name,
          textInputAction: TextInputAction.next,
          externalError: apiError('name'),
          validator: (v) => CustomerValidators.name(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: relationController,
          label: l10n.relationship,
          textInputAction: TextInputAction.next,
          externalError: apiError('relationship'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.relationship),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: ageController,
          label: l10n.age,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          externalError: apiError('age'),
          validator: (v) => CustomerValidators.age(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: mobileController,
          label: l10n.mobile,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          externalError: apiError('mobile'),
          validator: (v) => CustomerValidators.mobile(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: occupationController,
          label: l10n.occupation,
          textInputAction: TextInputAction.done,
          externalError: apiError('occupation'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.occupation),
        ),
      ],
    );
  }
}
