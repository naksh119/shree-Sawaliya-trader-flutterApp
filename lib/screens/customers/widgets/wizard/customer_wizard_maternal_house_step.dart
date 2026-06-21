import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';

class CustomerWizardMaternalHouseStep extends StatelessWidget {
  const CustomerWizardMaternalHouseStep({
    super.key,
    required this.contactNameController,
    required this.contactMobileController,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.pincodeController,
    required this.apiError,
  });

  final TextEditingController contactNameController;
  final TextEditingController contactMobileController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;
  final String? Function(String field) apiError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.maternalHouseContactHint,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: contactNameController,
          label: l10n.contactName,
          textInputAction: TextInputAction.next,
          externalError: apiError('contact_name'),
          validator: (v) => CustomerValidators.name(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: contactMobileController,
          label: l10n.contactMobile,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          externalError: apiError('contact_mobile'),
          validator: (v) => CustomerValidators.mobile(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: addressController,
          label: l10n.address,
          textInputAction: TextInputAction.next,
          externalError: apiError('address_line1'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.address),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: cityController,
          label: l10n.city,
          textInputAction: TextInputAction.next,
          externalError: apiError('city'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.city),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: stateController,
          label: l10n.state,
          textInputAction: TextInputAction.next,
          externalError: apiError('state'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.state),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: pincodeController,
          label: l10n.pincode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          externalError: apiError('pincode'),
          validator: (v) => CustomerValidators.pincode(l10n, v, required: true),
        ),
      ],
    );
  }
}
