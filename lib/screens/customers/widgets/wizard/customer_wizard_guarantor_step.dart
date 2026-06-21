import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';

class CustomerWizardGuarantorStep extends StatelessWidget {
  const CustomerWizardGuarantorStep({
    super.key,
    required this.nameController,
    required this.mobileController,
    required this.aadhaarController,
    required this.relationController,
    required this.addressController,
    required this.apiError,
  });

  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController aadhaarController;
  final TextEditingController relationController;
  final TextEditingController addressController;
  final String? Function(String field) apiError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.addGuarantor,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: nameController,
          label: l10n.name,
          externalError: apiError('name'),
          validator: (v) => CustomerValidators.name(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: mobileController,
          label: l10n.mobile,
          keyboardType: TextInputType.phone,
          externalError: apiError('mobile'),
          validator: (v) => CustomerValidators.mobile(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: aadhaarController,
          label: l10n.aadhaar,
          keyboardType: TextInputType.number,
          externalError: apiError('aadhaar_number'),
          validator: (v) => CustomerValidators.aadhaar(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: relationController,
          label: l10n.relationship,
          externalError: apiError('relationship'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.relationship),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: addressController,
          label: l10n.address,
          externalError: apiError('address'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.address),
        ),
      ],
    );
  }
}
