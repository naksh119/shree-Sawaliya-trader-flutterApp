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
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
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

  static const _genderOptions = ['MALE', 'FEMALE', 'OTHER'];
  static const _maritalOptions = ['SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED'];

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
        _error = 'Session unavailable. Please sign in again.';
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
    setState(() => _employeePhoto = picked);
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
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRoleId == null) {
      setState(() => _generalError = 'Role is required');
      return;
    }
    if (_selectedBranchId == null) {
      setState(() => _generalError = 'Branch is required');
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
        message: 'Employee ${updated.displayName} updated.',
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

    return Scaffold(
      appBar: ThemedAppBar(title: 'Edit Employee (PUT)'),
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
                      'Full update uses PUT with all employee fields.',
                      style: AppTextStyles.body(context).copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    if (_employeeCode != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Employee code: $_employeeCode (read-only)',
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
                      title: 'Role & branch',
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _isLoadingOptions
                                  ? const _DropdownLoadingField(label: 'Role')
                                  : _roles.isEmpty
                                      ? Text(
                                          'No roles available.',
                                          style: AppTextStyles.body(context)
                                              .copyWith(
                                            color: Colors.red.shade700,
                                          ),
                                        )
                                      : AppDropdownFormField<int>(
                                      value: _selectedRoleId,
                                      decoration: AppDropdownDecoration.formField(
                                        context,
                                        labelText: 'Role',
                                      ).copyWith(errorText: _apiError('role')),
                                      validator: (_) => _apiError('role'),
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
                                  ? const _DropdownLoadingField(label: 'Branch')
                                  : _branches.isEmpty
                                      ? Text(
                                          'No branches available.',
                                          style: AppTextStyles.body(context)
                                              .copyWith(
                                            color: Colors.red.shade700,
                                          ),
                                        )
                                      : AppDropdownFormField<int>(
                                      value: _selectedBranchId,
                                      decoration: AppDropdownDecoration.formField(
                                        context,
                                        labelText: 'Branch',
                                      ).copyWith(errorText: _apiError('branch')),
                                      validator: (_) => _apiError('branch'),
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
                      title: 'Personal details',
                      children: [
                        AppPhotoPicker(
                          label: 'Employee photo',
                          existingImageUrl: _showExistingPhotoPreview
                              ? _existingPhotoUrl
                              : null,
                          existingImageLabel: 'Current photo',
                          hint: 'Choose a new image to replace the current photo.',
                          placeholderIcon: Icons.person_outline,
                          image: _employeePhoto,
                          onPick: _pickEmployeePhoto,
                          onClear: _employeePhoto?.isNotEmpty == true
                              ? _clearEmployeePhoto
                              : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _firstNameController,
                          label: 'First name',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('first_name'),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'First name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _lastNameController,
                          label: 'Last name',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('last_name'),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Last name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _fatherNameController,
                          label: 'Father name',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('father_name'),
                        ),
                        const SizedBox(height: 16),
                        _DateField(
                          label: 'Date of birth',
                          value: _dateOfBirth,
                          errorText: _apiError('date_of_birth'),
                          onTap: () => _pickDate(
                            initial: _dateOfBirth,
                            onPicked: (date) => setState(() => _dateOfBirth = date),
                          ),
                          onClear: _dateOfBirth == null
                              ? null
                              : () => setState(() => _dateOfBirth = null),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _placeOfBirthController,
                          label: 'Place of birth',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('place_of_birth'),
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
                                  labelText: 'Gender',
                                ),
                                items: _genderOptions
                                    .map(
                                      (value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
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
                                  labelText: 'Marital status',
                                ),
                                items: _maritalOptions
                                    .map(
                                      (value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
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
                          label: 'Nationality',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('nationality'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _languagesController,
                          label: 'Languages known',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('languages_known'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _membersInFamilyController,
                          label: 'Members in family',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('members_in_family'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Employment dates & assessment',
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _DateField(
                                label: 'Date of appointment',
                                value: _appointmentDate,
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
                                label: 'Date of joining',
                                value: _joiningDate,
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
                                label: 'Date of confirmation',
                                value: _confirmationDate,
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
                                label: 'Payable from date',
                                value: _payableFromDate,
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
                          label: 'Performance appraisal',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('performance_appraisal'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _warningNotesController,
                          label: 'Warning notes',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('warning_notes'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _remarksController,
                          label: 'Remarks',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('remarks'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Identity & contact',
                      children: [
                        AppTextField(
                          controller: _aadhaarController,
                          label: 'Aadhaar number',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('aadhaar_card_no'),
                          validator: (v) => CustomerValidators.aadhaar(v),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _panController,
                          label: 'PAN',
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: const [UpperCaseTextInputFormatter()],
                          externalError: _apiError('pan_card_no'),
                          validator: (v) => CustomerValidators.pan(v),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _mobileController,
                          label: 'Primary mobile',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('primary_mobile_number'),
                          validator: (v) => CustomerValidators.mobile(v),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _secondaryMobileController,
                          label: 'Secondary mobile',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('secondary_mobile_number'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Login credentials',
                      children: [
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          enableSuggestions: false,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('email'),
                          validator: (v) => CustomerValidators.email(v, required: true),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Required for full PUT update',
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
                              return 'Password is required for full update';
                            }
                            if (v.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            if (!RegExp(r'[A-Z]').hasMatch(v)) {
                              return 'Password must contain at least one uppercase letter';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Address',
                      children: [
                        AppTextField(
                          controller: _presentAddressController,
                          label: 'Present address',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('present_address'),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Permanent address same as present',
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
                            label: 'Permanent address',
                            textInputAction: TextInputAction.next,
                            externalError: _apiError('permanent_address'),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Health & qualifications',
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _heightController,
                                label: 'Height (cm)',
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                externalError: _apiError('height_cm'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppTextField(
                                controller: _weightController,
                                label: 'Weight (kg)',
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                externalError: _apiError('weight_kg'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _bloodGroupController,
                          label: 'Blood group',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('blood_group'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _educationController,
                          label: 'Educational qualifications',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('educational_qualifications'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _professionalController,
                          label: 'Professional qualifications',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('professional_qualifications'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Emergency contact',
                      children: [
                        AppTextField(
                          controller: _emergencyNameController,
                          label: 'Contact name',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('emergency_contact_name'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _emergencyRelationController,
                          label: 'Relation',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('emergency_contact_relation'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _emergencyMobileController,
                          label: 'Contact number',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          externalError: _apiError('emergency_contact_number'),
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
                  label: 'Save changes (PUT)',
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
              Text(
                'Loading...',
                style: AppTextStyles.body(context).copyWith(
                  color: context.appColors.textSecondary,
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
    this.compact = false,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? errorText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final formatted = value == null
        ? 'Select date'
        : '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}';
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label(context),
          maxLines: compact ? 2 : 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Material(
          color: context.appColors.inputFill,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 10 : 16,
                vertical: compact ? 12 : 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasError
                      ? Colors.red.shade300
                      : context.appColors.progressTrack,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: compact ? 16 : 18,
                    color: context.appColors.shinyGold.withValues(alpha: 0.8),
                  ),
                  SizedBox(width: compact ? 8 : 12),
                  Expanded(
                    child: Text(
                      formatted,
                      style: AppTextStyles.body(context).copyWith(
                        color: value == null
                            ? context.appColors.textSecondary
                            : context.appColors.textPrimary,
                        fontSize: compact ? 14 : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (onClear != null)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: context.appColors.textSecondary,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed: onClear,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: AppTextStyles.subtitle(context).copyWith(
              color: Colors.red.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
