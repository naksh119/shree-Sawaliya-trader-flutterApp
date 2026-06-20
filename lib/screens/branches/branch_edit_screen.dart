import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/branches/branch_service.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_message.dart';
import 'package:sawaliyatrader/core/widgets/app_photo_picker.dart';
import 'package:sawaliyatrader/core/widgets/app_primary_button.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';

class BranchEditScreen extends StatefulWidget {
  const BranchEditScreen({
    required this.branchId,
    this.initialBranch,
    super.key,
  });

  final int branchId;
  final BranchDto? initialBranch;

  @override
  State<BranchEditScreen> createState() => _BranchEditScreenState();
}

class _BranchEditScreenState extends State<BranchEditScreen> {
  final _authService = AuthService();
  final _branchService = BranchService();
  final _formKey = GlobalKey<FormState>();

  LoginResponse? _session;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isActive = true;
  String? _error;

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationController = TextEditingController();

  PickedImage? _paymentQrCode;
  String? _existingPaymentQrUrl;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _applyBranch(BranchDto branch) {
    _nameController.text = branch.name;
    _codeController.text = branch.code;
    _cityController.text = branch.city;
    _locationController.text = branch.location ?? '';
    _isActive = branch.isActive;
    _existingPaymentQrUrl =
        branch.hasPaymentQr ? branch.paymentQrCode : null;
    _paymentQrCode = null;
  }

  Future<void> _load() async {
    final session = await _authService.getSession();
    if (!mounted) return;

    final initialBranch = widget.initialBranch;
    if (initialBranch != null) {
      _applyBranch(initialBranch);
    }

    setState(() {
      _session = session;
      _isLoading = initialBranch == null;
      _error = null;
    });

    if (session == null) {
      setState(() {
        _isLoading = false;
        _error = 'Session unavailable. Please sign in again.';
      });
      return;
    }

    if (initialBranch != null) {
      _fetchBranch(session);
      return;
    }

    await _fetchBranch(session);
  }

  Future<void> _fetchBranch(LoginResponse session) async {
    try {
      final branch = await _branchService.fetchBranch(
        session: session,
        branchId: widget.branchId,
      );
      if (!mounted) return;
      _applyBranch(branch);
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

  Future<void> _submit() async {
    final session = _session;
    if (session == null || _isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      final request = BranchUpdateRequest(
        name: _nameController.text.trim(),
        code: _codeController.text.trim(),
        city: _cityController.text.trim(),
        location: _emptyToNull(_locationController.text),
        isActive: _isActive,
      );

      final updated = await _branchService.updateBranch(
        session: session,
        branchId: widget.branchId,
        request: request,
        paymentQrCode: _paymentQrCode,
      );

      if (!mounted) return;
      await showAppSuccessMessage(
        context,
        message: 'Branch ${updated.name} updated.',
      );
      if (!mounted) return;
      context.pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is ApiException ? error.message : error.toString();
      });
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _pickPaymentQr() async {
    final picked = await PickedImage.pick();
    if (picked == null) return;
    setState(() => _paymentQrCode = picked);
  }

  void _clearPaymentQr() {
    setState(() => _paymentQrCode = null);
  }

  bool get _showExistingQrPreview {
    final hasNewQr = _paymentQrCode?.isNotEmpty ?? false;
    final url = _existingPaymentQrUrl;
    return !hasNewQr && url != null && url.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;

    return Scaffold(
      appBar: ThemedAppBar(title: 'Edit Branch'),
      body: session == null || _isLoading
          ? const Center(child: AppLoader(size: kAppPageLoaderSize))
          : SessionScope(
              session: session,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    Text(
                      'Full update uses PUT (all fields) via Save changes on the edit screen.',
                      style: AppTextStyles.body(context).copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: 'Branch details',
                      children: [
                        AppTextField(
                          controller: _nameController,
                          label: 'Branch name',
                          hint: 'e.g. Jaipur Branch',
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Branch name is required'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _codeController,
                          label: 'Branch code',
                          hint: 'e.g. JAI',
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            final trimmed = value?.trim() ?? '';
                            if (trimmed.isEmpty) {
                              return 'Branch code is required';
                            }
                            if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(trimmed)) {
                              return 'Use letters, numbers, hyphen, or underscore';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _cityController,
                          label: 'City',
                          hint: 'e.g. Jaipur',
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'City is required'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _locationController,
                          label: 'Address / location',
                          hint: 'Street address or landmark',
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Active branch',
                            style: AppTextStyles.body(context),
                          ),
                          subtitle: Text(
                            _isActive
                                ? 'Branch is visible and usable'
                                : 'Branch is inactive',
                            style: AppTextStyles.subtitle(context),
                          ),
                          value: _isActive,
                          onChanged: (value) => setState(() => _isActive = value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Payment QR',
                      children: [
                        AppPhotoPicker(
                          label: 'Payment QR code',
                          existingImageUrl: _showExistingQrPreview
                              ? _existingPaymentQrUrl
                              : null,
                          existingImageLabel: 'Current QR',
                          hint: _existingPaymentQrUrl != null
                              ? 'Choose a new image to replace the current QR.'
                              : 'Upload the branch payment QR image (optional).',
                          placeholderIcon: Icons.qr_code_2_rounded,
                          image: _paymentQrCode,
                          onPick: _pickPaymentQr,
                          onClear: _paymentQrCode?.isNotEmpty == true
                              ? _clearPaymentQr
                              : null,
                        ),
                      ],
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: AppTextStyles.body(context)
                            .copyWith(color: Colors.red.shade700),
                      ),
                    ],
                    const SizedBox(height: 24),
                    AppPrimaryButton(
                      label: 'Save changes (PUT)',
                      isLoading: _isSaving,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
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
