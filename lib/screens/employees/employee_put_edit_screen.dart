import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/employees/employee_put_service.dart';
import 'package:sawaliyatrader/core/employees/employee_service.dart';
import 'package:sawaliyatrader/core/employees/models/branch_option.dart';
import 'package:sawaliyatrader/core/employees/models/employee_detail.dart';
import 'package:sawaliyatrader/core/employees/models/employee_put_request.dart';
import 'package:sawaliyatrader/core/employees/models/role_option.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_date_form_field.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/app_message.dart';
import 'package:sawaliyatrader/core/widgets/app_photo_picker.dart';
import 'package:sawaliyatrader/core/widgets/app_primary_button.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/widgets/upper_case_text_input_formatter.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';

/// Full employee PUT edit form.
///
/// **API:** `PUT /employees/api/{id}/`
/// **Service:** [EmployeePutService]
class EmployeePutEditScreen extends StatefulWidget {
  const EmployeePutEditScreen({
    required this.employeeId,
    this.initialEmployee,
    super.key,
  });

  final int employeeId;
  final EmployeeDetail? initialEmployee;

  @override
  State<EmployeePutEditScreen> createState() => _EmployeePutEditScreenState();
}

class _EmployeePutEditScreenState extends State<EmployeePutEditScreen> {
  final _authService = AuthService();
  final _employeeService = EmployeeService();
  final _putService = EmployeePutService();
  final _formKey = GlobalKey<FormState>();

  LoginResponse? _session;
  bool _isLoading = true;
  bool _isLoadingOptions = true;
  bool _isSaving = false;
  bool _obscurePassword = true;
  bool _sameAsPresentAddress = true;
  String? _error;
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
  String? _existingPhotoUrl;
  String? _employeeCode;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _languagesController = TextEditingController();
  final _mobileController = TextEditingController();
  final _secondaryMobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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

  static const _genderOptions = kGenderOptions;
  static const _maritalOptions = kMaritalStatusOptions;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
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
    super.dispose();
  }

  void _applyEmployee(EmployeeDetail employee) {
    _employeeCode = employee.displayCode;
    _selectedRoleId = employee.roleId;
    _selectedBranchId = _resolveBranchId(employee);
    _gender = employee.gender ?? 'MALE';
    _maritalStatus = employee.maritalStatus ?? 'SINGLE';
    _dateOfBirth = employee.dateOfBirth;
    _appointmentDate = employee.dateOfAppointment;
    _joiningDate = employee.dateOfJoining;
    _confirmationDate = employee.dateOfConfirmation;
    _payableFromDate = employee.payableFromDate;
    _existingPhotoUrl = employee.employeePhoto;
    _employeePhoto = null;

    _firstNameController.text = employee.firstName ?? '';
    _lastNameController.text = employee.lastName ?? '';
    _fatherNameController.text = employee.fatherName ?? '';
    _placeOfBirthController.text = employee.placeOfBirth ?? '';
    _nationalityController.text = employee.nationality ?? 'Indian';
    _languagesController.text = employee.languagesKnown ?? '';
    _mobileController.text = employee.mobile ?? '';
    _secondaryMobileController.text = employee.secondaryMobile ?? '';
    _emailController.text = employee.email ?? '';
    _aadhaarController.text = employee.aadhaarCardNo ?? '';
    _panController.text = employee.panCardNo ?? '';
    _presentAddressController.text = employee.addressLine1 ?? '';
    _permanentAddressController.text = employee.permanentAddress ?? '';
    _sameAsPresentAddress = _permanentAddressController.text.trim().isEmpty ||
        _permanentAddressController.text.trim() ==
            _presentAddressController.text.trim();
    _heightController.text = employee.heightCm ?? '';
    _weightController.text = employee.weightKg ?? '';
    _bloodGroupController.text = employee.bloodGroup ?? '';
    _educationController.text = employee.educationalQualifications ?? '';
    _professionalController.text = employee.professionalQualifications ?? '';
    _membersInFamilyController.text = employee.membersInFamily?.toString() ?? '';
    _performanceAppraisalController.text = employee.performanceAppraisal ?? '';
    _warningNotesController.text = employee.warningNotes ?? '';
    _remarksController.text = employee.remarks ?? '';
    _emergencyNameController.text = employee.emergencyContactName ?? '';
    _emergencyRelationController.text = employee.emergencyContactRelation ?? '';
    _emergencyMobileController.text = employee.emergencyContactNumber ?? '';
  }

  int? _resolveBranchId(EmployeeDetail employee) {
    if (_branches.isEmpty) return null;

    final code = employee.branchCode?.trim().toUpperCase();
    final name = employee.branch.trim().toUpperCase();

    for (final branch in _branches) {
      final id = branch.id;
      if (id == null) continue;
      if (code != null && code.isNotEmpty && branch.code.toUpperCase() == code) {
        return id;
      }
      if (name.isNotEmpty && branch.name.toUpperCase() == name) {
        return id;
      }
    }

    return _branches.first.id;
  }

  Future<void> _load() async {
    final session = await _authService.getSession();
    if (!mounted) return;

    final initialEmployee = widget.initialEmployee;
    if (initialEmployee != null) {
      _applyEmployee(initialEmployee);
    }

    setState(() {
      _session = session;
      _isLoading = initialEmployee == null;
      _isLoadingOptions = true;
      _error = null;
    });

    if (session == null) {
      setState(() {
        _isLoading = false;
        _isLoadingOptions = false;
        _error = context.l10n.sessionUnavailable;
      });
      return;
    }

    await _loadOptions(session);

    if (initialEmployee != null) {
      _applyEmployee(initialEmployee);
      if (mounted) setState(() => _isLoading = false);
      await _fetchEmployee(session);
      return;
    }

    await _fetchEmployee(session);
  }

  Future<void> _loadOptions(LoginResponse session) async {
    final permissions = PermissionService(session);

    try {
      final rolesFuture = _employeeService.fetchRoles(session: session);
      final branchesFuture = permissions.canManageBranches
          ? _employeeService.fetchBranches(session: session)
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
        if (_selectedRoleId == null && roles.isNotEmpty) {
          _selectedRoleId = roles.first.id;
        }
        if (_selectedBranchId == null && branches.isNotEmpty) {
          _selectedBranchId = branches.first.id;
        }
        _isLoadingOptions = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is ApiException ? error.message : error.toString();
        _isLoadingOptions = false;
      });
    }
  }

  Future<void> _fetchEmployee(LoginResponse session) async {
    try {
      final employee = await _employeeService.fetchEmployee(
        session: session,
        employeeId: widget.employeeId,
      );
      if (!mounted) return;
      _applyEmployee(employee);
      setState(() => _error = null);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is ApiException ? error.message : error.toString();
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _apiError(String field) => _fieldErrors[field];

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

  bool _validateNonFormFields() {
    final l10n = context.l10n;
    var valid = true;

    final hasPhoto = (_employeePhoto?.isNotEmpty ?? false) ||
        (_existingPhotoUrl != null && _existingPhotoUrl!.isNotEmpty);
    if (!hasPhoto) {
      _setFieldError('employee_photo', l10n.employeePhotoRequired);
      valid = false;
    }

    return valid;
  }

  void _applyApiErrors(ApiException error) {
    setState(() {
      _fieldErrors = error.fieldErrors;
      _generalError = error.hasFieldErrors ? null : error.message;
      _autoValidate = true;
    });
    if (error.hasFieldErrors) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.validate();
      });
    }
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
    setState(() => _employeePhoto = null);
  }

  bool get _showExistingPhotoPreview {
    final hasNewPhoto = _employeePhoto?.isNotEmpty ?? false;
    final url = _existingPhotoUrl;
    return !hasNewPhoto && url != null && url.isNotEmpty;
  }

  Future<void> _submit() async {
    final session = _session;
    if (session == null || _isSaving) return;

    if (!_autoValidate) {
      setState(() => _autoValidate = true);
    }
    final formValid = _formKey.currentState!.validate();
    final extraValid = _validateNonFormFields();
    if (!formValid || !extraValid) return;

    if (_selectedRoleId == null) {
      _setFieldError('role', context.l10n.pleaseSelectRole);
      return;
    }
    if (_selectedBranchId == null) {
      _setFieldError('branch', context.l10n.pleaseSelectBranch);
      return;
    }
    if (!_sameAsPresentAddress &&
        _permanentAddressController.text.trim().isEmpty) {
      _setFieldError('permanent_address', context.l10n.permanentAddressRequired);
      return;
    }

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

      final request = EmployeePutRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        roleId: _selectedRoleId!,
        branchId: _selectedBranchId!,
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

      final updated = await _putService.putEmployee(
        session: session,
        employeeId: widget.employeeId,
        request: request,
        employeePhoto: _employeePhoto,
      );

      if (!mounted) return;
      await showAppSuccessMessage(
        context,
        message: context.l10n.employeeUpdated(updated.displayName),
      );
      if (!mounted) return;
      context.pop(true);
    } on ApiException catch (error) {
      if (!mounted) return;
      _applyApiErrors(error);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _generalError = error is ApiException ? error.message : error.toString();
      });
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    final l10n = context.l10n;

    return Scaffold(
      appBar: ThemedAppBar(title: context.l10n.editEmployeePut),
      body: session == null || _isLoading
          ? const Center(child: AppLoader(size: kAppPageLoaderSize))
          : SessionScope(
              session: session,
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Text(
                      l10n.employeePutIntro,
                      style: AppTextStyles.body(context).copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    if (_employeeCode != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.employeeCodeReadOnly(_employeeCode!),
                        style: AppTextStyles.subtitle(context),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: AppTextStyles.body(context)
                            .copyWith(color: Colors.red.shade700),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: l10n.roleAndBranch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _isLoadingOptions
                                  ? _DropdownLoadingField(label: l10n.role)
                                  : _roles.isEmpty
                                      ? Text(
                                          l10n.noRolesAvailable,
                                          style: AppTextStyles.body(context)
                                              .copyWith(
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
                                          (value == null
                                              ? l10n.pleaseSelectRole
                                              : null),
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
                                      onChanged: (value) =>
                                          setState(() => _selectedRoleId = value),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _isLoadingOptions
                                  ? _DropdownLoadingField(label: l10n.branchLabel)
                                  : _branches.isEmpty
                                      ? Text(
                                          l10n.noBranchesForAssignment,
                                          style: AppTextStyles.body(context)
                                              .copyWith(
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
                                          (value == null
                                              ? l10n.pleaseSelectBranch
                                              : null),
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
                                      onChanged: (value) =>
                                          setState(() => _selectedBranchId = value),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: l10n.personalDetails,
                      children: [
                        AppPhotoPicker(
                          label: l10n.employeePhoto,
                          existingImageUrl: _showExistingPhotoPreview
                              ? _existingPhotoUrl
                              : null,
                          existingImageLabel: l10n.currentImageCaption('photo'),
                          hint: l10n.chooseNewPhotoHint,
                          placeholderIcon: Icons.person_outline,
                          image: _employeePhoto,
                          errorText: _apiError('employee_photo'),
                          onPick: _pickEmployeePhoto,
                          onClear: _employeePhoto?.isNotEmpty == true
                              ? _clearEmployeePhoto
                              : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _firstNameController,
                          label: l10n.firstName,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('first_name'),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? l10n.firstNameRequired
                              : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _lastNameController,
                          label: l10n.lastName,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('last_name'),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? l10n.lastNameRequired
                              : null,
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
                            onPicked: (date) => setState(() {
                              _dateOfBirth = date;
                              _fieldErrors =
                                  Map<String, String>.from(_fieldErrors)
                                    ..remove('date_of_birth');
                            }),
                          ),
                          onClear: _dateOfBirth == null
                              ? null
                              : () => setState(() => _dateOfBirth = null),
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
                                items: _genderOptions
                                    .map(
                                      (value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          localizedGenderLabel(l10n, value),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _gender = value;
                                      _fieldErrors =
                                          Map<String, String>.from(_fieldErrors)
                                            ..remove('gender');
                                    });
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
                                items: _maritalOptions
                                    .map(
                                      (value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          localizedMaritalStatusLabel(
                                            l10n,
                                            value,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _maritalStatus = value;
                                      _fieldErrors =
                                          Map<String, String>.from(_fieldErrors)
                                            ..remove('marital_status');
                                    });
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
                          validator: (v) => CustomerValidators.requiredText(
                            l10n,
                            v,
                            l10n.languagesKnown,
                          ),
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
                            if (int.tryParse(trimmed) == null) {
                              return l10n.invalidNumber;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: l10n.employmentDatesAssessment,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _DateField(
                                label: l10n.dateOfAppointment,
                                value: _appointmentDate,
                                errorText: _apiError('date_of_appointment'),
                                validator: (value) => value == null
                                    ? l10n.dateOfAppointmentRequired
                                    : null,
                                compact: true,
                                onTap: () => _pickDate(
                                  initial: _appointmentDate ?? _joiningDate,
                                  onPicked: (date) =>
                                      setState(() => _appointmentDate = date),
                                ),
                                onClear: _appointmentDate == null
                                    ? null
                                    : () => setState(() => _appointmentDate = null),
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
                                  onPicked: (date) =>
                                      setState(() => _joiningDate = date),
                                ),
                                onClear: _joiningDate == null
                                    ? null
                                    : () => setState(() => _joiningDate = null),
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
                                validator: (value) => value == null
                                    ? l10n.dateOfConfirmationRequired
                                    : null,
                                compact: true,
                                onTap: () => _pickDate(
                                  initial: _confirmationDate ?? _joiningDate,
                                  onPicked: (date) =>
                                      setState(() => _confirmationDate = date),
                                ),
                                onClear: _confirmationDate == null
                                    ? null
                                    : () =>
                                        setState(() => _confirmationDate = null),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DateField(
                                label: l10n.payableFromDate,
                                value: _payableFromDate,
                                errorText: _apiError('payable_from_date'),
                                validator: (value) => value == null
                                    ? l10n.payableFromDateRequired
                                    : null,
                                compact: true,
                                onTap: () => _pickDate(
                                  initial: _payableFromDate ?? _joiningDate,
                                  onPicked: (date) =>
                                      setState(() => _payableFromDate = date),
                                ),
                                onClear: _payableFromDate == null
                                    ? null
                                    : () => setState(() => _payableFromDate = null),
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
                          validator: (v) => CustomerValidators.requiredText(
                            l10n,
                            v,
                            l10n.performanceAppraisal,
                          ),
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
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _remarksController,
                          label: l10n.remarks,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('remarks'),
                          validator: (v) =>
                              CustomerValidators.requiredText(l10n, v, l10n.remarks),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                          hint: l10n.passwordRequiredPut,
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
                      ],
                    ),
                    const SizedBox(height: 16),
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
                    if (_generalError != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _generalError!,
                        style: AppTextStyles.body(context)
                            .copyWith(color: Colors.red.shade700),
                      ),
                    ],
                  ],
                ),
              ),
            ),
      bottomNavigationBar: session != null && !_isLoading
          ? Material(
              color: Colors.transparent,
              elevation: 0,
              child: SafeArea(
                minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: AppPrimaryButton(
                  label: context.l10n.saveChangesPut,
                  isLoading: _isSaving,
                  onPressed: _submit,
                ),
              ),
            )
          : null,
    );
  }
}

class _DropdownLoadingField extends StatelessWidget {
  const _DropdownLoadingField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label(context)),
        const SizedBox(height: 8),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: context.appColors.inputFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.appColors.progressTrack),
          ),
          child: Row(
            children: [
              const AppLoader(size: AppLoaderSize.small),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.loading,
                  style: AppTextStyles.body(context).copyWith(
                    color: context.appColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
