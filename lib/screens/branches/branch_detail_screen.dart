import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_service.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/entity_edit_delete_actions.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_section_card.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

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
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _branch = widget.initialBranch;
    _isLoading = _branch == null;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await awaitWithMinPageLoaderDuration(_bootstrapWork());
  }

  Future<void> _bootstrapWork() async {
    final session = await _authService.getSession();
    if (!mounted) return;

    setState(() => _session = session);

    if (session == null) {
      setState(() => _isLoading = false);
      return;
    }

    await _load(silent: _branch != null);
  }

  Future<void> _load({bool silent = false}) async {
    final session = _session ?? await _authService.getSession();
    if (!mounted) return;

    if (session == null) {
      setState(() {
        _isLoading = false;
        if (_branch == null) _error = 'Session unavailable. Please sign in again.';
      });
      return;
    }

    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    Future<void> fetchBranch() async {
      try {
        final branch = await _branchService.fetchBranch(
          session: session,
          branchId: widget.branchId,
        );
        if (!mounted) return;
        setState(() {
          _branch = branch;
          _session = session;
          _error = null;
        });
      } catch (error) {
        if (!mounted) return;
        if (_branch == null) {
          setState(() => _error = error.toString());
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    if (!silent && _branch == null) {
      await awaitWithMinPageLoaderDuration(fetchBranch());
    } else {
      await fetchBranch();
    }
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    return _dateFormat.format(value.toLocal());
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
        appBar: ThemedAppBar(title: 'Branch',
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _error ?? 'Branch not found.',
                  style: AppTextStyles.body(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _load,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.appColors.gold,
                  ),
                  child: const Text('Retry'),
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
          _BranchHeader(branch: branch),
          const SizedBox(height: 16),
          CustomerSectionCard(
            title: 'Branch details',
            child: Column(
              children: [
                CustomerInfoRow(label: 'Name', value: branch.name),
                CustomerInfoRow(label: 'Code', value: branch.displayCode),
                CustomerInfoRow(label: 'City', value: branch.city),
                CustomerInfoRow(
                  label: 'Status',
                  value: branch.isActive ? 'Active' : 'Inactive',
                ),
              ],
            ),
          ),
          if (branch.location != null && branch.location!.isNotEmpty) ...[
            const SizedBox(height: 12),
            CustomerSectionCard(
              title: 'Address',
              child: Text(branch.location!, style: AppTextStyles.body(context)),
            ),
          ],
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: 'Payment QR',
            child: _PaymentQrSection(branch: branch),
          ),
          if (branch.createdAt != null || branch.updatedAt != null) ...[
            const SizedBox(height: 12),
            CustomerSectionCard(
              title: 'Record',
              child: Column(
                children: [
                  CustomerInfoRow(
                    label: 'Created',
                    value: _formatDate(branch.createdAt),
                  ),
                  CustomerInfoRow(
                    label: 'Updated',
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
              branch.isActive ? 'Active' : 'Inactive',
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

  bool get _isImageUrl {
    final url = branch.paymentQrCode;
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (!branch.hasPaymentQr) {
      return Text(
        'No payment QR code uploaded yet.',
        style: AppTextStyles.body(context).copyWith(
          color: context.appColors.textSecondary,
        ),
      );
    }

    if (_isImageUrl) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              branch.paymentQrCode!,
              height: 180,
              width: 180,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _qrFallback(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scan to pay at this branch.',
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
              'Payment QR configured',
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
          Text('QR uploaded', style: AppTextStyles.subtitle(context)),
        ],
      ),
    );
  }
}
