import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/customers/customer_service.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/customers/models/customer_detail.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/customers/models/family_member.dart';
import 'package:sawaliyatrader/core/customers/models/guarantor.dart';
import 'package:sawaliyatrader/core/customers/models/maternal_house.dart';
import 'package:sawaliyatrader/core/customers/models/other_loan.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_image_viewer.dart';
import 'package:sawaliyatrader/core/widgets/app_next_button.dart';
import 'package:sawaliyatrader/core/widgets/app_photo_picker.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/widgets/upper_case_text_input_formatter.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/widgets/wizard_step_indicator.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class CustomerWizardScreen extends StatefulWidget {
  const CustomerWizardScreen({super.key});

  @override
  State<CustomerWizardScreen> createState() => _CustomerWizardScreenState();
}

class _CustomerWizardScreenState extends State<CustomerWizardScreen> {
  List<String> _stepLabels(BuildContext context) => [
    context.l10n.wizardStepCustomer,
    context.l10n.wizardStepFamily,
    context.l10n.wizardStepMaternalHouse,
    context.l10n.wizardStepOtherLoans,
    context.l10n.wizardStepGuarantor,
    context.l10n.wizardStepDocuments,
  ];

  final _authService = AuthService();
  final _customerService = CustomerService();
  final _formKey = GlobalKey<FormState>();

  LoginResponse? _session;
  int _step = 0;
  int? _customerId;
  bool _isSaving = false;
  String? _generalError;
  Map<String, String> _fieldErrors = const {};
  bool _autoValidate = false;

  // Step 1 — Customer
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _panController = TextEditingController();
  final _addressController = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _occupationController = TextEditingController();
  final _incomeController = TextEditingController();

  DateTime? _dateOfBirth;
  String? _gender;

  PickedImage? _livePhoto;
  PickedImage? _housePhoto;

  // Step 2 — Family
  final _familyNameController = TextEditingController();
  final _familyRelationController = TextEditingController();
  final _familyAgeController = TextEditingController();
  final _familyMobileController = TextEditingController();
  final _familyOccupationController = TextEditingController();

  // Step 3 — Maternal house
  final _mhAddressController = TextEditingController();
  final _mhCityController = TextEditingController();
  final _mhStateController = TextEditingController();
  final _mhPincodeController = TextEditingController();
  final _mhContactNameController = TextEditingController();
  final _mhContactMobileController = TextEditingController();
  bool _maternalHouseExists = false;

  // Step 4 — Other loan
  final _loanLenderController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _loanEmiController = TextEditingController();
  final _loanOutstandingController = TextEditingController();

  // Step 5 — Guarantor
  final _guarantorNameController = TextEditingController();
  final _guarantorMobileController = TextEditingController();
  final _guarantorAadhaarController = TextEditingController();
  final _guarantorAddressController = TextEditingController();
  final _guarantorRelationController = TextEditingController();

  // Step 6 — Documents
  String _documentType = 'AADHAAR';
  String? _pickedFilePath;
  String? _pickedFileName;

  @override
  void initState() {
    super.initState();
    _bindFieldErrorClearing();
    _loadSession();
  }

  void _bindFieldErrorClearing() {
    final bindings = <TextEditingController, String>{
      _fullNameController: 'full_name',
      _mobileController: 'mobile',
      _emailController: 'email',
      _aadhaarController: 'aadhaar_number',
      _panController: 'pan_number',
      _addressController: 'address_line1',
      _addressLine2Controller: 'address_line2',
      _cityController: 'city',
      _stateController: 'state',
      _pincodeController: 'pincode',
      _occupationController: 'occupation',
      _incomeController: 'monthly_income',
      _familyNameController: 'name',
      _familyRelationController: 'relationship',
      _familyAgeController: 'age',
      _familyMobileController: 'mobile',
      _familyOccupationController: 'occupation',
      _mhAddressController: 'address_line1',
      _mhCityController: 'city',
      _mhStateController: 'state',
      _mhPincodeController: 'pincode',
      _mhContactNameController: 'contact_name',
      _mhContactMobileController: 'contact_mobile',
      _loanLenderController: 'lender_name',
      _loanAmountController: 'loan_amount',
      _loanEmiController: 'emi_amount',
      _loanOutstandingController: 'outstanding_amount',
      _guarantorNameController: 'name',
      _guarantorMobileController: 'mobile',
      _guarantorAadhaarController: 'aadhaar_number',
      _guarantorAddressController: 'address',
      _guarantorRelationController: 'relationship',
    };

    for (final entry in bindings.entries) {
      entry.key.addListener(() {
        _maybeClearFieldError(entry.value, entry.key.text);
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
    if (!CustomerValidators.fieldLooksValid(field, value)) return;
    _clearFieldError(field);
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

  void _setFieldError(String field, String message) {
    setState(() {
      _fieldErrors = Map<String, String>.from(_fieldErrors)..[field] = message;
      _autoValidate = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _aadhaarController.dispose();
    _panController.dispose();
    _addressController.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _occupationController.dispose();
    _incomeController.dispose();
    _familyNameController.dispose();
    _familyRelationController.dispose();
    _familyAgeController.dispose();
    _familyMobileController.dispose();
    _familyOccupationController.dispose();
    _mhAddressController.dispose();
    _mhCityController.dispose();
    _mhStateController.dispose();
    _mhPincodeController.dispose();
    _mhContactNameController.dispose();
    _mhContactMobileController.dispose();
    _loanLenderController.dispose();
    _loanAmountController.dispose();
    _loanEmiController.dispose();
    _loanOutstandingController.dispose();
    _guarantorNameController.dispose();
    _guarantorMobileController.dispose();
    _guarantorAadhaarController.dispose();
    _guarantorAddressController.dispose();
    _guarantorRelationController.dispose();
    super.dispose();
  }

  Future<void> _pickLivePhoto() async {
    final picked = await PickedImage.pick();
    if (picked == null) return;
    setState(() {
      _livePhoto = picked;
      _fieldErrors = Map<String, String>.from(_fieldErrors)..remove('live_photo');
    });
  }

  void _clearLivePhoto() => setState(() {
        _livePhoto = null;
        _fieldErrors = Map<String, String>.from(_fieldErrors)..remove('live_photo');
      });

  Future<void> _pickHousePhoto() async {
    final picked = await PickedImage.pick();
    if (picked == null) return;
    setState(() {
      _housePhoto = picked;
      _fieldErrors = Map<String, String>.from(_fieldErrors)..remove('house_photo');
    });
  }

  void _clearHousePhoto() => setState(() {
        _housePhoto = null;
        _fieldErrors = Map<String, String>.from(_fieldErrors)..remove('house_photo');
      });

  Future<void> _loadSession() async {
    final session = await _authService.getSession();
    if (!mounted) return;
    setState(() => _session = session);
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: now,
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

    if (picked == null) return;
    setState(() {
      _dateOfBirth = picked;
      _fieldErrors = Map<String, String>.from(_fieldErrors)
        ..remove('date_of_birth');
    });
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.pickFiles();
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    setState(() {
      _pickedFilePath = file.path;
      _pickedFileName = file.name;
      _fieldErrors = Map<String, String>.from(_fieldErrors)..remove('file');
    });
  }

  Future<void> _onNext() async {
    if (!_autoValidate) {
      setState(() => _autoValidate = true);
    }

    if (_step == 0) {
      if (!_validateCustomerStep()) return;
      if (!_formKey.currentState!.validate()) return;
      await _saveCustomerStep();
      return;
    }

    if (_step >= 1 && _step <= 4) {
      if (!_formKey.currentState!.validate()) return;
      await switch (_step) {
        1 => _saveFamilyStep(),
        2 => _saveMaternalHouseStep(),
        3 => _saveOtherLoanStep(),
        4 => _saveGuarantorStep(),
        _ => Future.value(),
      };
      return;
    }

    if (_step == 5) {
      if (!_validateDocumentStep()) return;
      await _finishWizard();
    }
  }

  bool _validateCustomerStep() {
    var valid = true;

    if (_livePhoto == null || _livePhoto!.isEmpty) {
      _setFieldError('live_photo', context.l10n.customerImageRequired);
      valid = false;
    }
    if (_housePhoto == null || _housePhoto!.isEmpty) {
      _setFieldError('house_photo', context.l10n.housePhotoRequired);
      valid = false;
    }
    if (_dateOfBirth == null) {
      _setFieldError('date_of_birth', context.l10n.dateOfBirthRequired);
      valid = false;
    }
    final genderError = CustomerValidators.gender(_gender);
    if (genderError != null) {
      _setFieldError('gender', genderError);
      valid = false;
    }

    return valid;
  }

  bool _validateDocumentStep() {
    if (_pickedFilePath != null) return true;
    _setFieldError('file', context.l10n.chooseDocument);
    return false;
  }

  Future<void> _saveCustomerStep() async {
    final session = _session;
    if (session == null || _isSaving) return;

    setState(() {
      _isSaving = true;
      _generalError = null;
      _fieldErrors = const {};
    });

    try {
      final detail = CustomerDetail(
        id: 0,
        fullName: _fullNameController.text.trim(),
        status: CustomerStatus.sourced,
        mobile: _emptyToNull(_mobileController.text),
        email: _emptyToNull(_emailController.text),
        aadhaarNumber: _emptyToNull(_aadhaarController.text),
        panNumber: _emptyToNull(_panController.text),
        dateOfBirth: _dateOfBirth,
        gender: _gender,
        addressLine1: _emptyToNull(_addressController.text),
        addressLine2: _emptyToNull(_addressLine2Controller.text),
        city: _emptyToNull(_cityController.text),
        state: _emptyToNull(_stateController.text),
        pincode: _emptyToNull(_pincodeController.text),
        branch: session.employee?.branch,
        occupation: _emptyToNull(_occupationController.text),
        monthlyIncome: double.tryParse(_incomeController.text.trim()),
      );

      final created = await _customerService.createCustomer(
        session: session,
        payload: detail.toCreatePayload(),
        livePhoto: _livePhoto,
        housePhoto: _housePhoto,
      );

      if (!mounted) return;
      setState(() {
        _customerId = created.id;
        _step = 1;
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
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  Future<void> _saveFamilyStep() async {
    final session = _session;
    final customerId = _customerId;
    if (session == null || customerId == null) return;

    await _runStep(() {
      return _customerService.addFamilyMember(
        session: session,
        customerId: customerId,
        payload: FamilyMember(
          id: 0,
          name: _familyNameController.text.trim(),
          relationship: _emptyToNull(_familyRelationController.text),
          mobile: _emptyToNull(_familyMobileController.text),
          occupation: _emptyToNull(_familyOccupationController.text),
          age: int.tryParse(_familyAgeController.text.trim()),
        ).toPayload(),
      );
    });
  }

  Future<void> _saveMaternalHouseStep() async {
    final session = _session;
    final customerId = _customerId;
    if (session == null || customerId == null) return;

    final maternal = MaternalHouse(
      addressLine1: _emptyToNull(_mhAddressController.text),
      city: _emptyToNull(_mhCityController.text),
      state: _emptyToNull(_mhStateController.text),
      pincode: _emptyToNull(_mhPincodeController.text),
      contactName: _emptyToNull(_mhContactNameController.text),
      contactMobile: _emptyToNull(_mhContactMobileController.text),
    );

    await _runStep(() {
      return _customerService.saveMaternalHouse(
        session: session,
        customerId: customerId,
        payload: maternal.toPayload(),
        exists: _maternalHouseExists,
      );
    });
    _maternalHouseExists = true;
  }

  Future<void> _saveOtherLoanStep() async {
    final session = _session;
    final customerId = _customerId;
    if (session == null || customerId == null) return;

    await _runStep(() {
      return _customerService.addOtherLoan(
        session: session,
        customerId: customerId,
        payload: OtherLoan(
          id: 0,
          lenderName: _loanLenderController.text.trim(),
          loanAmount: double.tryParse(_loanAmountController.text.trim()),
          emiAmount: double.tryParse(_loanEmiController.text.trim()),
          outstandingAmount: double.tryParse(
            _loanOutstandingController.text.trim(),
          ),
        ).toPayload(),
      );
    });
  }

  Future<void> _saveGuarantorStep() async {
    final session = _session;
    final customerId = _customerId;
    if (session == null || customerId == null) return;

    await _runStep(() {
      return _customerService.addGuarantor(
        session: session,
        customerId: customerId,
        payload: Guarantor(
          id: 0,
          name: _guarantorNameController.text.trim(),
          mobile: _emptyToNull(_guarantorMobileController.text),
          aadhaarNumber: _emptyToNull(_guarantorAadhaarController.text),
          address: _emptyToNull(_guarantorAddressController.text),
          relationship: _emptyToNull(_guarantorRelationController.text),
        ).toPayload(),
      );
    });
  }

  Future<void> _finishWizard() async {
    final session = _session;
    final customerId = _customerId;
    if (session == null || customerId == null || _isSaving) return;

    setState(() {
      _isSaving = true;
      _generalError = null;
      _fieldErrors = const {};
    });

    try {
      await _customerService.uploadDocument(
        session: session,
        customerId: customerId,
        documentType: _documentType,
        filePath: _pickedFilePath!,
        fileName: _pickedFileName,
      );

      if (!mounted) return;
      context.go(AppRoutes.customerDetail(customerId));
    } on ApiException catch (error) {
      if (!mounted) return;
      _applyApiErrors(error);
    } catch (error) {
      if (!mounted) return;
      setState(() => _generalError = error.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  Future<void> _runStep(Future<void> Function() action) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _generalError = null;
      _fieldErrors = const {};
    });

    try {
      await action();
      if (!mounted) return;
      if (_step < _stepLabels(context).length - 1) {
        setState(() {
          _step += 1;
          _fieldErrors = const {};
        });
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      _applyApiErrors(error);
    } catch (error) {
      if (!mounted) return;
      setState(() => _generalError = error.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _onBack() {
    if (_step == 0) {
      context.pop();
      return;
    }
    setState(() => _step -= 1);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null) {
      return const Scaffold(
        body: Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    return SessionScope(
      session: session,
      child: Scaffold(
        appBar: ThemedAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.appColors.shinyGold),
            onPressed: _onBack,
          ),
          title: context.l10n.newCustomer,
        ),
        body: Column(
          children: [
            WizardStepIndicator(
              steps: _stepLabels(context),
              currentStep: _step,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_stepLabels(context)[_step], style: AppTextStyles.label(context)),
                      const SizedBox(height: 16),
                      _buildStepContent(),
                      if (_generalError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _generalError!,
                          style: AppTextStyles.body(
                            context,
                          ).copyWith(color: const Color(0xFFE57373)),
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
                    const Spacer(),
                    AppNextButton(
                      isLastStep: _step == _stepLabels(context).length - 1,
                      isLoading: _isSaving,
                      onPressed: _onNext,
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
      0 => _buildCustomerStep(),
      1 => _buildFamilyStep(),
      2 => _buildMaternalHouseStep(),
      3 => _buildOtherLoanStep(),
      4 => _buildGuarantorStep(),
      _ => _buildDocumentsStep(),
    };
  }

  Widget _buildCustomerStep() {
    final l10n = context.l10n;
    return Column(
      children: [
        AppPhotoPicker(
          label: l10n.customerImage,
          hint: l10n.uploadCustomerImage,
          placeholderIcon: Icons.face_outlined,
          image: _livePhoto,
          errorText: _apiError('live_photo'),
          onPick: _pickLivePhoto,
          onClear: _livePhoto?.isNotEmpty == true ? _clearLivePhoto : null,
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: _fullNameController,
          label: l10n.fullName,
          textInputAction: TextInputAction.next,
          externalError: _apiError('full_name'),
          validator: CustomerValidators.fullName,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mobileController,
          label: l10n.mobile,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          externalError: _apiError('mobile'),
          validator: (v) => CustomerValidators.mobile(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _emailController,
          label: l10n.email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
          externalError: _apiError('email'),
          validator: (v) => CustomerValidators.email(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _aadhaarController,
          label: l10n.aadhaarNumber,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          externalError: _apiError('aadhaar_number'),
          validator: (v) => CustomerValidators.aadhaar(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _panController,
          label: l10n.pan,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: const [UpperCaseTextInputFormatter()],
          externalError: _apiError('pan_number'),
          validator: (v) => CustomerValidators.pan(v, required: true),
        ),
        const SizedBox(height: 16),
        _DateField(
          label: l10n.dateOfBirth,
          value: _dateOfBirth,
          errorText: _apiError('date_of_birth'),
          onTap: _pickDateOfBirth,
          onClear: _dateOfBirth == null
              ? null
              : () {
                  _clearFieldError('date_of_birth');
                  setState(() => _dateOfBirth = null);
                },
        ),
        const SizedBox(height: 16),
        AppDropdownFormField<String>(
          value: _gender,
          decoration: AppDropdownDecoration.formField(
            context,
            labelText: l10n.gender,
          ).copyWith(errorText: _apiError('gender')),
          validator: (v) => _apiError('gender') ?? CustomerValidators.gender(v),
          items: CustomerValidators.genderOptions
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value, style: AppTextStyles.body(context)),
                ),
              )
              .toList(),
          onChanged: (value) {
            _clearFieldError('gender');
            setState(() => _gender = value);
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _addressController,
          label: l10n.addressLine1,
          textInputAction: TextInputAction.next,
          externalError: _apiError('address_line1'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.address),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _addressLine2Controller,
          label: l10n.addressLine2,
          textInputAction: TextInputAction.next,
          externalError: _apiError('address_line2'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.addressLine2),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _cityController,
          label: l10n.city,
          textInputAction: TextInputAction.next,
          externalError: _apiError('city'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.city),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _stateController,
          label: l10n.state,
          textInputAction: TextInputAction.next,
          externalError: _apiError('state'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.state),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _pincodeController,
          label: l10n.pincode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          externalError: _apiError('pincode'),
          validator: (v) => CustomerValidators.pincode(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _occupationController,
          label: l10n.occupation,
          textInputAction: TextInputAction.next,
          externalError: _apiError('occupation'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.occupation),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _incomeController,
          label: l10n.monthlyIncomeWithSymbol,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          externalError: _apiError('monthly_income'),
          validator: (v) => CustomerValidators.decimalAmount(
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
          image: _housePhoto,
          errorText: _apiError('house_photo'),
          onPick: _pickHousePhoto,
          onClear: _housePhoto?.isNotEmpty == true ? _clearHousePhoto : null,
        ),
      ],
    );
  }

  Widget _buildFamilyStep() {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.addFamilyMember,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyNameController,
          label: l10n.name,
          textInputAction: TextInputAction.next,
          externalError: _apiError('name'),
          validator: (v) => CustomerValidators.name(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyRelationController,
          label: l10n.relationship,
          textInputAction: TextInputAction.next,
          externalError: _apiError('relationship'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.relationship),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyAgeController,
          label: l10n.age,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          externalError: _apiError('age'),
          validator: (v) => CustomerValidators.age(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyMobileController,
          label: l10n.mobile,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          externalError: _apiError('mobile'),
          validator: (v) => CustomerValidators.mobile(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyOccupationController,
          label: l10n.occupation,
          textInputAction: TextInputAction.done,
          externalError: _apiError('occupation'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.occupation),
        ),
      ],
    );
  }

  Widget _buildMaternalHouseStep() {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.maternalHouseContactHint,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhContactNameController,
          label: l10n.contactName,
          textInputAction: TextInputAction.next,
          externalError: _apiError('contact_name'),
          validator: (v) => CustomerValidators.name(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhContactMobileController,
          label: l10n.contactMobile,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          externalError: _apiError('contact_mobile'),
          validator: (v) => CustomerValidators.mobile(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhAddressController,
          label: l10n.address,
          textInputAction: TextInputAction.next,
          externalError: _apiError('address_line1'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.address),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhCityController,
          label: l10n.city,
          textInputAction: TextInputAction.next,
          externalError: _apiError('city'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.city),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhStateController,
          label: l10n.state,
          textInputAction: TextInputAction.next,
          externalError: _apiError('state'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.state),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhPincodeController,
          label: l10n.pincode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          externalError: _apiError('pincode'),
          validator: (v) => CustomerValidators.pincode(v, required: true),
        ),
      ],
    );
  }

  Widget _buildOtherLoanStep() {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.recordExistingLoans,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _loanLenderController,
          label: l10n.lenderName,
          externalError: _apiError('lender_name'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.lenderName),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _loanAmountController,
          label: l10n.loanAmountWithSymbol,
          keyboardType: TextInputType.number,
          externalError: _apiError('loan_amount'),
          validator: (v) => CustomerValidators.decimalAmount(
            v,
            label: l10n.loanAmount,
            required: true,
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _loanEmiController,
          label: l10n.emiAmountWithSymbol,
          keyboardType: TextInputType.number,
          externalError: _apiError('emi_amount'),
          validator: (v) => CustomerValidators.decimalAmount(
            v,
            label: l10n.emiAmount,
            required: true,
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _loanOutstandingController,
          label: l10n.outstandingWithSymbol,
          keyboardType: TextInputType.number,
          externalError: _apiError('outstanding_amount'),
          validator: (v) => CustomerValidators.decimalAmount(
            v,
            label: l10n.outstandingAmount,
            required: true,
          ),
        ),
      ],
    );
  }

  Widget _buildGuarantorStep() {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.addGuarantor,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _guarantorNameController,
          label: l10n.name,
          externalError: _apiError('name'),
          validator: (v) => CustomerValidators.name(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _guarantorMobileController,
          label: l10n.mobile,
          keyboardType: TextInputType.phone,
          externalError: _apiError('mobile'),
          validator: (v) => CustomerValidators.mobile(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _guarantorAadhaarController,
          label: l10n.aadhaar,
          keyboardType: TextInputType.number,
          externalError: _apiError('aadhaar_number'),
          validator: (v) => CustomerValidators.aadhaar(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _guarantorRelationController,
          label: l10n.relationship,
          externalError: _apiError('relationship'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.relationship),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _guarantorAddressController,
          label: l10n.address,
          externalError: _apiError('address'),
          validator: (v) => CustomerValidators.requiredText(v, l10n.address),
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.uploadKycDocument,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppDropdownFormField<String>(
          value: _documentType,
          decoration: AppDropdownDecoration.formField(
            context,
            labelText: l10n.documentType,
          ),
          items: [
            DropdownMenuItem(
              value: 'AADHAAR',
              child: Text(l10n.documentTypeAadhaar),
            ),
            DropdownMenuItem(value: 'PAN', child: Text(l10n.documentTypePan)),
            DropdownMenuItem(
              value: 'PHOTO',
              child: Text(l10n.documentTypePhoto),
            ),
            DropdownMenuItem(
              value: 'OTHER',
              child: Text(l10n.documentTypeOther),
            ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _documentType = value);
          },
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _pickDocument,
          icon: Icon(Icons.upload_file, color: context.appColors.shinyGold),
          label: Text(
            _pickedFileName ?? l10n.chooseFile,
            style: AppTextStyles.body(context),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(
              color: _apiError('file') != null
                  ? Colors.red.shade300
                  : context.appColors.border,
            ),
          ),
        ),
        if (_apiError('file') != null) ...[
          const SizedBox(height: 8),
          Text(
            _apiError('file')!,
            style: AppTextStyles.body(context).copyWith(
              color: Colors.red.shade700,
              fontSize: 12,
            ),
          ),
        ],
        if (_pickedFilePath != null &&
            appPreviewImageIsLocalImagePath(_pickedFilePath)) ...[
          const SizedBox(height: 12),
          Text(
            l10n.selectedPreview,
            style: AppTextStyles.subtitle(context).copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          AppPreviewImage(
            imagePath: _pickedFilePath,
            height: 140,
            width: 140,
            fit: BoxFit.contain,
            borderRadius: BorderRadius.circular(12),
            viewerTitle: l10n.documentPreview,
          ),
        ],
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
        ? context.l10n.selectDate
        : '${value!.day.toString().padLeft(2, '0')}/'
            '${value!.month.toString().padLeft(2, '0')}/'
            '${value!.year}';
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
