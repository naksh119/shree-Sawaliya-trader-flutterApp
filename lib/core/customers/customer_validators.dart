import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/l10n/app_localizations.dart';

/// Client-side validation aligned with Django customer API serializers.
class CustomerValidators {
  CustomerValidators._();

  static final _mobilePattern = RegExp(r'^\d{10}$');
  static final _aadhaarPattern = RegExp(r'^\d{12}$');
  static final _panPattern = RegExp(r'^[A-Za-z]{5}\d{4}[A-Za-z]$');
  static final _pincodePattern = RegExp(r'^\d{6}$');
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _lettersOnlyPattern = RegExp(r'^[\p{L}\s]+$', unicode: true);
  static final _digitsOnlyPattern = RegExp(r'^\d+$');
  static const genderOptions = kGenderOptions;
  static const maritalOptions = kMaritalStatusOptions;

  static String? requiredText(
    AppLocalizations l10n,
    String? value,
    String label,
  ) {
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldRequired(label);
    }
    return null;
  }

  static String? fullName(AppLocalizations l10n, String? value) {
    final requiredError = requiredText(l10n, value, l10n.fullName);
    if (requiredError != null) return requiredError;
    if (value!.trim().length > 200) {
      return l10n.fullNameMaxLength;
    }
    return null;
  }

  static String? mobile(
    AppLocalizations l10n,
    String? value, {
    bool required = false,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? l10n.mobileRequired : null;
    }
    if (!_mobilePattern.hasMatch(trimmed)) {
      return l10n.mobileTenDigits;
    }
    return null;
  }

  static String? email(
    AppLocalizations l10n,
    String? value, {
    bool required = false,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? l10n.emailRequired : null;
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      return l10n.enterValidEmail;
    }
    return null;
  }

  static String? aadhaar(
    AppLocalizations l10n,
    String? value, {
    bool required = false,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? l10n.aadhaarRequired : null;
    }
    if (!_aadhaarPattern.hasMatch(trimmed)) {
      return l10n.aadhaarTwelveDigits;
    }
    return null;
  }

  static String? pan(
    AppLocalizations l10n,
    String? value, {
    bool required = false,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? l10n.panRequired : null;
    }
    if (!_panPattern.hasMatch(trimmed)) {
      return l10n.panFormat;
    }
    return null;
  }

  static String? pincode(
    AppLocalizations l10n,
    String? value, {
    bool required = false,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? l10n.pincodeRequired : null;
    }
    if (!_pincodePattern.hasMatch(trimmed)) {
      return l10n.pincodeSixDigits;
    }
    return null;
  }

  static String? decimalAmount(
    AppLocalizations l10n,
    String? value, {
    required String label,
    bool required = false,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? l10n.fieldRequired(label) : null;
    }
    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      return l10n.fieldValidNumber(label);
    }
    if (parsed < 0) {
      return l10n.fieldCannotBeNegative(label);
    }
    return null;
  }

  static String? gender(AppLocalizations l10n, String? value) {
    if (value == null || value.isEmpty) {
      return l10n.genderRequired;
    }
    if (!genderOptions.contains(value)) {
      return l10n.selectValidGender;
    }
    return null;
  }

  static String? maritalStatus(AppLocalizations l10n, String? value) {
    if (value == null || value.isEmpty) {
      return l10n.maritalStatusRequired;
    }
    if (!maritalOptions.contains(value)) {
      return l10n.selectValidMaritalStatus;
    }
    return null;
  }

  static String? age(
    AppLocalizations l10n,
    String? value, {
    bool required = false,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? l10n.ageRequired : null;
    }
    final parsed = int.tryParse(trimmed);
    if (parsed == null) {
      return l10n.ageWholeNumber;
    }
    if (parsed < 0 || parsed > 150) {
      return l10n.ageRange;
    }
    return null;
  }

  static String? optionalLettersOnly(
    AppLocalizations l10n,
    String? value, {
    required String label,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (!_lettersOnlyPattern.hasMatch(trimmed)) {
      return l10n.fieldLettersOnly(label);
    }
    return null;
  }

  static String? optionalDigitsOnly(AppLocalizations l10n, String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (!_digitsOnlyPattern.hasMatch(trimmed)) {
      return l10n.invalidNumber;
    }
    return null;
  }

  static String? name(
    AppLocalizations l10n,
    String? value, {
    bool required = false,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? l10n.nameRequired : null;
    }
    if (trimmed.length > 200) {
      return l10n.nameMaxLength;
    }
    return null;
  }

  static bool digitsOnlyLooksValid(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return true;
    return _digitsOnlyPattern.hasMatch(trimmed);
  }

  static bool mobileLooksValid(String value, {bool required = false}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return !required;
    return _mobilePattern.hasMatch(trimmed);
  }

  static bool aadhaarLooksValid(String value, {bool required = false}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return !required;
    return _aadhaarPattern.hasMatch(trimmed);
  }

  static bool panLooksValid(String value, {bool required = false}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return !required;
    return _panPattern.hasMatch(trimmed);
  }

  /// Used to clear API field errors once the user fixes the input.
  static bool fieldLooksValid(String field, String value) {
    final trimmed = value.trim();

    switch (field) {
      case 'full_name':
        return trimmed.isNotEmpty && trimmed.length <= 200;
      case 'mobile':
      case 'contact_mobile':
        return mobileLooksValid(trimmed, required: true);
      case 'email':
        return emailLooksValid(trimmed, required: true);
      case 'aadhaar_number':
        return aadhaarLooksValid(trimmed, required: true);
      case 'pan_number':
        return panLooksValid(trimmed, required: true);
      case 'pincode':
        return pincodeLooksValid(trimmed, required: true);
      case 'monthly_income':
      case 'loan_amount':
      case 'emi_amount':
      case 'outstanding_amount':
        return decimalLooksValid(trimmed, required: true);
      case 'gender':
        return trimmed.isNotEmpty && genderOptions.contains(trimmed);
      case 'marital_status':
        return trimmed.isNotEmpty && maritalOptions.contains(trimmed);
      case 'document_type':
        return trimmed.isNotEmpty;
      case 'age':
        return ageLooksValid(trimmed, required: true);
      case 'address_line2':
        return true;
      case 'address_line1':
      case 'city':
      case 'state':
      case 'occupation':
      case 'lender_name':
      case 'relationship':
      case 'address':
      case 'contact_name':
      case 'name':
        return trimmed.isNotEmpty;
      default:
        return trimmed.isNotEmpty;
    }
  }

  static bool emailLooksValid(String value, {bool required = false}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return !required;
    return _emailPattern.hasMatch(trimmed);
  }

  static bool pincodeLooksValid(String value, {bool required = false}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return !required;
    return _pincodePattern.hasMatch(trimmed);
  }

  static bool decimalLooksValid(String value, {bool required = false}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return !required;
    final parsed = double.tryParse(trimmed);
    return parsed != null && parsed >= 0;
  }

  static bool ageLooksValid(String value, {bool required = false}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return !required;
    final parsed = int.tryParse(trimmed);
    return parsed != null && parsed >= 0 && parsed <= 150;
  }
}
