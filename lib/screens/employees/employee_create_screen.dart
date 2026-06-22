import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/session_bootstrap.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/employees/employee_service.dart';
import 'package:sawaliyatrader/core/employees/models/branch_option.dart';
import 'package:sawaliyatrader/core/employees/models/employee_employment_history.dart';
import 'package:sawaliyatrader/core/employees/models/employee_register_request.dart';
import 'package:sawaliyatrader/core/employees/models/role_option.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_date_form_field.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';
import 'package:sawaliyatrader/core/widgets/app_next_button.dart';
import 'package:sawaliyatrader/core/widgets/app_person_dropdowns.dart';
import 'package:sawaliyatrader/core/widgets/app_photo_picker.dart';
import 'package:sawaliyatrader/core/widgets/app_success_message.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/widgets/upper_case_text_input_formatter.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/widgets/wizard_step_indicator.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class EmployeeCreateScreen extends StatefulWidget implements HasInitialSession {
  const EmployeeCreateScreen({super.key, this.initialSession});

  @override
  final LoginResponse? initialSession;

  @override
  State<EmployeeCreateScreen> createState() => _EmployeeCreateScreenState();
}

class _EmployeeCreateScreenState extends State<EmployeeCreateScreen>
    with SessionBootstrapMixin {
  final _employeeService = EmployeeService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoadingOptions = true;
  bool _isSaving = false;
  int _step = 0;
  int? _employeeId;
  String? _registeredEmployeeName;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _sameAsPresentAddress = true;
  String? _generalError;
  Map<String, String> _fieldErrors = const {};
  bool _autoValidate = false;

  List<RoleOption> _roles = [];
  List<BranchOption> _branches = [];
  int? _selectedRoleId;
  int? _selectedBranchId;
  String _gender = 'MALE';
  String _maritalStatus = 'SINGLE';

  DateTime? _dateOfBirth;
  DateTime? _appointmentDate;
  DateTime? _joiningDate;
  DateTime? _confirmationDate;
  DateTime? _payableFromDate;
  PickedImage? _employeePhoto;

  final _employeeCodeController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _nationalityController = TextEditingController(text: 'Indian');
  final _languagesController = TextEditingController();
  final _mobileController = TextEditingController();
  final _secondaryMobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _panController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _permanentAddressController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _educationController = TextEditingController();
  final _professionalController = TextEditingController();
  final _membersInFamilyController = TextEditingController();
  final _performanceAppraisalController = TextEditingController();
  final _warningNotesController = TextEditingController();
  final _remarksController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _emergencyMobileController = TextEditingController();

  final _historyOrganizationController = TextEditingController();
  final _historyDesignationController = TextEditingController();
  final _historyAnnualCtcController = TextEditingController();
  DateTime? _historyServiceFrom;
  DateTime? _historyServiceTo;
  final List<EmployeeEmploymentHistory> _savedHistories = [];

  static const _fieldStepMap = <String, int>{
    'employee_code': 0,
    'role': 0,
    'branch': 0,
    'first_name': 0,
    'last_name': 0,
    'father_name': 0,
    'date_of_birth': 0,
    'place_of_birth': 0,
    'gender': 0,
    'marital_status': 0,
    'nationality': 0,
    'languages_known': 0,
    'members_in_family': 0,
    'employee_photo': 0,
    'date_of_appointment': 1,
    'date_of_joining': 1,
    'date_of_confirmation': 1,
    'payable_from_date': 1,
    'performance_appraisal': 1,
    'warning_notes': 1,
    'aadhaar_card_no': 2,
    'pan_card_no': 2,
    'primary_mobile_number': 2,
    'secondary_mobile_number': 2,
    'email': 2,
    'password': 2,
    'present_address': 3,
    'permanent_address': 3,
    'height_cm': 3,
    'weight_kg': 3,
    'blood_group': 3,
    'educational_qualifications': 3,
    'professional_qualifications': 3,
    'remarks': 3,
    'emergency_contact_name': 3,
    'emergency_contact_relation': 3,
    'emergency_contact_number': 3,
  };

  @override
  void initState() {
    super.initState();
    _bindFieldErrorClearing();
    initSessionBootstrap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resolveSessionFromContext();
  }

  @override
  void onSessionReady(LoginResponse activeSession) {
    _bootstrapOptions(activeSession);
  }

  @override
  void onSessionMissing() {
    setState(() => _isLoadingOptions = false);
  }

  void _bindFieldErrorClearing() {
    final bindings = <TextEditingController, String>{
      _employeeCodeController: 'employee_code',
      _firstNameController: 'first_name',
      _lastNameController: 'last_name',
      _fatherNameController: 'father_name',
      _placeOfBirthController: 'place_of_birth',
      _nationalityController: 'nationality',
      _languagesController: 'languages_known',
      _aadhaarController: 'aadhaar_card_no',
      _panController: 'pan_card_no',
      _mobileController: 'primary_mobile_number',
      _secondaryMobileController: 'secondary_mobile_number',
      _emailController: 'email',
      _passwordController: 'password',
      _presentAddressController: 'present_address',
      _permanentAddressController: 'permanent_address',
      _heightController: 'height_cm',
      _weightController: 'weight_kg',
      _bloodGroupController: 'blood_group',
      _educationController: 'educational_qualifications',
      _professionalController: 'professional_qualifications',
      _membersInFamilyController: 'members_in_family',
      _performanceAppraisalController: 'performance_appraisal',
      _warningNotesController: 'warning_notes',
      _remarksController: 'remarks',
      _emergencyNameController: 'emergency_contact_name',
      _emergencyRelationController: 'emergency_contact_relation',
      _emergencyMobileController: 'emergency_contact_number',
    };

    for (final entry in bindings.entries) {
      entry.key.addListener(() {
        _maybeClearFieldError(entry.value, entry.key.text);
      });
    }

    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    if (!_autoValidate) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _formKey.currentState?.validate();
    });
  }

  @override
  void dispose() {
    _employeeCodeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _placeOfBirthController.dispose();
    _nationalityController.dispose();
    _languagesController.dispose();
    _mobileController.dispose();
    _secondaryMobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _aadhaarController.dispose();
    _panController.dispose();
    _presentAddressController.dispose();
    _permanentAddressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bloodGroupController.dispose();
    _educationController.dispose();
    _professionalController.dispose();
    _membersInFamilyController.dispose();
    _performanceAppraisalController.dispose();
    _warningNotesController.dispose();
    _remarksController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyMobileController.dispose();
    _historyOrganizationController.dispose();
    _historyDesignationController.dispose();
    _historyAnnualCtcController.dispose();
    super.dispose();
  }

  Future<void> _bootstrapOptions(LoginResponse activeSession) async {
    final permissions = PermissionService(activeSession);

    try {
      final rolesFuture = _employeeService.fetchRoles(session: activeSession);
      final branchesFuture = permissions.canManageBranches
          ? _employeeService.fetchBranches(session: activeSession)
          : Future<List<BranchOption>>.value(const []);

      final results = await Future.wait([rolesFuture, branchesFuture]);
      final roles = (results[0] as List<RoleOption>)
          .where((role) => role.id > 0)
          .toList();
      final branches = (results[1] as List<BranchOption>)
          .where((branch) => branch.id != null)
          .toList();

      if (!mounted) return;
      setState(() {
        _roles = roles;
        _branches = branches;
        _selectedRoleId = roles.isNotEmpty ? roles.first.id : null;
        _selectedBranchId = branches.isNotEmpty ? branches.first.id : null;
        _isLoadingOptions = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoadingOptions = false;
        _generalError = error.toString();
      });
    }
  }

  String? _apiError(String field) => _fieldErrors[field];

  void _clearFieldError(String field) {
    if (!_fieldErrors.containsKey(field)) return;
    setState(() {
      _fieldErrors = Map<String, String>.from(_fieldErrors)..remove(field);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _formKey.currentState?.validate();
    });
  }

  void _maybeClearFieldError(String field, String value) {
    if (!_fieldErrors.containsKey(field)) return;
    if (!_fieldInputLooksValid(field, value)) return;
    _clearFieldError(field);
  }

  bool _fieldInputLooksValid(String field, String value) {
    final trimmed = value.trim();

    switch (field) {
      case 'password':
        return trimmed.length >= 8 && RegExp(r'[A-Z]').hasMatch(trimmed);
      case 'primary_mobile_number':
        return CustomerValidators.mobileLooksValid(trimmed, required: true);
      case 'secondary_mobile_number':
        return CustomerValidators.mobileLooksValid(trimmed, required: true);
      case 'emergency_contact_number':
        return CustomerValidators.mobileLooksValid(trimmed, required: true);
      case 'father_name':
      case 'place_of_birth':
      case 'present_address':
      case 'permanent_address':
      case 'emergency_contact_name':
      case 'emergency_contact_relation':
        return trimmed.isNotEmpty;
      case 'aadhaar_card_no':
        return CustomerValidators.aadhaarLooksValid(trimmed, required: true);
      case 'height_cm':
        if (trimmed.isEmpty) return false;
        final height = double.tryParse(trimmed);
        return height != null && height >= 30;
      case 'email':
        return trimmed.isNotEmpty && trimmed.contains('@');
      case 'first_name':
      case 'last_name':
        return trimmed.isNotEmpty;
      case 'pan_card_no':
        return CustomerValidators.panLooksValid(trimmed, required: true);
      default:
        return trimmed.isNotEmpty;
    }
  }

  void _setFieldError(String field, String message) {
    setState(() {
      _fieldErrors = Map<String, String>.from(_fieldErrors)..[field] = message;
      _generalError = null;
      _autoValidate = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _formKey.currentState?.validate();
    });
  }

  void _applyApiErrors(ApiException error) {
    setState(() {
      _fieldErrors = error.fieldErrors;
      _generalError = error.hasFieldErrors ? null : error.message;
      _autoValidate = true;
      if (error.hasFieldErrors) {
        final firstField = error.fieldErrors.keys.first;
        _step = _fieldStepMap[firstField] ?? _step;
      }
    });
    if (error.hasFieldErrors) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.validate();
      });
    }
  }

  bool _validateEmployeePersonalStep() {
    final l10n = context.l10n;
    var valid = true;

    if (_employeePhoto == null || _employeePhoto!.isEmpty) {
      _setFieldError('employee_photo', l10n.employeePhotoRequired);
      valid = false;
    }
    if (_fatherNameController.text.trim().isEmpty) {
      _setFieldError('father_name', l10n.fatherNameRequired);
      valid = false;
    }
    if (_placeOfBirthController.text.trim().isEmpty) {
      _setFieldError('place_of_birth', l10n.placeOfBirthRequired);
      valid = false;
    }
    final genderError = CustomerValidators.gender(l10n, _gender);
    if (genderError != null) {
      _setFieldError('gender', genderError);
      valid = false;
    }
    final maritalError = CustomerValidators.maritalStatus(l10n, _maritalStatus);
    if (maritalError != null) {
      _setFieldError('marital_status', maritalError);
      valid = false;
    }
    final nationalityError = CustomerValidators.requiredText(
      l10n,
      _nationalityController.text,
      l10n.nationality,
    );
    if (nationalityError != null) {
      _setFieldError('nationality', nationalityError);
      valid = false;
    }
    final languagesError = CustomerValidators.requiredText(
      l10n,
      _languagesController.text,
      l10n.languagesKnown,
    );
    if (languagesError != null) {
      _setFieldError('languages_known', languagesError);
      valid = false;
    }
    final membersText = _membersInFamilyController.text.trim();
    if (membersText.isEmpty) {
      _setFieldError('members_in_family', l10n.required);
      valid = false;
    } else if (int.tryParse(membersText) == null) {
      _setFieldError('members_in_family', l10n.invalidNumber);
      valid = false;
    }

    return valid;
  }

  bool _validateAssessmentStep() {
    final l10n = context.l10n;
    var valid = true;

    final appraisalError = CustomerValidators.requiredText(
      l10n,
      _performanceAppraisalController.text,
      l10n.performanceAppraisal,
    );
    if (appraisalError != null) {
      _setFieldError('performance_appraisal', appraisalError);
      valid = false;
    }
    final warningError = CustomerValidators.requiredText(
      l10n,
      _warningNotesController.text,
      l10n.warningNotes,
    );
    if (warningError != null) {
      _setFieldError('warning_notes', warningError);
      valid = false;
    }

    return valid;
  }

  bool _validateProfileStep() {
    final l10n = context.l10n;
    var valid = true;

    if (_presentAddressController.text.trim().isEmpty) {
      _setFieldError('present_address', l10n.presentAddressRequired);
      valid = false;
    }
    if (!_sameAsPresentAddress &&
        _permanentAddressController.text.trim().isEmpty) {
      _setFieldError('permanent_address', l10n.permanentAddressRequired);
      valid = false;
    }
    final heightText = _heightController.text.trim();
    if (heightText.isEmpty) {
      _setFieldError('height_cm', l10n.required);
      valid = false;
    } else {
      final height = double.tryParse(heightText);
      if (height == null || height < 30) {
        _setFieldError('height_cm', l10n.heightMin);
        valid = false;
      }
    }
    final weightText = _weightController.text.trim();
    if (weightText.isEmpty) {
      _setFieldError('weight_kg', l10n.required);
      valid = false;
    } else if (double.tryParse(weightText) == null) {
      _setFieldError('weight_kg', l10n.invalidNumber);
      valid = false;
    }
    final bloodGroupError = CustomerValidators.requiredText(
      l10n,
      _bloodGroupController.text,
      l10n.bloodGroup,
    );
    if (bloodGroupError != null) {
      _setFieldError('blood_group', bloodGroupError);
      valid = false;
    }
    final educationError = CustomerValidators.requiredText(
      l10n,
      _educationController.text,
      l10n.educationalQualifications,
    );
    if (educationError != null) {
      _setFieldError('educational_qualifications', educationError);
      valid = false;
    }
    final professionalError = CustomerValidators.requiredText(
      l10n,
      _professionalController.text,
      l10n.professionalQualifications,
    );
    if (professionalError != null) {
      _setFieldError('professional_qualifications', professionalError);
      valid = false;
    }
    final remarksError = CustomerValidators.requiredText(
      l10n,
      _remarksController.text,
      l10n.remarks,
    );
    if (remarksError != null) {
      _setFieldError('remarks', remarksError);
      valid = false;
    }
    if (_emergencyNameController.text.trim().isEmpty) {
      _setFieldError('emergency_contact_name', l10n.contactNameRequired);
      valid = false;
    }
    if (_emergencyRelationController.text.trim().isEmpty) {
      _setFieldError('emergency_contact_relation', l10n.relationRequired);
      valid = false;
    }
    final emergencyMobileError = CustomerValidators.mobile(
      l10n,
      _emergencyMobileController.text,
      required: true,
    );
    if (emergencyMobileError != null) {
      _setFieldError('emergency_contact_number', emergencyMobileError);
      valid = false;
    }

    return valid;
  }

  Future<void> _pickDate({
    required ValueChanged<DateTime> onPicked,
    DateTime? initial,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(1960),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        final colors = context.appColors;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: colors.gold,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) onPicked(picked);
  }

  Future<void> _pickEmployeePhoto() async {
    final picked = await PickedImage.pick();
    if (picked == null) return;
    setState(() {
      _employeePhoto = picked;
      _fieldErrors = Map<String, String>.from(_fieldErrors)
        ..remove('employee_photo');
    });
  }

  void _clearEmployeePhoto() {
    setState(() {
      _employeePhoto = null;
      _fieldErrors = Map<String, String>.from(_fieldErrors)
        ..remove('employee_photo');
    });
  }

  Future<void> _onNext() async {
    if (!_autoValidate) {
      setState(() => _autoValidate = true);
    }

    if (_step <= 2) {
      if (_step == 0) {
        if (_selectedRoleId == null) {
          _setFieldError('role', context.l10n.pleaseSelectRole);
        }
        if (_selectedBranchId == null) {
          _setFieldError('branch', context.l10n.pleaseSelectBranch);
        }
        final stepValid = _validateEmployeePersonalStep();
        final formValid = _formKey.currentState!.validate();
        if (_selectedRoleId == null ||
            _selectedBranchId == null ||
            !stepValid ||
            !formValid) {
          return;
        }
      } else if (_step == 1) {
        final stepValid = _validateAssessmentStep();
        final formValid = _formKey.currentState!.validate();
        if (!stepValid || !formValid) return;
      } else if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() {
        _step += 1;
        _generalError = null;
        _fieldErrors = const {};
      });
      return;
    }

    if (_step == 3) {
      if (!_formKey.currentState!.validate()) return;
      if (!_validateProfileStep()) return;
      await _registerEmployeeStep();
      return;
    }

    if (_step == 4) {
      await _finishWizard();
    }
  }

  void _onBack() {
    if (_step == 0) {
      context.pop();
      return;
    }
    if (_step == 4 && _employeeId != null) {
      return;
    }
    setState(() {
      _step -= 1;
      _generalError = null;
      _fieldErrors = const {};
    });
  }

  bool _employmentHistoryFormHasData() {
    return _historyOrganizationController.text.trim().isNotEmpty ||
        _historyDesignationController.text.trim().isNotEmpty ||
        _historyAnnualCtcController.text.trim().isNotEmpty ||
        _historyServiceFrom != null ||
        _historyServiceTo != null;
  }

  bool _validateEmploymentHistoryForm() {
    final l10n = context.l10n;
    var valid = true;

    if (_historyOrganizationController.text.trim().isEmpty) {
      _setFieldError('organization_name', l10n.organizationNameRequired);
      valid = false;
    }
    if (_historyDesignationController.text.trim().isEmpty) {
      _setFieldError('designation', l10n.designationRequired);
      valid = false;
    }
    if (_historyServiceFrom == null) {
      _setFieldError('service_from', l10n.serviceFromRequired);
      valid = false;
    }
    if (_historyServiceTo == null) {
      _setFieldError('service_to', l10n.serviceToRequired);
      valid = false;
    }
    if (_historyServiceFrom != null &&
        _historyServiceTo != null &&
        _historyServiceTo!.isBefore(_historyServiceFrom!)) {
      _setFieldError('service_to', l10n.serviceToAfterFrom);
      valid = false;
    }
    final ctc = _historyAnnualCtcController.text.trim();
    if (ctc.isEmpty) {
      _setFieldError('annual_ctc', l10n.annualCtcRequired);
      valid = false;
    } else if (double.tryParse(ctc) == null) {
      _setFieldError('annual_ctc', l10n.enterValidAmount);
      valid = false;
    }

    return valid;
  }

  EmployeeEmploymentHistory _buildEmploymentHistoryPayload({required int id}) {
    return EmployeeEmploymentHistory(
      id: id,
      employeeId: _employeeId ?? 0,
      organizationName: _historyOrganizationController.text.trim(),
      designation: _emptyToNull(_historyDesignationController.text),
      serviceFrom: _historyServiceFrom,
      serviceTo: _historyServiceTo,
      annualCtc: _emptyToNull(_historyAnnualCtcController.text),
    );
  }

  void _clearEmploymentHistoryForm() {
    _historyOrganizationController.clear();
    _historyDesignationController.clear();
    _historyAnnualCtcController.clear();
    setState(() {
      _historyServiceFrom = null;
      _historyServiceTo = null;
      _fieldErrors = Map<String, String>.from(_fieldErrors)
        ..remove('organization_name')
        ..remove('service_from')
        ..remove('service_to')
        ..remove('annual_ctc');
    });
  }

  Future<void> _saveEmploymentHistoryEntry({required bool clearAfterSave}) async {
    final activeSession = session;
    final employeeId = _employeeId;
    if (activeSession == null || employeeId == null || _isSaving) return;

    if (!_autoValidate) setState(() => _autoValidate = true);
    if (!_formKey.currentState!.validate()) return;
    if (!_validateEmploymentHistoryForm()) return;

    setState(() {
      _isSaving = true;
      _generalError = null;
    });

    try {
      final saved = await _employeeService.addEmploymentHistory(
        session: activeSession,
        employeeId: employeeId,
        payload: _buildEmploymentHistoryPayload(id: 0).toPayload(),
      );

      if (!mounted) return;
      setState(() {
        _savedHistories.add(saved);
        if (clearAfterSave) {
          _clearEmploymentHistoryForm();
        }
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      _applyApiErrors(error);
    } catch (error) {
      if (!mounted) return;
      setState(() => _generalError = error.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _registerEmployeeStep() async {
    final activeSession = session;
    if (activeSession == null || _isSaving) return;

    setState(() {
      _isSaving = true;
      _generalError = null;
      _fieldErrors = const {};
    });

    try {
      final presentAddress = _emptyToNull(_presentAddressController.text);
      final permanentAddress = _sameAsPresentAddress
          ? presentAddress
          : _emptyToNull(_permanentAddressController.text);

      final request = EmployeeRegisterRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        roleId: _selectedRoleId!,
        branchId: _selectedBranchId!,
        employeeCode: _employeeCodeController.text.trim().toUpperCase(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        fatherName: _emptyToNull(_fatherNameController.text),
        dateOfBirth: _dateOfBirth,
        placeOfBirth: _emptyToNull(_placeOfBirthController.text),
        gender: _gender,
        maritalStatus: _maritalStatus,
        nationality: _emptyToNull(_nationalityController.text),
        languagesKnown: _emptyToNull(_languagesController.text),
        aadhaarCardNo: _emptyToNull(_aadhaarController.text),
        panCardNo: _emptyToNull(_panController.text),
        primaryMobileNumber: _emptyToNull(_mobileController.text),
        secondaryMobileNumber: _emptyToNull(_secondaryMobileController.text),
        presentAddress: presentAddress,
        permanentAddress: permanentAddress,
        heightCm: _emptyToNull(_heightController.text),
        weightKg: _emptyToNull(_weightController.text),
        bloodGroup: _emptyToNull(_bloodGroupController.text),
        dateOfAppointment: _appointmentDate ?? _joiningDate,
        dateOfJoining: _joiningDate,
        dateOfConfirmation: _confirmationDate ?? _joiningDate,
        payableFromDate: _payableFromDate ?? _joiningDate,
        performanceAppraisal: _emptyToNull(_performanceAppraisalController.text),
        warningNotes: _emptyToNull(_warningNotesController.text),
        remarks: _emptyToNull(_remarksController.text),
        educationalQualifications: _emptyToNull(_educationController.text),
        professionalQualifications: _emptyToNull(_professionalController.text),
        membersInFamily: int.tryParse(_membersInFamilyController.text.trim()),
        emergencyContactName: _emptyToNull(_emergencyNameController.text),
        emergencyContactRelation: _emptyToNull(_emergencyRelationController.text),
        emergencyContactNumber: _emptyToNull(_emergencyMobileController.text),
      );

      final created = await _employeeService.registerEmployee(
        session: activeSession,
        request: request,
        employeePhoto: _employeePhoto,
      );

      if (!mounted) return;
      setState(() {
        _employeeId = created.id;
        _registeredEmployeeName = created.displayName;
        _step = 4;
        _fieldErrors = const {};
        _generalError = null;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      _applyApiErrors(error);
    } catch (error) {
      if (!mounted) return;
      setState(() => _generalError = error.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _finishWizard() async {
    if (_isSaving) return;

    if (_savedHistories.isEmpty) {
      if (!_autoValidate) setState(() => _autoValidate = true);
      if (!_formKey.currentState!.validate()) return;
      if (!_validateEmploymentHistoryForm()) return;
      await _saveEmploymentHistoryEntry(clearAfterSave: false);
      if (!mounted || _generalError != null || _fieldErrors.isNotEmpty) {
        return;
      }
    } else if (_employmentHistoryFormHasData()) {
      if (!_validateEmploymentHistoryForm()) return;
      await _saveEmploymentHistoryEntry(clearAfterSave: false);
      if (!mounted || _generalError != null || _fieldErrors.isNotEmpty) {
        return;
      }
    }

    if (!mounted) return;
    final l10n = context.l10n;
    await showAppSuccessMessage(
      context,
      message: l10n.employeeSaved(
        _registeredEmployeeName ?? l10n.employeeRegistered,
      ),
    );
    if (!mounted) return;
    context.pop(true);
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final isReady = session != null && !_isLoadingOptions;
    final l10n = context.l10n;
    final steps = employeeWizardSteps(l10n);

    return Scaffold(
      appBar: ThemedAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appColors.shinyGold),
          onPressed: _onBack,
        ),
        title: l10n.newEmployee,
      ),
      body: !isReady
          ? const Center(child: AppLoader(size: kAppPageLoaderSize))
          : SessionScope(
              session: session!,
              child: Column(
                children: [
                  WizardStepIndicator(steps: steps, currentStep: _step),
                  Expanded(
                    child: SingleChildScrollView(
                      key: ValueKey(_step),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidate
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              steps[_step],
                              style: AppTextStyles.label(context),
                            ),
                            if (_step == 4) ...[
                              const SizedBox(height: 8),
                              Text(
                                l10n.employmentHistoryOptional,
                                style: AppTextStyles.body(context).copyWith(
                                  color: context.appColors.textSecondary,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            _buildStepContent(),
                            if (_generalError != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _generalError!,
                                style: AppTextStyles.body(context).copyWith(
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Row(
                        children: [
                          if (_step > 0 &&
                              !(_step == 4 && _employeeId != null)) ...[
                            OutlinedButton(
                              onPressed: _isSaving ? null : _onBack,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: context.appColors.shinyGold,
                                side: BorderSide(
                                  color: context.appColors.shinyGold,
                                ),
                                minimumSize: const Size(110, 40),
                              ),
                              child: Text(l10n.previous),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (_step == 4) ...[
                            OutlinedButton(
                              onPressed: _isSaving
                                  ? null
                                  : () => _saveEmploymentHistoryEntry(
                                        clearAfterSave: true,
                                      ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: context.appColors.shinyGold,
                                side: BorderSide(
                                  color: context.appColors.shinyGold,
                                ),
                                minimumSize: const Size(120, 40),
                              ),
                              child: Text(l10n.addRecord),
                            ),
                            const SizedBox(width: 12),
                          ],
                          const Spacer(),
                          AppNextButton(
                            isLastStep: _step == steps.length - 1,
                            isLoading: _isSaving,
                            onPressed: _isSaving ? null : _onNext,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStepContent() {
    return switch (_step) {
      0 => _buildEmployeePersonalStep(),
      1 => _buildAssessmentStep(),
      2 => _buildIdentityLoginStep(),
      3 => _buildProfileStep(),
      _ => _buildEmploymentHistoryStep(),
    };
  }

  Widget _buildEmployeePersonalStep() {
    final l10n = context.l10n;
    return Column(
      children: [
        _SectionCard(
          title: l10n.employmentDetails,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _roles.isEmpty
                      ? Text(
                          l10n.noRolesAvailable,
                          style: AppTextStyles.body(context).copyWith(
                            color: Colors.red.shade700,
                          ),
                        )
                      : AppDropdownFormField<int>(
                          value: _selectedRoleId,
                          decoration: AppDropdownDecoration.formField(
                            context,
                            labelText: l10n.role,
                          ).copyWith(errorText: _apiError('role')),
                          validator: (value) =>
                              _apiError('role') ??
                              (value == null ? l10n.pleaseSelectRole : null),
                          items: _roles
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role.id,
                                  child: Text(
                                    '${role.name} (${role.code})',
                                    style: AppTextStyles.body(context),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            _clearFieldError('role');
                            setState(() => _selectedRoleId = value);
                          },
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _branches.isEmpty
                      ? Text(
                          l10n.noBranchesForAssignment,
                          style: AppTextStyles.body(context).copyWith(
                            color: Colors.red.shade700,
                          ),
                        )
                      : AppDropdownFormField<int>(
                          value: _selectedBranchId,
                          decoration: AppDropdownDecoration.formField(
                            context,
                            labelText: l10n.branchLabel,
                          ).copyWith(errorText: _apiError('branch')),
                          validator: (value) =>
                              _apiError('branch') ??
                              (value == null ? l10n.pleaseSelectBranch : null),
                          items: _branches
                              .map(
                                (branch) => DropdownMenuItem(
                                  value: branch.id,
                                  child: Text(
                                    branch.label,
                                    style: AppTextStyles.body(context),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            _clearFieldError('branch');
                            setState(() => _selectedBranchId = value);
                          },
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _employeeCodeController,
              label: l10n.employeeCode,
              hint: context.l10n.employeeCodeHint,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: const [UpperCaseTextInputFormatter()],
              externalError: _apiError('employee_code'),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return l10n.employeeCodeRequired;
                }
                if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(trimmed)) {
                  return l10n.employeeCodeFormat;
                }
                return null;
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: l10n.personalDetails,
          children: [
            AppPhotoPicker(
              label: context.l10n.employeePhoto,
              hint: l10n.uploadProfilePhoto,
              placeholderIcon: Icons.person_outline,
              image: _employeePhoto,
              errorText: _apiError('employee_photo'),
              onPick: _pickEmployeePhoto,
              onClear:
                  _employeePhoto?.isNotEmpty == true ? _clearEmployeePhoto : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _firstNameController,
              label: context.l10n.firstName,
              textInputAction: TextInputAction.next,
              externalError: _apiError('first_name'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l10n.firstNameRequired : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _lastNameController,
              label: context.l10n.lastName,
              textInputAction: TextInputAction.next,
              externalError: _apiError('last_name'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l10n.lastNameRequired : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _fatherNameController,
              label: l10n.fatherName,
              textInputAction: TextInputAction.next,
              externalError: _apiError('father_name'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.fatherNameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            _DateField(
              label: l10n.dateOfBirth,
              value: _dateOfBirth,
              errorText: _apiError('date_of_birth'),
              validator: (value) =>
                  value == null ? l10n.dateOfBirthRequired : null,
              onTap: () => _pickDate(
                initial: _dateOfBirth,
                onPicked: (date) {
                  _clearFieldError('date_of_birth');
                  setState(() => _dateOfBirth = date);
                },
              ),
              onClear: _dateOfBirth == null
                  ? null
                  : () {
                      _clearFieldError('date_of_birth');
                      setState(() => _dateOfBirth = null);
                    },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _placeOfBirthController,
              label: l10n.placeOfBirth,
              textInputAction: TextInputAction.next,
              externalError: _apiError('place_of_birth'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.placeOfBirthRequired
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppDropdownFormField<String>(
                    value: _gender,
                    decoration: AppDropdownDecoration.formField(
                      context,
                      labelText: l10n.gender,
                    ).copyWith(errorText: _apiError('gender')),
                    validator: (value) =>
                        _apiError('gender') ??
                        CustomerValidators.gender(l10n, value),
                    items: genderDropdownItems(context),
                    onChanged: (value) {
                      if (value != null) {
                        _clearFieldError('gender');
                        setState(() => _gender = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppDropdownFormField<String>(
                    value: _maritalStatus,
                    decoration: AppDropdownDecoration.formField(
                      context,
                      labelText: l10n.maritalStatus,
                    ).copyWith(errorText: _apiError('marital_status')),
                    validator: (value) =>
                        _apiError('marital_status') ??
                        CustomerValidators.maritalStatus(l10n, value),
                    items: maritalStatusDropdownItems(context),
                    onChanged: (value) {
                      if (value != null) {
                        _clearFieldError('marital_status');
                        setState(() => _maritalStatus = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _nationalityController,
              label: l10n.nationality,
              textInputAction: TextInputAction.next,
              externalError: _apiError('nationality'),
              validator: (v) =>
                  CustomerValidators.requiredText(l10n, v, l10n.nationality),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _languagesController,
              label: l10n.languagesKnown,
              textInputAction: TextInputAction.next,
              externalError: _apiError('languages_known'),
              validator: (v) =>
                  CustomerValidators.requiredText(l10n, v, l10n.languagesKnown),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _membersInFamilyController,
              label: l10n.membersInFamily,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              externalError: _apiError('members_in_family'),
              validator: (v) {
                final trimmed = v?.trim() ?? '';
                if (trimmed.isEmpty) return l10n.required;
                if (int.tryParse(trimmed) == null) return l10n.invalidNumber;
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAssessmentStep() {
    final l10n = context.l10n;
    return _SectionCard(
      title: l10n.assignmentAndAssessment,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DateField(
                label: l10n.dateOfAppointment,
                value: _appointmentDate,
                errorText: _apiError('date_of_appointment'),
                validator: (value) =>
                    value == null ? l10n.dateOfAppointmentRequired : null,
                compact: true,
                onTap: () => _pickDate(
                  initial: _appointmentDate ?? _joiningDate,
                  onPicked: (date) {
                    _clearFieldError('date_of_appointment');
                    setState(() => _appointmentDate = date);
                  },
                ),
                onClear: _appointmentDate == null
                    ? null
                    : () {
                        _clearFieldError('date_of_appointment');
                        setState(() => _appointmentDate = null);
                      },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateField(
                label: l10n.dateOfJoining,
                value: _joiningDate,
                errorText: _apiError('date_of_joining'),
                validator: (value) =>
                    value == null ? l10n.dateOfJoiningRequired : null,
                compact: true,
                onTap: () => _pickDate(
                  initial: _joiningDate,
                  onPicked: (date) {
                    _clearFieldError('date_of_joining');
                    setState(() => _joiningDate = date);
                  },
                ),
                onClear: _joiningDate == null
                    ? null
                    : () {
                        _clearFieldError('date_of_joining');
                        setState(() => _joiningDate = null);
                      },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DateField(
                label: l10n.dateOfConfirmation,
                value: _confirmationDate,
                errorText: _apiError('date_of_confirmation'),
                validator: (value) =>
                    value == null ? l10n.dateOfConfirmationRequired : null,
                compact: true,
                onTap: () => _pickDate(
                  initial: _confirmationDate ?? _joiningDate,
                  onPicked: (date) {
                    _clearFieldError('date_of_confirmation');
                    setState(() => _confirmationDate = date);
                  },
                ),
                onClear: _confirmationDate == null
                    ? null
                    : () {
                        _clearFieldError('date_of_confirmation');
                        setState(() => _confirmationDate = null);
                      },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateField(
                label: l10n.payableFromDate,
                value: _payableFromDate,
                errorText: _apiError('payable_from_date'),
                validator: (value) =>
                    value == null ? l10n.payableFromDateRequired : null,
                compact: true,
                onTap: () => _pickDate(
                  initial: _payableFromDate ?? _joiningDate,
                  onPicked: (date) {
                    _clearFieldError('payable_from_date');
                    setState(() => _payableFromDate = date);
                  },
                ),
                onClear: _payableFromDate == null
                    ? null
                    : () {
                        _clearFieldError('payable_from_date');
                        setState(() => _payableFromDate = null);
                      },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _performanceAppraisalController,
          label: l10n.performanceAppraisal,
          textInputAction: TextInputAction.next,
          externalError: _apiError('performance_appraisal'),
          validator: (v) =>
              CustomerValidators.requiredText(l10n, v, l10n.performanceAppraisal),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _warningNotesController,
          label: l10n.warningNotes,
          textInputAction: TextInputAction.next,
          externalError: _apiError('warning_notes'),
          validator: (v) =>
              CustomerValidators.requiredText(l10n, v, l10n.warningNotes),
        ),
      ],
    );
  }

  Widget _buildIdentityLoginStep() {
    final l10n = context.l10n;
    return Column(
      children: [
        _SectionCard(
          title: l10n.identityAndContact,
          children: [
            AppTextField(
              controller: _aadhaarController,
              label: l10n.aadhaarNumber,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              externalError: _apiError('aadhaar_card_no'),
              validator: (v) => CustomerValidators.aadhaar(l10n, v, required: true),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _panController,
              label: l10n.pan,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: const [UpperCaseTextInputFormatter()],
              externalError: _apiError('pan_card_no'),
              validator: (v) => CustomerValidators.pan(l10n, v, required: true),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _mobileController,
              label: l10n.primaryMobile,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              externalError: _apiError('primary_mobile_number'),
              validator: (v) => CustomerValidators.mobile(l10n, v, required: true),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _secondaryMobileController,
              label: l10n.secondaryMobile,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              externalError: _apiError('secondary_mobile_number'),
              validator: (v) => CustomerValidators.mobile(l10n, v, required: true),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: l10n.loginCredentials,
          children: [
            AppTextField(
              controller: _emailController,
              label: l10n.email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              externalError: _apiError('email'),
              validator: (v) => CustomerValidators.email(l10n, v, required: true),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              label: l10n.password,
              obscureText: _obscurePassword,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              externalError: _apiError('password'),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: context.appColors.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return l10n.passwordRequired;
                }
                if (v.length < 8) {
                  return l10n.passwordMinLength;
                }
                if (!RegExp(r'[A-Z]').hasMatch(v)) {
                  return l10n.passwordUppercase;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _confirmPasswordController,
              label: l10n.confirmPassword,
              obscureText: _obscureConfirmPassword,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: context.appColors.textSecondary,
                ),
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
              validator: (v) {
                final trimmed = v?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return l10n.confirmPasswordRequired;
                }
                if (trimmed != _passwordController.text) {
                  return l10n.passwordsDoNotMatch;
                }
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileStep() {
    final l10n = context.l10n;
    return Column(
      children: [
        _SectionCard(
          title: l10n.address,
          children: [
            AppTextField(
              controller: _presentAddressController,
              label: l10n.presentAddress,
              textInputAction: TextInputAction.next,
              externalError: _apiError('present_address'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.presentAddressRequired
                  : null,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.permanentAddressSame,
                style: AppTextStyles.body(context),
              ),
              value: _sameAsPresentAddress,
              onChanged: (value) =>
                  setState(() => _sameAsPresentAddress = value),
            ),
            if (!_sameAsPresentAddress) ...[
              const SizedBox(height: 8),
              AppTextField(
                controller: _permanentAddressController,
                label: l10n.permanentAddress,
                textInputAction: TextInputAction.next,
                externalError: _apiError('permanent_address'),
                validator: (v) => v == null || v.trim().isEmpty
                    ? l10n.permanentAddressRequired
                    : null,
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: l10n.healthAndQualifications,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _heightController,
                    label: l10n.heightCm,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    externalError: _apiError('height_cm'),
                    validator: (v) {
                      final trimmed = v?.trim() ?? '';
                      if (trimmed.isEmpty) return l10n.required;
                      final height = double.tryParse(trimmed);
                      if (height == null || height < 30) {
                        return l10n.heightMin;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: _weightController,
                    label: l10n.weightKg,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    externalError: _apiError('weight_kg'),
                    validator: (v) {
                      final trimmed = v?.trim() ?? '';
                      if (trimmed.isEmpty) return l10n.required;
                      if (double.tryParse(trimmed) == null) {
                        return l10n.invalidNumber;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _bloodGroupController,
              label: l10n.bloodGroup,
              textInputAction: TextInputAction.next,
              externalError: _apiError('blood_group'),
              validator: (v) =>
                  CustomerValidators.requiredText(l10n, v, l10n.bloodGroup),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _educationController,
              label: l10n.educationalQualifications,
              textInputAction: TextInputAction.next,
              externalError: _apiError('educational_qualifications'),
              validator: (v) => CustomerValidators.requiredText(
                l10n,
                v,
                l10n.educationalQualifications,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _professionalController,
              label: l10n.professionalQualifications,
              textInputAction: TextInputAction.next,
              externalError: _apiError('professional_qualifications'),
              validator: (v) => CustomerValidators.requiredText(
                l10n,
                v,
                l10n.professionalQualifications,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _remarksController,
              label: l10n.remarks,
              textInputAction: TextInputAction.next,
              externalError: _apiError('remarks'),
              validator: (v) => CustomerValidators.requiredText(l10n, v, l10n.remarks),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: l10n.emergencyContact,
          children: [
            AppTextField(
              controller: _emergencyNameController,
              label: l10n.contactName,
              textInputAction: TextInputAction.next,
              externalError: _apiError('emergency_contact_name'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.contactNameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _emergencyRelationController,
              label: l10n.relation,
              textInputAction: TextInputAction.next,
              externalError: _apiError('emergency_contact_relation'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.relationRequired
                  : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _emergencyMobileController,
              label: l10n.contactNumber,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              externalError: _apiError('emergency_contact_number'),
              validator: (v) => CustomerValidators.mobile(l10n, v, required: true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmploymentHistoryStep() {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_savedHistories.isNotEmpty) ...[
          Text(
            l10n.savedRecords,
            style: AppTextStyles.label(context),
          ),
          const SizedBox(height: 12),
          for (final history in _savedHistories)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.appColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.appColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.organizationName,
                    style: AppTextStyles.subtitle(context),
                  ),
                  if (history.designation != null &&
                      history.designation!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      history.designation!,
                      style: AppTextStyles.body(context).copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '${_formatDisplayDate(history.serviceFrom)} — ${_formatDisplayDate(history.serviceTo)}',
                    style: AppTextStyles.body(context),
                  ),
                  if (history.annualCtc != null &&
                      history.annualCtc!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.ctcWithValue(history.annualCtc!),
                      style: AppTextStyles.body(context).copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
        _SectionCard(
          title: context.l10n.previousEmployment,
          children: [
            AppTextField(
              controller: _historyOrganizationController,
              label: context.l10n.organizationName,
              textInputAction: TextInputAction.next,
              externalError: _apiError('organization_name'),
              validator: (v) => CustomerValidators.requiredText(
                context.l10n,
                v,
                context.l10n.organizationName,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _historyDesignationController,
              label: context.l10n.designation,
              textInputAction: TextInputAction.next,
              externalError: _apiError('designation'),
              validator: (v) => CustomerValidators.requiredText(
                context.l10n,
                v,
                context.l10n.designation,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DateField(
                    label: context.l10n.serviceFrom,
                    value: _historyServiceFrom,
                    errorText: _apiError('service_from'),
                    validator: (value) => value == null
                        ? context.l10n.serviceFromRequired
                        : null,
                    compact: true,
                    onTap: () => _pickDate(
                      initial: _historyServiceFrom,
                      onPicked: (date) {
                        _clearFieldError('service_from');
                        setState(() => _historyServiceFrom = date);
                      },
                    ),
                    onClear: _historyServiceFrom == null
                        ? null
                        : () {
                            _clearFieldError('service_from');
                            setState(() => _historyServiceFrom = null);
                          },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateField(
                    label: context.l10n.serviceTo,
                    value: _historyServiceTo,
                    errorText: _apiError('service_to'),
                    validator: (value) =>
                        value == null ? context.l10n.serviceToRequired : null,
                    compact: true,
                    onTap: () => _pickDate(
                      initial: _historyServiceTo ?? _historyServiceFrom,
                      onPicked: (date) {
                        _clearFieldError('service_to');
                        setState(() => _historyServiceTo = date);
                      },
                    ),
                    onClear: _historyServiceTo == null
                        ? null
                        : () {
                            _clearFieldError('service_to');
                            setState(() => _historyServiceTo = null);
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _historyAnnualCtcController,
              label: context.l10n.annualCtc,
              hint: context.l10n.annualCtcHint,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              externalError: _apiError('annual_ctc'),
              validator: (v) {
                final trimmed = v?.trim() ?? '';
                if (trimmed.isEmpty) return context.l10n.annualCtcRequired;
                if (double.tryParse(trimmed) == null) {
                  return context.l10n.enterValidAmount;
                }
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }

  String _formatDisplayDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.label(context)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
    this.errorText,
    this.validator,
    this.compact = false,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? errorText;
  final FormFieldValidator<DateTime?>? validator;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppDateFormField(
      label: label,
      value: value,
      onTap: onTap,
      onClear: onClear,
      errorText: errorText,
      validator: validator,
      compact: compact,
    );
  }
}
