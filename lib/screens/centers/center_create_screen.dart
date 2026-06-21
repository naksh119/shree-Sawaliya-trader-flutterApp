import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/session_bootstrap.dart';
import 'package:sawaliyatrader/core/centers/center_service.dart';
import 'package:sawaliyatrader/core/centers/models/center_create_request.dart';
import 'package:sawaliyatrader/core/centers/models/center_product_type.dart';
import 'package:sawaliyatrader/core/customers/customer_service.dart';
import 'package:sawaliyatrader/core/customers/models/customer_dto.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_next_button.dart';
import 'package:sawaliyatrader/core/widgets/app_success_message.dart';
import 'package:sawaliyatrader/core/widgets/app_search_field.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/l10n/app_localizations.dart';

class CenterCreateScreen extends StatefulWidget implements HasInitialSession {
  const CenterCreateScreen({super.key, this.initialSession});

  @override
  final LoginResponse? initialSession;

  @override
  State<CenterCreateScreen> createState() => _CenterCreateScreenState();
}

class _CenterCreateScreenState extends State<CenterCreateScreen>
    with SessionBootstrapMixin {
  final _centerService = CenterService();
  final _customerService = CustomerService();
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;
  bool _isLoadingCustomers = false;
  int _step = 0;
  String? _error;
  String? _startDateError;

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
  final Set<int> _selectedMemberIds = {};
  List<CustomerDto> _approvedCustomers = [];
  String _memberSearch = '';

  @override
  void initState() {
    super.initState();
    initSessionBootstrap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resolveSessionFromContext();
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
    super.dispose();
  }

  Future<void> _loadApprovedCustomers() async {
    final activeSession = session;
    if (activeSession == null || _isLoadingCustomers) return;

    setState(() => _isLoadingCustomers = true);
    try {
      final response = await _customerService.fetchCustomers(
        session: activeSession,
        page: 1,
        pageSize: 100,
        status: CustomerStatus.approved,
        branch: activeSession.employee?.branch,
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
      if (_startDate == null) {
        setState(() => _startDateError = context.l10n.startDateRequired);
        return;
      }
      setState(() {
        _step = 1;
        _error = null;
        _startDateError = null;
      });
      await _loadApprovedCustomers();
      return;
    }

    if (_selectedMemberIds.isEmpty) {
      setState(() => _error = context.l10n.selectApprovedCustomerError);
      return;
    }

    await _submit();
  }

  Future<void> _submit() async {
    final activeSession = session;
    if (activeSession == null || _isSaving) return;

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
        branch: activeSession.employee?.branch,
        weight: _emptyToDouble(_weightController.text),
        purity: _emptyToNull(_purityController.text),
        startDate: _startDate,
        remarks: _emptyToNull(_remarksController.text),
      );

      final created = await _centerService.createCenter(
        session: activeSession,
        request: request,
      );

      if (!mounted) return;
      await showAppSuccessMessage(
        context,
        message: context.l10n.centerCreated(created.name),
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

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = centerWizardSteps(l10n);

    return Scaffold(
      appBar: ThemedAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appColors.shinyGold),
          onPressed: _onBack,
        ),
        title: l10n.newCenter,
      ),
      body: session == null
          ? const Center(child: AppLoader(size: kAppPageLoaderSize))
          : SessionScope(
              session: session!,
              child: Column(
                children: [
                  _StepIndicator(steps: steps, currentStep: _step),
                  Expanded(
                    child: SingleChildScrollView(
                      key: ValueKey(_step),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              steps[_step],
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

  Widget _buildDetailsStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.centerCreateIntro,
          style: AppTextStyles.body(context).copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        _SectionCard(
          title: l10n.centerDetails,
          children: [
            AppTextField(
              controller: _nameController,
              label: l10n.centerName,
              hint: l10n.centerNameHint,
              textInputAction: TextInputAction.next,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? l10n.required : null,
            ),
            const SizedBox(height: 16),
            AppDropdownFormField<CenterProductType>(
              value: _productType,
              decoration: AppDropdownDecoration.formField(
                context,
                labelText: l10n.productType,
              ),
              validator: (value) => value == null ? l10n.required : null,
              items: CenterProductType.options
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.localizedLabel(context),
                        style: AppTextStyles.body(context),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _productType = value);
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _weightController,
              label: l10n.weightGrams(_productType.localizedLabel(context)),
              hint: l10n.weightHint,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return l10n.required;
                if (double.tryParse(value.trim()) == null) return l10n.invalidAmount;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _purityController,
              label: l10n.purity,
              hint: _productType == CenterProductType.gold
                  ? l10n.purityGoldHint
                  : l10n.puritySilverHint,
              textInputAction: TextInputAction.next,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? l10n.required : null,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: l10n.loanTerms,
          children: [
            AppTextField(
              controller: _loanAmountController,
              label: l10n.loanAmountSymbol,
              hint: l10n.loanAmountHint,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return l10n.required;
                if (double.tryParse(value.trim()) == null) return l10n.invalidAmount;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _interestRateController,
              label: l10n.interestRate,
              hint: l10n.interestRateHint,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return l10n.required;
                if (double.tryParse(value.trim()) == null) return l10n.invalidRate;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _tenureController,
              label: l10n.tenureMonths,
              hint: l10n.tenureHint,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return l10n.required;
                if (int.tryParse(value.trim()) == null) return l10n.invalidTenure;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _emiAmountController,
              label: l10n.emiAmountSymbol,
              hint: l10n.emiAmountHint,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return l10n.required;
                if (double.tryParse(value.trim()) == null) return l10n.invalidEmi;
                return null;
              },
            ),
            const SizedBox(height: 16),
            _DateField(
              label: l10n.startDate,
              value: _startDate,
              errorText: _startDateError,
              onTap: _pickStartDate,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _remarksController,
              label: l10n.remarks,
              hint: l10n.centerRemarksHint,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? l10n.required : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembersStep() {
    final l10n = AppLocalizations.of(context)!;
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
          l10n.selectApprovedCustomers,
          style: AppTextStyles.body(context).copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        AppSearchField(
          hintText: l10n.searchApprovedCustomersHint,
          onSearch: (query) {
            setState(() => _memberSearch = query);
            _loadApprovedCustomers();
          },
        ),
        const SizedBox(height: 8),
        Text(
          l10n.selectedCount(_selectedMemberIds.length),
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
              l10n.noApprovedCustomers,
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

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.steps,
    required this.currentStep,
  });

  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          for (var index = 0; index < steps.length; index++) ...[
            if (index > 0)
              Expanded(
                child: Container(
                  height: 2,
                  color: index <= currentStep
                      ? context.appColors.gold.withValues(alpha: 0.5)
                      : context.appColors.border,
                ),
              ),
            _StepDot(
              label: '${index + 1}',
              isActive: index == currentStep,
              isComplete: index < currentStep,
            ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.isActive,
    required this.isComplete,
  });

  final String label;
  final bool isActive;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final color = isActive || isComplete
        ? context.appColors.gold
        : context.appColors.border;

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive || isComplete
            ? color.withValues(alpha: 0.18)
            : context.appColors.card,
        border: Border.all(color: color),
      ),
      child: isComplete
          ? Icon(Icons.check, size: 16, color: context.appColors.shinyGold)
          : Text(label, style: AppTextStyles.subtitle(context)),
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

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.errorText,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final display = value == null
        ? l10n.selectDate
        : '${value!.day.toString().padLeft(2, '0')}/'
            '${value!.month.toString().padLeft(2, '0')}/'
            '${value!.year}';
    final hasError = errorText != null;

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
              border: Border.all(
                color: hasError
                    ? Colors.red.shade300
                    : context.appColors.border,
              ),
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
