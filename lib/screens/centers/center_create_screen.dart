import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/centers/center_service.dart';
import 'package:sawaliyatrader/core/centers/models/center_create_request.dart';
import 'package:sawaliyatrader/core/centers/models/center_product_type.dart';
import 'package:sawaliyatrader/core/customers/customer_service.dart';
import 'package:sawaliyatrader/core/customers/models/customer_dto.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_next_button.dart';
import 'package:sawaliyatrader/core/widgets/app_photo_picker.dart';
import 'package:sawaliyatrader/core/widgets/app_success_message.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';
import 'package:sawaliyatrader/core/widgets/wizard_step_indicator.dart';

class CenterCreateScreen extends StatefulWidget {
  const CenterCreateScreen({super.key});

  @override
  State<CenterCreateScreen> createState() => _CenterCreateScreenState();
}

class _CenterCreateScreenState extends State<CenterCreateScreen> {
  final _authService = AuthService();
  final _centerService = CenterService();
  final _customerService = CustomerService();
  final _formKey = GlobalKey<FormState>();
  final _memberSearchController = TextEditingController();

  LoginResponse? _session;
  bool _isLoadingSession = true;
  bool _isSaving = false;
  bool _isLoadingCustomers = false;
  int _step = 0;
  String? _error;

  final _nameController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();
  final _emiAmountController = TextEditingController();
  final _weightController = TextEditingController();
  final _purityController = TextEditingController();
  final _remarksController = TextEditingController();

  CenterProductType _productType = CenterProductType.gold;
  DateTime? _startDate;
  PickedImage? _centerPhoto;
  final Set<int> _selectedMemberIds = {};
  List<CustomerDto> _approvedCustomers = [];
  String _memberSearch = '';

  static const _steps = ['Center & loan', 'Members'];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    _emiAmountController.dispose();
    _weightController.dispose();
    _purityController.dispose();
    _remarksController.dispose();
    _memberSearchController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await awaitWithMinPageLoaderDuration(_bootstrapWork());
  }

  Future<void> _bootstrapWork() async {
    final session = await _authService.getSession();
    if (!mounted) return;
    setState(() {
      _session = session;
      _isLoadingSession = false;
    });
  }

  Future<void> _loadApprovedCustomers() async {
    final session = _session;
    if (session == null || _isLoadingCustomers) return;

    setState(() => _isLoadingCustomers = true);
    try {
      final response = await _customerService.fetchCustomers(
        session: session,
        page: 1,
        pageSize: 100,
        status: CustomerStatus.approved,
        branch: session.employee?.branch,
        search: _memberSearch.isEmpty ? null : _memberSearch,
      );
      if (!mounted) return;
      setState(() => _approvedCustomers = response.items);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _isLoadingCustomers = false);
    }
  }

  void _onBack() {
    if (_step == 0) {
      context.pop();
      return;
    }
    setState(() => _step -= 1);
  }

  Future<void> _onNext() async {
    if (_step == 0) {
      if (!_formKey.currentState!.validate()) return;
      setState(() {
        _step = 1;
        _error = null;
      });
      await _loadApprovedCustomers();
      return;
    }

    if (_selectedMemberIds.isEmpty) {
      setState(() => _error = 'Select at least one approved customer.');
      return;
    }

    await _submit();
  }

  Future<void> _submit() async {
    final session = _session;
    if (session == null || _isSaving) return;

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      final request = CenterCreateRequest(
        name: _nameController.text.trim(),
        productType: _productType,
        loanAmount: double.parse(_loanAmountController.text.trim()),
        interestRate: double.parse(_interestRateController.text.trim()),
        tenureMonths: int.parse(_tenureController.text.trim()),
        emiAmount: double.parse(_emiAmountController.text.trim()),
        memberIds: _selectedMemberIds.toList(),
        branch: session.employee?.branch,
        weight: _emptyToDouble(_weightController.text),
        purity: _emptyToNull(_purityController.text),
        startDate: _startDate,
        remarks: _emptyToNull(_remarksController.text),
      );

      final created = await _centerService.createCenter(
        session: session,
        request: request,
        centerPhoto: _centerPhoto,
      );

      if (!mounted) return;
      await showAppSuccessMessage(
        context,
        message: 'Center ${created.name} created.',
      );
      if (!mounted) return;
      context.pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  double? _emptyToDouble(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  Future<void> _pickCenterPhoto() async {
    final picked = await PickedImage.pick();
    if (picked == null) return;
    setState(() => _centerPhoto = picked);
  }

  void _clearCenterPhoto() => setState(() => _centerPhoto = null);

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;

    return Scaffold(
      appBar: ThemedAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appColors.shinyGold),
          onPressed: _onBack,
        ),
        title: 'New Center',
      ),
      body: session == null || _isLoadingSession
          ? const Center(child: AppLoader(size: kAppPageLoaderSize))
          : SessionScope(
              session: session,
              child: Column(
                children: [
                  WizardStepIndicator(steps: _steps, currentStep: _step),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _steps[_step],
                              style: AppTextStyles.label(context),
                            ),
                            const SizedBox(height: 16),
                            if (_step == 0) _buildDetailsStep() else _buildMembersStep(),
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
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppNextButton(
                            isLastStep: _step == _steps.length - 1,
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

  Widget _buildDetailsStep() {
    return Column(
      children: [
        Text(
          'Group approved customers with gold or silver product and loan terms.',
          style: AppTextStyles.body(context).copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        _SectionCard(
          title: 'Center details',
          children: [
            AppTextField(
              controller: _nameController,
              label: 'Center name',
              hint: 'e.g. Ratlam Group A',
              textInputAction: TextInputAction.next,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _ProductTypeDropdown(
              value: _productType,
              onChanged: (value) {
                if (value != null) setState(() => _productType = value);
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _weightController,
              label: '${_productType.label} weight (grams)',
              hint: 'e.g. 25.500',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _purityController,
              label: 'Purity',
              hint: _productType == CenterProductType.gold ? 'e.g. 22K' : 'e.g. 999',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            AppPhotoPicker(
              label: 'Center photo',
              hint: 'Upload a photo for this center (optional).',
              placeholderIcon: Icons.groups_outlined,
              image: _centerPhoto,
              onPick: _pickCenterPhoto,
              onClear: _centerPhoto?.isNotEmpty == true ? _clearCenterPhoto : null,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Loan terms',
          children: [
            AppTextField(
              controller: _loanAmountController,
              label: 'Loan amount (₹)',
              hint: 'e.g. 500000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Required';
                if (double.tryParse(value.trim()) == null) return 'Invalid amount';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _interestRateController,
              label: 'Interest rate (%)',
              hint: 'e.g. 12',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Required';
                if (double.tryParse(value.trim()) == null) return 'Invalid rate';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _tenureController,
              label: 'Tenure (months)',
              hint: 'e.g. 12',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Required';
                if (int.tryParse(value.trim()) == null) return 'Invalid tenure';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _emiAmountController,
              label: 'EMI amount (₹)',
              hint: 'e.g. 45000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Required';
                if (double.tryParse(value.trim()) == null) return 'Invalid EMI';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _DateField(
              label: 'Start date',
              value: _startDate,
              onTap: _pickStartDate,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _remarksController,
              label: 'Remarks (optional)',
              hint: 'Any notes for this center',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembersStep() {
    final filtered = _approvedCustomers.where((customer) {
      if (_memberSearch.isEmpty) return true;
      final query = _memberSearch.toLowerCase();
      return customer.fullName.toLowerCase().contains(query) ||
          customer.displayCode.toLowerCase().contains(query) ||
          (customer.mobile?.contains(query) ?? false);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select approved customers to include in this center.',
          style: AppTextStyles.body(context).copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _memberSearchController,
          style: AppTextStyles.body(context),
          decoration: InputDecoration(
            hintText: 'Search approved customers',
            hintStyle: AppTextStyles.body(context).copyWith(
              color: context.appColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: context.appColors.shinyGold.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: context.appColors.inputFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.appColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.appColors.border),
            ),
          ),
          onSubmitted: (value) {
            setState(() => _memberSearch = value.trim());
            _loadApprovedCustomers();
          },
        ),
        const SizedBox(height: 8),
        Text(
          '${_selectedMemberIds.length} selected',
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 12),
        if (_isLoadingCustomers)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: AppLoader(size: AppLoaderSize.small)),
          )
        else if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'No approved customers found.',
              style: AppTextStyles.body(context),
            ),
          )
        else
          ...filtered.map((customer) {
            final selected = _selectedMemberIds.contains(customer.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: context.appColors.card,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedMemberIds.remove(customer.id);
                      } else {
                        _selectedMemberIds.add(customer.id);
                      }
                      _error = null;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? context.appColors.gold.withValues(alpha: 0.6)
                            : context.appColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: selected,
                          activeColor: context.appColors.gold,
                          onChanged: (_) {
                            setState(() {
                              if (selected) {
                                _selectedMemberIds.remove(customer.id);
                              } else {
                                _selectedMemberIds.add(customer.id);
                              }
                              _error = null;
                            });
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.fullName,
                                style: AppTextStyles.label(context),
                              ),
                              Text(
                                customer.displayCode,
                                style: AppTextStyles.subtitle(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
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
      width: double.infinity,
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

class _ProductTypeDropdown extends StatelessWidget {
  const _ProductTypeDropdown({
    required this.value,
    required this.onChanged,
  });

  final CenterProductType value;
  final ValueChanged<CenterProductType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product type', style: AppTextStyles.subtitle(context)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: AppDropdownDecoration.container(context),
          child: AppInlineDropdown<CenterProductType>(
            value: value,
            isExpanded: true,
            style: AppTextStyles.body(context),
            items: CenterProductType.options
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.label),
                  ),
                )
                .toList(),
            onChanged: onChanged,
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
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final display = value == null
        ? 'Select date'
        : '${value!.day.toString().padLeft(2, '0')}/'
            '${value!.month.toString().padLeft(2, '0')}/'
            '${value!.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subtitle(context)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: context.appColors.inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.appColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    display,
                    style: AppTextStyles.body(context).copyWith(
                      color: value == null
                          ? context.appColors.textSecondary
                          : context.appColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: context.appColors.shinyGold.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
