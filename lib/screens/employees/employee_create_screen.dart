import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/employees/employee_service.dart';
import 'package:sawaliyatrader/core/employees/models/branch_option.dart';
import 'package:sawaliyatrader/core/employees/models/employee_register_request.dart';
import 'package:sawaliyatrader/core/employees/models/role_option.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_photo_picker.dart';
import 'package:sawaliyatrader/core/widgets/app_primary_button.dart';
import 'package:sawaliyatrader/core/widgets/app_success_message.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/widgets/upper_case_text_input_formatter.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class EmployeeCreateScreen extends StatefulWidget {
  const EmployeeCreateScreen({super.key});

  @override
  State<EmployeeCreateScreen> createState() => _EmployeeCreateScreenState();
}

class _EmployeeCreateScreenState extends State<EmployeeCreateScreen> {
  final _authService = AuthService();
  final _employeeService = EmployeeService();
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  LoginResponse? _session;
  bool _isLoadingOptions = true;
  bool _isSaving = false;
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
  final _remarksController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _emergencyMobileController = TextEditingController();

  static const _genderOptions = ['MALE', 'FEMALE', 'OTHER'];
  static const _maritalOptions = ['SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED'];

  @override
  void initState() {
    super.initState();
    _bindFieldErrorClearing();
    _bootstrap();
  }

  void _bindFieldErrorClearing() {
    final bindings = <TextEditingController, String>{
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
    _remarksController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyMobileController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await _bootstrapWork();
  }

  Future<void> _bootstrapWork() async {
    final session = await _authService.getSession();
    if (!mounted) return;

    if (session == null) {
      setState(() {
        _session = null;
        _isLoadingOptions = false;
      });
      return;
    }

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
        _session = session;
        _roles = roles;
        _branches = branches;
        _selectedRoleId = roles.isNotEmpty ? roles.first.id : null;
        _selectedBranchId = branches.isNotEmpty ? branches.first.id : null;
        _isLoadingOptions = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _session = session;
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
      case 'secondary_mobile_number':
      case 'emergency_contact_number':
        return RegExp(r'^\d{10}$').hasMatch(trimmed);
      case 'aadhaar_card_no':
        return RegExp(r'^\d{12}$').hasMatch(trimmed);
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
        return CustomerValidators.pan(trimmed) == null;
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

  void _scrollToTopOnValidationFailure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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
    setState(() {
      _employeePhoto = null;
      _fieldErrors = Map<String, String>.from(_fieldErrors)
        ..remove('employee_photo');
    });
  }

  Future<void> _submit() async {
    final session = _session;
    if (session == null || _isSaving) return;
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidate = true);
      _scrollToTopOnValidationFailure();
      return;
    }

    if (_selectedRoleId == null) {
      _setFieldError('role', 'Please select a role.');
      _scrollToTopOnValidationFailure();
      return;
    }

    if (_selectedBranchId == null) {
      _setFieldError('branch', 'Please select a branch.');
      _scrollToTopOnValidationFailure();
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

      final request = EmployeeRegisterRequest(
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
        remarks: _emptyToNull(_remarksController.text),
        educationalQualifications: _emptyToNull(_educationController.text),
        professionalQualifications: _emptyToNull(_professionalController.text),
        membersInFamily: int.tryParse(_membersInFamilyController.text.trim()),
        emergencyContactName: _emptyToNull(_emergencyNameController.text),
        emergencyContactRelation: _emptyToNull(_emergencyRelationController.text),
        emergencyContactNumber: _emptyToNull(_emergencyMobileController.text),
      );

      final created = await _employeeService.registerEmployee(
        session: session,
        request: request,
        employeePhoto: _employeePhoto,
      );

      if (!mounted) return;
      await showAppSuccessMessage(
        context,
        message: 'Employee ${created.displayName} registered.',
      );
      if (!mounted) return;
      context.pop(true);
    } on ApiException catch (error) {
      if (!mounted) return;
      _applyApiErrors(error);
    } catch (error) {
      if (!mounted) return;
      setState(() => _generalError = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    final isReady = session != null && !_isLoadingOptions;

    return Scaffold(
      appBar: ThemedAppBar(title: 'New Employee',
      ),
      body: !isReady
          ? const Center(child: AppLoader(size: kAppPageLoaderSize))
          : SessionScope(
              session: session,
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  children: [
                    Text(
                      'Register a staff member with login credentials and HR profile.',
                      style: AppTextStyles.body(context).copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: 'Personal details',
                      children: [
                        AppPhotoPicker(
                          label: 'Employee photo',
                          hint: 'Upload a profile photo (optional).',
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
                          label: 'Place of birth',
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('place_of_birth'),
                        ),
                        const SizedBox(height: 16),
                        _DropdownField<String>(
                          label: 'Gender',
                          value: _gender,
                          errorText: _apiError('gender'),
                          items: _genderOptions
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value, style: AppTextStyles.body(context)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _clearFieldError('gender');
                              setState(() => _gender = value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        _DropdownField<String>(
                          label: 'Marital status',
                          value: _maritalStatus,
                          errorText: _apiError('marital_status'),
                          items: _maritalOptions
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value, style: AppTextStyles.body(context)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _clearFieldError('marital_status');
                              setState(() => _maritalStatus = value);
                            }
                          },
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
                          validator: (v) {
                            final trimmed = v?.trim() ?? '';
                            if (trimmed.isEmpty) return null;
                            if (!RegExp(r'^\d{12}$').hasMatch(trimmed)) {
                              return 'Aadhaar number must be exactly 12 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _panController,
                          label: 'PAN',
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: const [UpperCaseTextInputFormatter()],
                          externalError: _apiError('pan_card_no'),
                          validator: CustomerValidators.pan,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _mobileController,
                          label: 'Primary mobile',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('primary_mobile_number'),
                          validator: (v) {
                            final trimmed = v?.trim() ?? '';
                            if (trimmed.isEmpty) return null;
                            if (!RegExp(r'^\d{10}$').hasMatch(trimmed)) {
                              return 'Mobile number must be exactly 10 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _secondaryMobileController,
                          label: 'Secondary mobile',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('secondary_mobile_number'),
                          validator: (v) {
                            final trimmed = v?.trim() ?? '';
                            if (trimmed.isEmpty) return null;
                            if (!RegExp(r'^\d{10}$').hasMatch(trimmed)) {
                              return 'Mobile number must be exactly 10 digits';
                            }
                            return null;
                          },
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
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _passwordController,
                          label: 'Password',
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
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password is required';
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
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm password',
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
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ),
                          validator: (v) {
                            final trimmed = v?.trim() ?? '';
                            if (trimmed.isEmpty) {
                              return 'Confirm password is required';
                            }
                            if (trimmed != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Assignment',
                      children: [
                        if (_roles.isEmpty)
                          Text(
                            'No roles available. Check your connection and try again.',
                            style: AppTextStyles.body(context).copyWith(
                              color: Colors.red.shade700,
                            ),
                          )
                        else
                          _DropdownField<int>(
                            label: 'Role',
                            value: _selectedRoleId,
                            errorText: _apiError('role'),
                            items: _roles
                                .map(
                                  (role) => DropdownMenuItem(
                                    value: role.id,
                                    child: Text(
                                      '${role.name} (${role.code})',
                                      style: AppTextStyles.body(context),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              _clearFieldError('role');
                              setState(() => _selectedRoleId = value);
                            },
                          ),
                        const SizedBox(height: 16),
                        if (_branches.isEmpty)
                          Text(
                            'No branches available for assignment.',
                            style: AppTextStyles.body(context).copyWith(
                              color: Colors.red.shade700,
                            ),
                          )
                        else
                          _DropdownField<int>(
                            label: 'Branch',
                            value: _selectedBranchId,
                            errorText: _apiError('branch'),
                            items: _branches
                                .map(
                                  (branch) => DropdownMenuItem(
                                    value: branch.id,
                                    child: Text(
                                      branch.label,
                                      style: AppTextStyles.body(context),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              _clearFieldError('branch');
                              setState(() => _selectedBranchId = value);
                            },
                          ),
                        const SizedBox(height: 16),
                        _DateField(
                          label: 'Date of appointment',
                          value: _appointmentDate,
                          errorText: _apiError('date_of_appointment'),
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
                        const SizedBox(height: 16),
                        _DateField(
                          label: 'Date of joining',
                          value: _joiningDate,
                          errorText: _apiError('date_of_joining'),
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
                        const SizedBox(height: 16),
                        _DateField(
                          label: 'Date of confirmation',
                          value: _confirmationDate,
                          errorText: _apiError('date_of_confirmation'),
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
                        const SizedBox(height: 16),
                        _DateField(
                          label: 'Payable from date',
                          value: _payableFromDate,
                          errorText: _apiError('payable_from_date'),
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
                        AppTextField(
                          controller: _heightController,
                          label: 'Height (cm)',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('height_cm'),
                          validator: (v) {
                            final trimmed = v?.trim() ?? '';
                            if (trimmed.isEmpty) return null;
                            final height = double.tryParse(trimmed);
                            if (height == null || height < 30) {
                              return 'Height must be at least 30 cm';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _weightController,
                          label: 'Weight (kg)',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('weight_kg'),
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
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _membersInFamilyController,
                          label: 'Members in family',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          externalError: _apiError('members_in_family'),
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
                          validator: (v) {
                            final trimmed = v?.trim() ?? '';
                            if (trimmed.isEmpty) return null;
                            if (!RegExp(r'^\d{10}$').hasMatch(trimmed)) {
                              return 'Mobile number must be exactly 10 digits';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    if (_generalError != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _generalError!,
                        style: AppTextStyles.body(context).copyWith(
                          color: Colors.red.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
      bottomNavigationBar: isReady
          ? SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: AppPrimaryButton(
                  label: 'Register employee',
                  isLoading: _isSaving,
                  onPressed: _submit,
                ),
              ),
            )
          : null,
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

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label(context)),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          style: AppTextStyles.body(context),
          dropdownColor: context.appColors.card,
          validator: (_) => errorText,
          decoration: InputDecoration(
            filled: true,
            fillColor: context.appColors.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.appColors.progressTrack),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.appColors.progressTrack),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.appColors.gold, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade300),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
            ),
          ),
        ),
      ],
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
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final formatted = value == null
        ? 'Select date'
        : '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}';
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label(context)),
        const SizedBox(height: 8),
        Material(
          color: context.appColors.inputFill,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    size: 18,
                    color: context.appColors.shinyGold.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      formatted,
                      style: AppTextStyles.body(context).copyWith(
                        color: value == null
                            ? context.appColors.textSecondary
                            : context.appColors.textPrimary,
                      ),
                    ),
                  ),
                  if (onClear != null)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: context.appColors.textSecondary,
                      onPressed: onClear,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: AppTextStyles.body(context).copyWith(
              color: Colors.red.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
