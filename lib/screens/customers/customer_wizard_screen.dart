import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/customers/customer_service.dart';
import 'package:sawaliyatrader/core/customers/models/customer_detail.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/customers/models/family_member.dart';
import 'package:sawaliyatrader/core/customers/models/guarantor.dart';
import 'package:sawaliyatrader/core/customers/models/maternal_house.dart';
import 'package:sawaliyatrader/core/customers/models/other_loan.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_primary_button.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
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
  String? _error;

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
    _loadSession();
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

  Future<void> _loadSession() async {
    final session =
        await awaitWithMinPageLoaderDuration(_authService.getSession());
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
    if (_step == 0) {
      if (!_formKey.currentState!.validate()) return;
      await _saveCustomerStep();
      return;
    }

    if (_step == 1) await _saveFamilyStep();
    if (_step == 2) await _saveMaternalHouseStep();
    if (_step == 3) await _saveOtherLoanStep();
    if (_step == 4) await _saveGuarantorStep();
    if (_step == 5) await _finishWizard();
  }

  Future<void> _saveCustomerStep() async {
    final session = _session;
    if (session == null || _isSaving) return;

    setState(() {
      _isSaving = true;
      _error = null;
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
      );

      if (!mounted) return;
      setState(() {
        _customerId = created.id;
        _step = 1;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
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
            outstandingAmount:
                double.tryParse(_loanOutstandingController.text.trim()),
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
      _error = null;
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
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  Future<void> _runStep(Future<void> Function() action) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      await action();
      if (!mounted) return;
      if (_step < _steps.length - 1) {
        setState(() => _step += 1);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
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
            _WizardStepIndicator(
              steps: _steps,
              currentStep: _step,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_steps[_step], style: AppTextStyles.label(context)),
                      const SizedBox(height: 16),
                      _buildStepContent(),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: AppTextStyles.body(context).copyWith(
                            color: const Color(0xFFE57373),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
                  SizedBox(
                    width: 160,
                    child: AppPrimaryButton(
                      label: _step == _steps.length - 1 ? 'Finish' : 'Next',
                      isLoading: _isSaving,
                      onPressed: _onNext,
                    ),
                  ),
                ],
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
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Name is required' : null,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mobileController,
          label: 'Mobile',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _aadhaarController,
          label: 'Aadhaar number',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _panController,
          label: 'PAN',
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _addressController,
          label: 'Address',
        ),
        const SizedBox(height: 16),
        AppTextField(controller: _cityController, label: 'City'),
        const SizedBox(height: 16),
        AppTextField(controller: _stateController, label: 'State'),
        const SizedBox(height: 16),
        AppTextField(
          controller: _pincodeController,
          label: 'Pincode',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _occupationController,
          label: 'Occupation',
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _incomeController,
          label: 'Monthly income (₹)',
          keyboardType: TextInputType.number,
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
        AppTextField(controller: _familyNameController, label: 'Name'),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyRelationController,
          label: 'Relationship',
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyMobileController,
          label: 'Mobile',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _familyOccupationController,
          label: 'Occupation',
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
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhContactMobileController,
          label: 'Contact mobile',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        AppTextField(controller: _mhAddressController, label: 'Address'),
        const SizedBox(height: 16),
        AppTextField(controller: _mhCityController, label: 'City'),
        const SizedBox(height: 16),
        AppTextField(controller: _mhStateController, label: 'State'),
        const SizedBox(height: 16),
        AppTextField(
          controller: _mhPincodeController,
          label: 'Pincode',
          keyboardType: TextInputType.number,
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
        AppTextField(
          controller: _guarantorAddressController,
          label: 'Address',
        ),
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
        DropdownButtonFormField<String>(
          value: _documentType,
          dropdownColor: context.appColors.card,
          decoration: InputDecoration(
            labelText: 'Document type',
            labelStyle: AppTextStyles.label(context),
            filled: true,
            fillColor: context.appColors.inputFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

class _WizardStepIndicator extends StatelessWidget {
  const _WizardStepIndicator({
    required this.steps,
    required this.currentStep,
  });

  final List<String> steps;
  final int currentStep;

  Widget _buildStepNode(BuildContext context, int index) {
    const nodeSize = 36.0;
    const innerSize = 28.0;
    final isCurrent = index == currentStep;
    final isActive = index <= currentStep;

    return SizedBox(
      width: nodeSize,
      height: nodeSize,
      child: Center(
        child: isCurrent
            ? Container(
                width: nodeSize,
                height: nodeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.appColors.gold, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: innerSize,
                    height: innerSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.appColors.gold,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.subtitle(context).copyWith(
                        fontSize: 12,
                        color: context.appColors.card,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            : CircleAvatar(
                radius: innerSize / 2,
                backgroundColor: isActive
                    ? context.appColors.gold
                    : context.appColors.progressTrack,
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.subtitle(context).copyWith(
                    fontSize: 12,
                    color: isActive ? Colors.white : context.appColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                if (i > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i <= currentStep
                          ? context.appColors.gold
                          : context.appColors.progressTrack,
                    ),
                  ),
                _buildStepNode(context, i),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Step ${currentStep + 1} of ${steps.length}: ${steps[currentStep]}',
            style: AppTextStyles.subtitle(context),
          ),
        ],
      ),
    );
  }
}
