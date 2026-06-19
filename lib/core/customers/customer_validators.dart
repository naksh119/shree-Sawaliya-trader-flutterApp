/// Client-side validation aligned with Django customer API serializers.
class CustomerValidators {
  CustomerValidators._();

  static final _mobilePattern = RegExp(r'^\d{10}$');
  static final _aadhaarPattern = RegExp(r'^\d{12}$');
  static final _panPattern = RegExp(r'^[A-Za-z]{5}\d{4}[A-Za-z]$');
  static final _pincodePattern = RegExp(r'^\d{6}$');
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  static String? fullName(String? value) {
    final requiredError = requiredText(value, 'Full name');
    if (requiredError != null) return requiredError;
    if (value!.trim().length > 200) {
      return 'Full name must be 200 characters or fewer';
    }
    return null;
  }

  static String? mobile(String? value, {bool required = false}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? 'Mobile number is required' : null;
    }
    if (!_mobilePattern.hasMatch(trimmed)) {
      return 'Mobile number must be exactly 10 digits';
    }
    return null;
  }

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (!_emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? aadhaar(String? value, {bool required = false}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? 'Aadhaar number is required' : null;
    }
    if (!_aadhaarPattern.hasMatch(trimmed)) {
      return 'Aadhaar number must be exactly 12 digits';
    }
    return null;
  }

  static String? pan(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (!_panPattern.hasMatch(trimmed)) {
      return 'PAN must be in format ABCDE1234F';
    }
    return null;
  }

  static String? pincode(String? value, {bool required = false}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? 'Pincode is required' : null;
    }
    if (!_pincodePattern.hasMatch(trimmed)) {
      return 'Pincode must be exactly 6 digits';
    }
    return null;
  }

  static String? decimalAmount(String? value, {String label = 'Amount'}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      return '$label must be a valid number';
    }
    if (parsed < 0) {
      return '$label cannot be negative';
    }
    return null;
  }

  static String? name(String? value, {bool required = false}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? 'Name is required' : null;
    }
    if (trimmed.length > 200) {
      return 'Name must be 200 characters or fewer';
    }
    return null;
  }

  /// Used to clear API field errors once the user fixes the input.
  static bool fieldLooksValid(String field, String value) {
    final trimmed = value.trim();

    switch (field) {
      case 'full_name':
        return fullName(trimmed) == null;
      case 'mobile':
      case 'contact_mobile':
        if (trimmed.isEmpty) return true;
        return mobile(trimmed) == null;
      case 'email':
        return email(trimmed) == null;
      case 'aadhaar_number':
        if (trimmed.isEmpty) return true;
        return aadhaar(trimmed) == null;
      case 'pan_number':
        return pan(trimmed) == null;
      case 'pincode':
        if (trimmed.isEmpty) return true;
        return pincode(trimmed) == null;
      case 'monthly_income':
      case 'loan_amount':
      case 'emi_amount':
      case 'outstanding_amount':
        if (trimmed.isEmpty) return true;
        return decimalAmount(trimmed) == null;
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
}
