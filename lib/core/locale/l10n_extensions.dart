import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/centers/models/center_product_type.dart';
import 'package:sawaliyatrader/core/centers/models/center_status.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/routing/bottom_nav_config.dart';
import 'package:sawaliyatrader/core/widgets/active_status_filter.dart';
import 'package:sawaliyatrader/l10n/app_localizations.dart';

extension CustomerStatusL10n on CustomerStatus {
  String localizedLabel(BuildContext context) =>
      localizedLabelFrom(context.l10n);

  String localizedLabelFrom(AppLocalizations l10n) => switch (this) {
        CustomerStatus.sourced => l10n.customerStatusSourced,
        CustomerStatus.applied => l10n.customerStatusApplied,
        CustomerStatus.underReview => l10n.customerStatusUnderReview,
        CustomerStatus.approved => l10n.customerStatusApproved,
        CustomerStatus.rejected => l10n.customerStatusRejected,
        CustomerStatus.active => l10n.customerStatusActive,
        CustomerStatus.closed => l10n.customerStatusClosed,
      };
}

extension CenterStatusL10n on CenterStatus {
  String localizedLabel(BuildContext context) =>
      localizedLabelFrom(context.l10n);

  String localizedLabelFrom(AppLocalizations l10n) => switch (this) {
        CenterStatus.pending => l10n.centerStatusPendingEmi,
        CenterStatus.active => l10n.centerStatusActive,
        CenterStatus.closed => l10n.centerStatusClosed,
      };
}

extension CenterProductTypeL10n on CenterProductType {
  String localizedLabel(BuildContext context) =>
      localizedLabelFrom(context.l10n);

  String localizedLabelFrom(AppLocalizations l10n) => switch (this) {
        CenterProductType.gold => l10n.productTypeGold,
        CenterProductType.silver => l10n.productTypeSilver,
      };
}

String localizedChartSegmentLabel(AppLocalizations l10n, String label) =>
    switch (label) {
      'Sourced' => l10n.customerStatusSourced,
      'Applied' => l10n.customerStatusApplied,
      'Under Review' => l10n.customerStatusUnderReview,
      'Approved' => l10n.customerStatusApproved,
      'Rejected' => l10n.customerStatusRejected,
      'Active' => l10n.active,
      'Closed' => l10n.customerStatusClosed,
      'Pending' => l10n.centerStatusPendingEmi,
      'Partial' => l10n.emiStatusPartial,
      'Paid' => l10n.emiStatusPaid,
      'Overdue' => l10n.emiStatusOverdue,
      'Cancelled' => l10n.emiStatusCancelled,
      _ => label,
    };

extension ActiveStatusFilterL10n on ActiveStatusFilter {
  String localizedSuffix(AppLocalizations l10n) => switch (this) {
        ActiveStatusFilter.all => '',
        ActiveStatusFilter.active => l10n.statusSuffixActive,
        ActiveStatusFilter.inactive => l10n.statusSuffixInactive,
      };
}

extension BottomNavItemL10n on BottomNavItem {
  String localizedTooltip(AppLocalizations l10n) => switch (route) {
        AppRoutes.dashboard => l10n.home,
        AppRoutes.customers => l10n.customers,
        AppRoutes.centers => l10n.centers,
        AppRoutes.employees => l10n.employees,
        AppRoutes.reports => l10n.reports,
        AppRoutes.more => l10n.more,
        _ => route,
      };
}

List<String> customerWizardSteps(AppLocalizations l10n) => [
      l10n.wizardStepCustomer,
      l10n.wizardStepFamily,
      l10n.wizardStepMaternalHouse,
      l10n.wizardStepOtherLoans,
      l10n.wizardStepGuarantor,
      l10n.wizardStepDocuments,
    ];

List<String> centerWizardSteps(AppLocalizations l10n) => [
      l10n.wizardStepCenterLoan,
      l10n.wizardStepMembers,
    ];

List<String> employeeWizardSteps(AppLocalizations l10n) => [
      l10n.employeeStepPersonal,
      l10n.employeeStepAssessment,
      l10n.employeeStepIdentity,
      l10n.employeeStepProfile,
      l10n.employeeStepEmploymentHistory,
    ];

/// API gender values accepted by the backend.
const kGenderOptions = ['MALE', 'FEMALE'];

/// API marital status values accepted by the backend.
const kMaritalStatusOptions = ['SINGLE', 'MARRIED'];

String localizedGenderLabel(AppLocalizations l10n, String? value) {
  if (value == null || value.isEmpty) return '';
  return switch (value.toUpperCase()) {
    'MALE' => l10n.genderMale,
    'FEMALE' => l10n.genderFemale,
    'OTHER' => l10n.genderOther,
    _ => value,
  };
}

String localizedMaritalStatusLabel(AppLocalizations l10n, String? value) {
  if (value == null || value.isEmpty) return '';
  return switch (value.toUpperCase()) {
    'SINGLE' => l10n.maritalSingle,
    'MARRIED' => l10n.maritalMarried,
    'DIVORCED' => l10n.maritalDivorced,
    'WIDOWED' => l10n.maritalWidowed,
    _ => value,
  };
}
