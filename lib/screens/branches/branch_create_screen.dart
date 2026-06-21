import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/branches/branch_service.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
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

class BranchCreateScreen extends StatefulWidget {
  const BranchCreateScreen({super.key});

  @override
  State<BranchCreateScreen> createState() => _BranchCreateScreenState();
}

class _BranchCreateScreenState extends State<BranchCreateScreen> {
  final _authService = AuthService();
  final _branchService = BranchService();
  final _formKey = GlobalKey<FormState>();

  LoginResponse? _session;
  bool _isLoadingSession = true;
  bool _isSaving = false;
  String? _error;

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationController = TextEditingController();

  PickedImage? _paymentQrCode;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await _bootstrapWork();
  }

  Future<void> _bootstrapWork() async {
    final session = await _authService.getSession();
    if (!mounted) return;
    setState(() {
      _session = session;
      _isLoadingSession = false;
    });
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
      final request = BranchCreateRequest(
        name: _nameController.text.trim(),
        code: _codeController.text.trim(),
        city: _cityController.text.trim(),
        location: _emptyToNull(_locationController.text),
      );

      final created = await _branchService.createBranch(
        session: session,
        request: request,
        paymentQrCode: _paymentQrCode,
      );

      if (!mounted) return;
      await showAppSuccessMessage(
        context,
        message: context.l10n.branchCreated(created.name),
      );
      if (!mounted) return;
      context.pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
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

  Future<void> _pickPaymentQr() async {
    final picked = await PickedImage.pick();
    if (picked == null) return;
    setState(() => _paymentQrCode = picked);
  }

  void _clearPaymentQr() {
    setState(() => _paymentQrCode = null);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;

    return Scaffold(
      appBar: ThemedAppBar(title: context.l10n.newBranch,
      ),
      body: session == null || _isLoadingSession
          ? const Center(child: AppLoader(size: kAppPageLoaderSize))
          : SessionScope(
              session: session,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: [
                    Text(
                      context.l10n.branchCreateIntro,
                      style: AppTextStyles.body(context).copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: context.l10n.branchDetails,
                      children: [
                        AppTextField(
                          controller: _nameController,
                          label: context.l10n.branchName,
                          hint: context.l10n.branchNameHint,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? context.l10n.branchNameRequired
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _codeController,
                          label: context.l10n.branchCode,
                          hint: context.l10n.branchCodeHint,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            final trimmed = value?.trim() ?? '';
                            if (trimmed.isEmpty) {
                              return context.l10n.branchCodeRequired;
                            }
                            if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(trimmed)) {
                              return context.l10n.employeeCodeFormat;
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _cityController,
                          label: context.l10n.city,
                          hint: context.l10n.cityHint,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? context.l10n.cityRequired
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _locationController,
                          label: context.l10n.location,
                          hint: context.l10n.addressHint,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.streetAddress,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: context.l10n.paymentQrCode,
                      children: [
                        AppPhotoPicker(
                          label: context.l10n.paymentQrCode,
                          hint: context.l10n.branchQrUploadHint,
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
                        style: AppTextStyles.body(context).copyWith(color: Colors.red.shade700),
                      ),
                    ],
                    const SizedBox(height: 24),
                    AppPrimaryButton(
                      label: context.l10n.createBranch,
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
