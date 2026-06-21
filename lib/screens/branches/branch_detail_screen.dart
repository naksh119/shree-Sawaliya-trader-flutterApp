import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_service.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_image_viewer.dart';
import 'package:sawaliyatrader/core/widgets/entity_edit_delete_actions.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_section_card.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/screens/branches/branch_delete_helper.dart';
import 'package:sawaliyatrader/screens/branches/branch_patch_section.dart';

class BranchDetailScreen extends StatefulWidget {
  const BranchDetailScreen({
    required this.branchId,
    this.initialBranch,
    super.key,
  });

  final int branchId;
  final BranchDto? initialBranch;

  @override
  State<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> {
  final _authService = AuthService();
  final _branchService = BranchService();
  final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  LoginResponse? _session;
  BranchDto? _branch;
  bool _isLoading = true;
  bool _detailLoadedFromApi = false;
  String? _error;
  String? _fetchWarning;

  @override
  void initState() {
    super.initState();
    _load();
  }

  int get _branchId => widget.branchId;

  Future<void> _load() async {
    final session = await _authService.getSession();
    if (!mounted) return;

    setState(() {
      _session = session;
      _isLoading = _branch == null;
      _error = null;
      _fetchWarning = null;
    });

    if (session == null) {
      setState(() {
        _isLoading = false;
        _error = context.l10n.sessionUnavailable;
      });
      return;
    }

    try {
      final branch = await _branchService.fetchBranch(
        session: session,
        branchId: _branchId,
      );
      if (!mounted) return;
      setState(() {
        _branch = branch;
        _detailLoadedFromApi = true;
        _error = null;
        _fetchWarning = null;
      });
    } catch (error) {
      if (!mounted) return;
      final message =
          error is ApiException ? error.message : error.toString();
      final notFound = error is ApiException && error.statusCode == 404;

      setState(() {
        _detailLoadedFromApi = false;
        if (notFound) {
          _branch = null;
          _error = message;
        } else if (_branch == null) {
          _error = message;
        } else {
          _fetchWarning = message;
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    return _dateFormat.format(value.toLocal());
  }

  Future<void> _deleteBranch(BranchDto branch) async {
    final session = _session;
    if (session == null || !mounted) return;

    final deleted = await confirmAndDeleteBranch(
      context: context,
      branchService: _branchService,
      session: session,
      branch: branch,
      branchId: _branchId,
    );

    if (deleted && mounted) {
      context.pop(true);
    }
  }

  Future<void> _editBranch(BranchDto branch) async {
    final updated = await context.push<bool>(
      AppRoutes.branchEdit(_branchId),
      extra: branch,
    );

    if (updated == true && mounted) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final branch = _branch;

    if (branch == null && _isLoading) {
      return const Scaffold(
        body: Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    if (branch == null) {
      return Scaffold(
        appBar: ThemedAppBar(title: context.l10n.branch,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _error ?? context.l10n.branchNotFound,
                  style: AppTextStyles.body(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _load,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.appColors.gold,
                  ),
                  child: Text(context.l10n.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final session = _session;
    final permissions = session != null ? PermissionService(session) : null;

    final body = RefreshIndicator(
      onRefresh: () => _load(),
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          permissions != null &&
                  (permissions.canEditBranch || permissions.canDeleteBranch)
              ? 100
              : 32,
        ),
        children: [
          if (_fetchWarning != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Text(
                _fetchWarning!,
                style: AppTextStyles.body(context).copyWith(
                  color: Colors.orange.shade900,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          _BranchHeader(branch: branch),
          const SizedBox(height: 16),
          CustomerSectionCard(
            title: context.l10n.branchDetails,
            child: Column(
              children: [
                CustomerInfoRow(label: context.l10n.name, value: branch.name),
                CustomerInfoRow(label: context.l10n.code, value: branch.displayCode),
                CustomerInfoRow(label: context.l10n.city, value: branch.city),
                CustomerInfoRow(
                  label: context.l10n.status,
                  value: branch.isActive ? context.l10n.active : context.l10n.inactive,
                ),
              ],
            ),
          ),
          if (kBranchPatchUiEnabled &&
              permissions?.canEditBranch == true &&
              session != null)
            BranchPatchSection(
              branch: branch,
              branchId: _branchId,
              session: session,
              detailLoadedFromApi: _detailLoadedFromApi,
              onBranchUpdated: (updated) => setState(() {
                _branch = updated;
                _fetchWarning = null;
              }),
              onBranchNotFound: () => setState(() {
                _branch = null;
                _detailLoadedFromApi = false;
                _error = context.l10n.branchNotFoundDeleted;
              }),
            ),
          if (branch.location != null && branch.location!.isNotEmpty) ...[
            const SizedBox(height: 12),
            CustomerSectionCard(
              title: context.l10n.address,
              child: Text(branch.location!, style: AppTextStyles.body(context)),
            ),
          ],
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: context.l10n.paymentQrCode,
            child: _PaymentQrSection(branch: branch),
          ),
          if (branch.createdAt != null || branch.updatedAt != null) ...[
            const SizedBox(height: 12),
            CustomerSectionCard(
              title: context.l10n.record,
              child: Column(
                children: [
                  CustomerInfoRow(
                    label: context.l10n.created,
                    value: _formatDate(branch.createdAt),
                  ),
                  CustomerInfoRow(
                    label: context.l10n.updated,
                    value: _formatDate(branch.updatedAt),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    final scaffold = Scaffold(
      appBar: ThemedAppBar(
        title: branch.name,
      ),
      body: body,
      bottomNavigationBar: permissions == null
          ? null
          : EntityEditDeleteBar(
              entityName: branch.name,
              canEdit: permissions.canEditBranch,
              canDelete: permissions.canDeleteBranch,
              onEdit: () => _editBranch(branch),
              onDelete: () => _deleteBranch(branch),
            ),
    );

    if (session == null) return scaffold;

    return SessionScope(session: session, child: scaffold);
  }
}

class _BranchHeader extends StatelessWidget {
  const _BranchHeader({required this.branch});

  final BranchDto branch;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        branch.isActive ? const Color(0xFF4CAF50) : context.appColors.textPrimary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: context.appColors.gold.withValues(alpha: 0.18),
            child: Text(
              branch.initials,
              style: AppTextStyles.heading(context).copyWith(
                color: context.appColors.shinyGold,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(branch.name, style: AppTextStyles.label(context)),
                const SizedBox(height: 4),
                Text(branch.displayCode, style: AppTextStyles.subtitle(context)),
                if (branch.city.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(branch.city, style: AppTextStyles.body(context)),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              branch.isActive ? context.l10n.active : context.l10n.inactive,
              style: AppTextStyles.subtitle(context).copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentQrSection extends StatelessWidget {
  const _PaymentQrSection({required this.branch});

  final BranchDto branch;

  bool get _isImageUrl => appPreviewImageIsNetworkUrl(branch.paymentQrCode);

  @override
  Widget build(BuildContext context) {
    if (!branch.hasPaymentQr) {
      return Text(
        context.l10n.noPaymentQrUploaded,
        style: AppTextStyles.body(context).copyWith(
          color: context.appColors.textSecondary,
        ),
      );
    }

    if (_isImageUrl) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPreviewImage(
            imageUrl: branch.paymentQrCode,
            height: 180,
            width: 180,
            fit: BoxFit.contain,
            borderRadius: BorderRadius.circular(12),
            viewerTitle: context.l10n.paymentQrCode,
            placeholder: _qrFallback(context),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.scanToPayBranch,
            style: AppTextStyles.subtitle(context),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.qr_code_2_rounded,
              color: context.appColors.shinyGold.withValues(alpha: 0.85),
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.paymentQrConfigured,
              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(branch.paymentQrCode!, style: AppTextStyles.subtitle(context)),
      ],
    );
  }

  Widget _qrFallback(BuildContext context) {
    return Container(
      height: 180,
      width: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.appColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.qr_code_2_rounded,
            size: 48,
            color: context.appColors.shinyGold.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 8),
          Text(context.l10n.qrUploaded, style: AppTextStyles.subtitle(context)),
        ],
      ),
    );
  }
}
