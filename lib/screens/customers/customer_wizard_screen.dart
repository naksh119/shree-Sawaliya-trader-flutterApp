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
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
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
  static const _steps = [
    'Customer',
    'Family',
    'Maternal House',
    'Other Loans',
    'Guarantor',
    'Documents',
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
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _occupationController = TextEditingController();
  final _incomeController = TextEditingController();

  PickedImage? _livePhoto;
  PickedImage? _housePhoto;

  // Step 2 — Family
  final _familyNameController = TextEditingController();
  final _familyRelationController = TextEditingController();
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
      _cityController: 'city',
      _stateController: 'state',
      _pincodeController: 'pincode',
      _occupationController: 'occupation',
      _incomeController: 'monthly_income',
      _familyNameController: 'name',
      _familyRelationController: 'relationship',
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
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _occupationController.dispose();
    _incomeController.dispose();
    _familyNameController.dispose();
    _familyRelationController.dispose();
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
    final session = await awaitWithMinPageLoaderDuration(
      _authService.getSession(),
    );
    if (!mounted) return;
    setState(() => _session = session);
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.pickFiles();
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    setState(() {
      _pickedFilePath = file.path;
      _pickedFileName = file.name;
    });
  }

  Future<void> _onNext() async {
    if (!_autoValidate) {
      setState(() => _autoValidate = true);
    }

    if (_step == 0) {
      if (!_formKey.currentState!.validate()) return;
      await _saveCustomerStep();
      return;
    }

    if (_step == 1) {
      if (_familyStepHasInput && !_validateOptionalStepName(
            name: _familyNameController.text,
            field: 'name',
            label: 'Name',
          )) {
        return;
      }
      if (_familyStepHasInput && !_formKey.currentState!.validate()) return;
      await _saveFamilyStep();
      return;
    }

    if (_step == 2) {
      if (_maternalHouseStepHasInput && !_formKey.currentState!.validate()) {
        return;
      }
      await _saveMaternalHouseStep();
      return;
    }

    if (_step == 3) {
      if (_otherLoanStepHasInput &&
          !_validateOptionalStepName(
            name: _loanLenderController.text,
            field: 'lender_name',
            label: 'Lender name',
          )) {
        return;
      }
      if (_otherLoanStepHasInput && !_formKey.currentState!.validate()) return;
      await _saveOtherLoanStep();
      return;
    }

    if (_step == 4) {
      if (_guarantorStepHasInput &&
          !_validateOptionalStepName(
            name: _guarantorNameController.text,
            field: 'name',
            label: 'Name',
          )) {
        return;
      }
      if (_guarantorStepHasInput && !_formKey.currentState!.validate()) return;
      await _saveGuarantorStep();
      return;
    }

    if (_step == 5) await _finishWizard();
  }

  bool get _familyStepHasInput =>
      _familyNameController.text.trim().isNotEmpty ||
      _familyRelationController.text.trim().isNotEmpty ||
      _familyMobileController.text.trim().isNotEmpty ||
      _familyOccupationController.text.trim().isNotEmpty;

  bool get _maternalHouseStepHasInput =>
      _mhAddressController.text.trim().isNotEmpty ||
      _mhCityController.text.trim().isNotEmpty ||
      _mhStateController.text.trim().isNotEmpty ||
      _mhPincodeController.text.trim().isNotEmpty ||
      _mhContactNameController.text.trim().isNotEmpty ||
      _mhContactMobileController.text.trim().isNotEmpty;

  bool get _otherLoanStepHasInput =>
      _loanLenderController.text.trim().isNotEmpty ||
      _loanAmountController.text.trim().isNotEmpty ||
      _loanEmiController.text.trim().isNotEmpty ||
      _loanOutstandingController.text.trim().isNotEmpty;

  bool get _guarantorStepHasInput =>
      _guarantorNameController.text.trim().isNotEmpty ||
      _guarantorMobileController.text.trim().isNotEmpty ||
      _guarantorAadhaarController.text.trim().isNotEmpty ||
      _guarantorAddressController.text.trim().isNotEmpty ||
      _guarantorRelationController.text.trim().isNotEmpty;

  bool _validateOptionalStepName({
    required String name,
    required String field,
    required String label,
  }) {
    if (name.trim().isNotEmpty) return true;
    _setFieldError(field, '$label is required when adding details');
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
        addressLine1: _emptyToNull(_addressController.text),
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

    final name = _familyNameController.text.trim();
    if (name.isNotEmpty) {
      await _runStep(() {
        return _customerService.addFamilyMember(
          session: session,
          customerId: customerId,
          payload: FamilyMember(
            id: 0,
            name: name,
            relationship: _emptyToNull(_familyRelationController.text),
            mobile: _emptyToNull(_familyMobileController.text),
            occupation: _emptyToNull(_familyOccupationController.text),
          ).toPayload(),
        );
      });
      return;
    }

    setState(() => _step = 2);
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

    if (!maternal.isEmpty) {
      await _runStep(() {
        return _customerService.saveMaternalHouse(
          session: session,
          customerId: customerId,
          payload: maternal.toPayload(),
          exists: _maternalHouseExists,
        );
      });
      _maternalHouseExists = true;
      return;
    }

    setState(() => _step = 3);
  }

  Future<void> _saveOtherLoanStep() async {
    final session = _session;
    final customerId = _customerId;
    if (session == null || customerId == null) return;

    final lender = _loanLenderController.text.trim();
    if (lender.isNotEmpty) {
      await _runStep(() {
        return _customerService.addOtherLoan(
          session: session,
          customerId: customerId,
          payload: OtherLoan(
            id: 0,
            lenderName: lender,
            loanAmount: double.tryParse(_loanAmountController.text.trim()),
            emiAmount: double.tryParse(_loanEmiController.text.trim()),
            outstandingAmount: double.tryParse(
              _loanOutstandingController.text.trim(),
            ),
          ).toPayload(),
        );
      });
      return;
    }

    setState(() => _step = 4);
  }

  Future<void> _saveGuarantorStep() async {
    final session = _session;
    final customerId = _customerId;
    if (session == null || customerId == null) return;

    final name = _guarantorNameController.text.trim();
    if (name.isNotEmpty) {
      await _runStep(() {
        return _customerService.addGuarantor(
          session: session,
          customerId: customerId,
          payload: Guarantor(
            id: 0,
            name: name,
            mobile: _emptyToNull(_guarantorMobileController.text),
            aadhaarNumber: _emptyToNull(_guarantorAadhaarController.text),
            address: _emptyToNull(_guarantorAddressController.text),
            relationship: _emptyToNull(_guarantorRelationController.text),
          ).toPayload(),
        );
      });
      return;
    }

    setState(() => _step = 5);
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
      if (_pickedFilePath != null) {
        await _customerService.uploadDocument(
          session: session,
          customerId: customerId,
          documentType: _documentType,
          filePath: _pickedFilePath!,
          fileName: _pickedFileName,
        );
      }

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
      if (_step < _steps.length - 1) {
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
          title: 'New Customer',
        ),
        body: Column(
          children: [
            WizardStepIndicator(steps: _steps, currentStep: _step),
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
                      Text(_steps[_step], style: AppTextStyles.label(context)),
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
                    if (_step > 0 && _step < _steps.length - 1)
                      TextButton(
                        onPressed: _isSaving
                            ? null
                            : () => setState(() => _step += 1),
                        child: Text('Skip', style: AppTextStyles.link(context)),
                      ),
                    const Spacer(),
                    AppNextButton(
                      isLastStep: _step == _steps.length - 1,
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
    return Column(
      children: [
        AppTextField(
          controller: _fullNameController,
          label: 'Full name',
          textInputAction: TextInputAction.next,
          externalError: _apiError('full_name'),
          validator: CustomerValidators.fullName,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mobileController,
          label: 'Mobile',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          externalError: _apiError('mobile'),
          validator: (v) => CustomerValidators.mobile(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.next,
          externalError: _apiError('email'),
          validator: CustomerValidators.email,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _aadhaarController,
          label: 'Aadhaar number',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          externalError: _apiError('aadhaar_number'),
          validator: (v) => CustomerValidators.aadhaar(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _panController,
          label: 'PAN',
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: const [UpperCaseTextInputFormatter()],
          externalError: _apiError('pan_number'),
          validator: CustomerValidators.pan,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _addressController,
          label: 'Address',
          textInputAction: TextInputAction.next,
          externalError: _apiError('address_line1'),
          validator: (v) => CustomerValidators.requiredText(v, 'Address'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _cityController,
          label: 'City',
          textInputAction: TextInputAction.next,
          externalError: _apiError('city'),
          validator: (v) => CustomerValidators.requiredText(v, 'City'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _stateController,
          label: 'State',
          textInputAction: TextInputAction.next,
          externalError: _apiError('state'),
          validator: (v) => CustomerValidators.requiredText(v, 'State'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _pincodeController,
          label: 'Pincode',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          externalError: _apiError('pincode'),
          validator: (v) => CustomerValidators.pincode(v, required: true),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _occupationController,
          label: 'Occupation',
          textInputAction: TextInputAction.next,
          externalError: _apiError('occupation'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _incomeController,
          label: 'Monthly income (₹)',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          externalError: _apiError('monthly_income'),
          validator: (v) =>
              CustomerValidators.decimalAmount(v, label: 'Monthly income'),
        ),
        const SizedBox(height: 20),
        AppPhotoPicker(
          label: 'Customer image',
          hint: 'Upload a customer image (optional).',
          placeholderIcon: Icons.face_outlined,
          image: _livePhoto,
          errorText: _apiError('live_photo'),
          onPick: _pickLivePhoto,
          onClear: _livePhoto?.isNotEmpty == true ? _clearLivePhoto : null,
        ),
        const SizedBox(height: 16),
        AppPhotoPicker(
          label: 'House photo',
          hint: 'Upload a photo of the customer house (optional).',
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
    return Column(
      children: [
        Text(
          'Add a family member (optional). You can skip this step.',
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyNameController,
          label: 'Name',
          textInputAction: TextInputAction.next,
          externalError: _apiError('name'),
          validator: (v) => CustomerValidators.name(v),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyRelationController,
          label: 'Relationship',
          textInputAction: TextInputAction.next,
          externalError: _apiError('relationship'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyMobileController,
          label: 'Mobile',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          externalError: _apiError('mobile'),
          validator: (v) => CustomerValidators.mobile(v),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyOccupationController,
          label: 'Occupation',
          textInputAction: TextInputAction.done,
          externalError: _apiError('occupation'),
        ),
      ],
    );
  }

  Widget _buildMaternalHouseStep() {
    return Column(
      children: [
        Text(
          'Maternal house contact and address (optional).',
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhContactNameController,
          label: 'Contact name',
          textInputAction: TextInputAction.next,
          externalError: _apiError('contact_name'),
          validator: (v) => CustomerValidators.name(v),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhContactMobileController,
          label: 'Contact mobile',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          externalError: _apiError('contact_mobile'),
          validator: (v) => CustomerValidators.mobile(v),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhAddressController,
          label: 'Address',
          textInputAction: TextInputAction.next,
          externalError: _apiError('address_line1'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhCityController,
          label: 'City',
          textInputAction: TextInputAction.next,
          externalError: _apiError('city'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhStateController,
          label: 'State',
          textInputAction: TextInputAction.next,
          externalError: _apiError('state'),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhPincodeController,
          label: 'Pincode',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          externalError: _apiError('pincode'),
          validator: (v) => CustomerValidators.pincode(v),
        ),
      ],
    );
  }

  Widget _buildOtherLoanStep() {
    return Column(
      children: [
        Text(
          'Record any existing loans (optional).',
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(controller: _loanLenderController, label: 'Lender name'),
        const SizedBox(height: 16),
        AppTextField(
          controller: _loanAmountController,
          label: 'Loan amount (₹)',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _loanEmiController,
          label: 'EMI amount (₹)',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _loanOutstandingController,
          label: 'Outstanding (₹)',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildGuarantorStep() {
    return Column(
      children: [
        Text(
          'Add a guarantor (optional).',
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppTextField(controller: _guarantorNameController, label: 'Name'),
        const SizedBox(height: 16),
        AppTextField(
          controller: _guarantorMobileController,
          label: 'Mobile',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _guarantorAadhaarController,
          label: 'Aadhaar',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _guarantorRelationController,
          label: 'Relationship',
        ),
        const SizedBox(height: 16),
        AppTextField(controller: _guarantorAddressController, label: 'Address'),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload a KYC document (optional).',
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppDropdownFormField<String>(
          value: _documentType,
          decoration: AppDropdownDecoration.formField(
            context,
            labelText: 'Document type',
          ),
          items: const [
            DropdownMenuItem(value: 'AADHAAR', child: Text('Aadhaar')),
            DropdownMenuItem(value: 'PAN', child: Text('PAN')),
            DropdownMenuItem(value: 'PHOTO', child: Text('Photo')),
            DropdownMenuItem(value: 'OTHER', child: Text('Other')),
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
            _pickedFileName ?? 'Choose file',
            style: AppTextStyles.body(context),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: context.appColors.border),
          ),
        ),
      ],
    );
  }
}
