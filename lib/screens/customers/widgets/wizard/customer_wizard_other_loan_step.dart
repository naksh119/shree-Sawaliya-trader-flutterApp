import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';

class CustomerWizardOtherLoanStep extends StatelessWidget {
  const CustomerWizardOtherLoanStep({
    super.key,
    required this.lenderController,
    required this.amountController,
    required this.emiController,
    required this.outstandingController,
    required this.apiError,
  });

  final TextEditingController lenderController;
  final TextEditingController amountController;
  final TextEditingController emiController;
  final TextEditingController outstandingController;
  final String? Function(String field) apiError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.recordExistingLoans,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: lenderController,
          label: l10n.lenderName,
          externalError: apiError('lender_name'),
          validator: (v) =>
              CustomerValidators.requiredText(l10n, v, l10n.lenderName),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: amountController,
          label: l10n.loanAmountWithSymbol,
          keyboardType: TextInputType.number,
          externalError: apiError('loan_amount'),
          validator: (v) => CustomerValidators.decimalAmount(
            l10n,
            v,
            label: l10n.loanAmount,
            required: true,
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: emiController,
          label: l10n.emiAmountWithSymbol,
          keyboardType: TextInputType.number,
          externalError: apiError('emi_amount'),
          validator: (v) => CustomerValidators.decimalAmount(
            l10n,
            v,
            label: l10n.emiAmount,
            required: true,
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: outstandingController,
          label: l10n.outstandingWithSymbol,
          keyboardType: TextInputType.number,
          externalError: apiError('outstanding_amount'),
          validator: (v) => CustomerValidators.decimalAmount(
            l10n,
            v,
            label: l10n.outstandingAmount,
            required: true,
          ),
        ),
      ],
    );
  }
}
