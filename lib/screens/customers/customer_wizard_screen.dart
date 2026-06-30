import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/session_bootstrap.dart';
import 'package:sawaliyatrader/core/customers/customer_service.dart';
import 'package:sawaliyatrader/core/customers/customer_validators.dart';
import 'package:sawaliyatrader/core/customers/models/customer_detail.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/customers/models/family_member.dart';
import 'package:sawaliyatrader/core/customers/models/guarantor.dart';
import 'package:sawaliyatrader/core/customers/models/maternal_house.dart';
import 'package:sawaliyatrader/core/customers/models/other_loan.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_date_picker.dart';
import 'package:sawaliyatrader/core/widgets/app_next_button.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/widgets/wizard_step_indicator.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/screens/customers/widgets/wizard/customer_wizard_customer_step.dart';
import 'package:sawaliyatrader/screens/customers/widgets/wizard/customer_wizard_documents_step.dart';
import 'package:sawaliyatrader/screens/customers/widgets/wizard/customer_wizard_family_step.dart';
import 'package:sawaliyatrader/screens/customers/widgets/wizard/customer_wizard_guarantor_step.dart';
import 'package:sawaliyatrader/screens/customers/widgets/wizard/customer_wizard_maternal_house_step.dart';
import 'package:sawaliyatrader/screens/customers/widgets/wizard/customer_wizard_other_loan_step.dart';

class CustomerWizardScreen extends StatefulWidget implements HasInitialSession {
  const CustomerWizardScreen({super.key, this.initialSession});

  @override
  final LoginResponse? initialSession;

  @override
  State<CustomerWizardScreen> createState() => _CustomerWizardScreenState();
}

class _CustomerWizardScreenState extends State<CustomerWizardScreen>
    with SessionBootstrapMixin {
  final _customerService = CustomerService();
  final _formKey = GlobalKey<FormState>();

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
    initSessionBootstrap();
    _bindFieldErrorClearing();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resolveSessionFromContext();
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

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showAppDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: now,
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
      final formValid = _formKey.currentState!.validate();
      final stepValid = _validateCustomerStep();
      if (!formValid || !stepValid) return;
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
    final genderError = CustomerValidators.gender(context.l10n, _gender);
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
    final activeSession = session;
    if (activeSession == null || _isSaving) return;

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
        branch: activeSession.employee?.branch,
        occupation: _emptyToNull(_occupationController.text),
        monthlyIncome: double.tryParse(_incomeController.text.trim()),
      );

      final created = await _customerService.createCustomer(
        session: activeSession,
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
    final activeSession = session;
    final customerId = _customerId;
    if (activeSession == null || customerId == null) return;

    await _runStep(() {
      return _customerService.addFamilyMember(
        session: activeSession,
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
    final activeSession = session;
    final customerId = _customerId;
    if (activeSession == null || customerId == null) return;

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
        session: activeSession,
        customerId: customerId,
        payload: maternal.toPayload(),
        exists: _maternalHouseExists,
      );
    });
    _maternalHouseExists = true;
  }

  Future<void> _saveOtherLoanStep() async {
    final activeSession = session;
    final customerId = _customerId;
    if (activeSession == null || customerId == null) return;

    await _runStep(() {
      return _customerService.addOtherLoan(
        session: activeSession,
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
    final activeSession = session;
    final customerId = _customerId;
    if (activeSession == null || customerId == null) return;

    await _runStep(() {
      return _customerService.addGuarantor(
        session: activeSession,
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
    final activeSession = session;
    final customerId = _customerId;
    if (activeSession == null || customerId == null || _isSaving) return;

    setState(() {
      _isSaving = true;
      _generalError = null;
      _fieldErrors = const {};
    });

    try {
      await _customerService.uploadDocument(
        session: activeSession,
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
      if (_step < customerWizardSteps(context.l10n).length - 1) {
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
    final steps = customerWizardSteps(context.l10n);

    return Scaffold(
      appBar: ThemedAppBar(
        leading: IconButton(
          icon: BrandGradientIcon(Icons.arrow_back),
          onPressed: _onBack,
        ),
        title: context.l10n.newCustomer,
      ),
      body: session == null
          ? const Center(child: AppLoader(size: kAppPageLoaderSize))
          : SessionScope(
              session: session!,
              child: Column(
                children: [
                  WizardStepIndicator(
                    steps: steps,
                    currentStep: _step,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      key: ValueKey(_step),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                            isLastStep: _step == steps.length - 1,
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
      0 => CustomerWizardCustomerStep(
          fullNameController: _fullNameController,
          mobileController: _mobileController,
          emailController: _emailController,
          aadhaarController: _aadhaarController,
          panController: _panController,
          addressController: _addressController,
          addressLine2Controller: _addressLine2Controller,
          cityController: _cityController,
          stateController: _stateController,
          pincodeController: _pincodeController,
          occupationController: _occupationController,
          incomeController: _incomeController,
          dateOfBirth: _dateOfBirth,
          gender: _gender,
          livePhoto: _livePhoto,
          housePhoto: _housePhoto,
          apiError: _apiError,
          onPickLivePhoto: _pickLivePhoto,
          onClearLivePhoto: _clearLivePhoto,
          onPickHousePhoto: _pickHousePhoto,
          onClearHousePhoto: _clearHousePhoto,
          onPickDateOfBirth: _pickDateOfBirth,
          onClearDateOfBirth: _dateOfBirth == null
              ? null
              : () {
                  _clearFieldError('date_of_birth');
                  setState(() => _dateOfBirth = null);
                },
          onGenderChanged: (value) {
            _clearFieldError('gender');
            setState(() => _gender = value);
          },
        ),
      1 => CustomerWizardFamilyStep(
          nameController: _familyNameController,
          relationController: _familyRelationController,
          ageController: _familyAgeController,
          mobileController: _familyMobileController,
          occupationController: _familyOccupationController,
          apiError: _apiError,
        ),
      2 => CustomerWizardMaternalHouseStep(
          contactNameController: _mhContactNameController,
          contactMobileController: _mhContactMobileController,
          addressController: _mhAddressController,
          cityController: _mhCityController,
          stateController: _mhStateController,
          pincodeController: _mhPincodeController,
          apiError: _apiError,
        ),
      3 => CustomerWizardOtherLoanStep(
          lenderController: _loanLenderController,
          amountController: _loanAmountController,
          emiController: _loanEmiController,
          outstandingController: _loanOutstandingController,
          apiError: _apiError,
        ),
      4 => CustomerWizardGuarantorStep(
          nameController: _guarantorNameController,
          mobileController: _guarantorMobileController,
          aadhaarController: _guarantorAadhaarController,
          relationController: _guarantorRelationController,
          addressController: _guarantorAddressController,
          apiError: _apiError,
        ),
      _ => CustomerWizardDocumentsStep(
          documentType: _documentType,
          pickedFilePath: _pickedFilePath,
          pickedFileName: _pickedFileName,
          apiError: _apiError,
          onPickDocument: _pickDocument,
          onDocumentTypeChanged: (value) =>
              setState(() => _documentType = value),
        ),
    };
  }
}
