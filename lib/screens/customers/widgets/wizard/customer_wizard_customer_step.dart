import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';
import 'package:sawaliyatrader/core/widgets/app_person_dropdowns.dart';
import 'package:sawaliyatrader/core/widgets/app_photo_picker.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/widgets/upper_case_text_input_formatter.dart';
import 'package:sawaliyatrader/screens/customers/widgets/wizard/customer_wizard_date_field.dart';

class CustomerWizardCustomerStep extends StatelessWidget {
  const CustomerWizardCustomerStep({
    super.key,
    required this.fullNameController,
    required this.mobileController,
    required this.emailController,
    required this.aadhaarController,
    required this.panController,
    required this.addressController,
    required this.addressLine2Controller,
    required this.cityController,
    required this.stateController,
    required this.pincodeController,
    required this.occupationController,
    required this.incomeController,
    required this.dateOfBirth,
    required this.gender,
    required this.livePhoto,
    required this.housePhoto,
    required this.apiError,
    required this.onPickLivePhoto,
    required this.onClearLivePhoto,
    required this.onPickHousePhoto,
    required this.onClearHousePhoto,
    required this.onPickDateOfBirth,
    required this.onClearDateOfBirth,
    required this.onGenderChanged,
  });

  final TextEditingController fullNameController;
  final TextEditingController mobileController;
  final TextEditingController emailController;
  final TextEditingController aadhaarController;
  final TextEditingController panController;
  final TextEditingController addressController;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;
  final TextEditingController occupationController;
  final TextEditingController incomeController;
  final DateTime? dateOfBirth;
  final String? gender;
  final PickedImage? livePhoto;
  final PickedImage? housePhoto;
  final String? Function(String field) apiError;
  final VoidCallback onPickLivePhoto;
  final VoidCallback onClearLivePhoto;
  final VoidCallback onPickHousePhoto;
  final VoidCallback onClearHousePhoto;
  final VoidCallback onPickDateOfBirth;
  final VoidCallback? onClearDateOfBirth;
  final ValueChanged<String?> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        AppPhotoPicker(
          label: l10n.customerImage,
          hint: l10n.uploadCustomerImage,
          placeholderIcon: Icons.face_outlined,
          image: livePhoto,
          errorText: apiError('live_photo'),
          onPick: onPickLivePhoto,
          onClear: livePhoto?.isNotEmpty == true ? onClearLivePhoto : null,
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: fullNameController,
          label: l10n.fullName,
          textInputAction: TextInputAction.next,
          externalError: apiError('full_name'),
          validator: (v) => CustomerValidators.fullName(l10n, v),
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
          controller: emailController,
          label: l10n.email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
          externalError: apiError('email'),
          validator: (v) => CustomerValidators.email(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: aadhaarController,
          label: l10n.aadhaarNumber,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          externalError: apiError('aadhaar_number'),
          validator: (v) => CustomerValidators.aadhaar(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: panController,
          label: l10n.pan,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: const [UpperCaseTextInputFormatter()],
          externalError: apiError('pan_number'),
          validator: (v) => CustomerValidators.pan(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomerWizardDateField(
                label: l10n.dateOfBirth,
                value: dateOfBirth,
                compact: true,
                errorText: apiError('date_of_birth'),
                validator: (value) =>
                    value == null ? l10n.dateOfBirthRequired : null,
                onTap: onPickDateOfBirth,
                onClear: onClearDateOfBirth,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.gender,
                    style: AppTextStyles.label(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  AppDropdownFormField<String>(
                    value: gender,
                    decoration: AppDropdownDecoration.formField(
                      context,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ).copyWith(
                      hintText: l10n.selectGender,
                      hintStyle: AppTextStyles.body(context).copyWith(
                        color: context.appColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    validator: (v) =>
                        apiError('gender') ??
                        CustomerValidators.gender(l10n, v),
                    items: genderDropdownItems(
                      context,
                      textStyle: AppTextStyles.body(context).copyWith(
                        fontSize: 14,
                      ),
                    ),
                    style: AppTextStyles.body(context).copyWith(fontSize: 14),
                    onChanged: onGenderChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: addressController,
          label: l10n.addressLine1,
          textInputAction: TextInputAction.next,
          externalError: apiError('address_line1'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.address),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: addressLine2Controller,
          label: l10n.addressLine2,
          textInputAction: TextInputAction.next,
          externalError: apiError('address_line2'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.addressLine2),
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
          textInputAction: TextInputAction.next,
          externalError: apiError('pincode'),
          validator: (v) => CustomerValidators.pincode(l10n, v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: occupationController,
          label: l10n.occupation,
          textInputAction: TextInputAction.next,
          externalError: apiError('occupation'),
          validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.occupation),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: incomeController,
          label: l10n.monthlyIncomeWithSymbol,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          externalError: apiError('monthly_income'),
          validator: (v) => CustomerValidators.decimalAmount(
            l10n,
            v,
            label: l10n.monthlyIncome,
            required: true,
          ),
        ),
        const SizedBox(height: 20),
        AppPhotoPicker(
          label: l10n.housePhoto,
          hint: l10n.uploadHousePhoto,
          placeholderIcon: Icons.home_outlined,
          image: housePhoto,
          errorText: apiError('house_photo'),
          onPick: onPickHousePhoto,
          onClear: housePhoto?.isNotEmpty == true ? onClearHousePhoto : null,
        ),
      ],
    );
  }
}
