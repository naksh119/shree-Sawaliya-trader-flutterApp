import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/centers/center_service.dart';
import 'package:sawaliyatrader/core/centers/models/center_detail.dart';
import 'package:sawaliyatrader/core/centers/models/center_member.dart';
import 'package:sawaliyatrader/core/customers/customer_service.dart';
import 'package:sawaliyatrader/core/customers/models/customer_dto.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_primary_button.dart';
import 'package:sawaliyatrader/core/widgets/app_success_message.dart';
import 'package:sawaliyatrader/core/widgets/entity_edit_delete_actions.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/screens/centers/widgets/center_status_chip.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_section_card.dart';

class CenterDetailScreen extends StatefulWidget {
  const CenterDetailScreen({required this.centerId, super.key});

  final int centerId;

  @override
  State<CenterDetailScreen> createState() => _CenterDetailScreenState();
}

class _CenterDetailScreenState extends State<CenterDetailScreen> {
  final _authService = AuthService();
  final _centerService = CenterService();
  final _customerService = CustomerService();
  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  LoginResponse? _session;
  CenterDetail? _center;
  bool _isLoading = true;
  bool _isGeneratingEmi = false;
  bool _isUpdatingMembers = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final session = await _authService.getSession();
    if (!mounted) return;

    setState(() {
      _session = session;
      _isLoading = true;
      _error = null;
    });

    if (session == null) {
      setState(() => _isLoading = false);
      return;
    }

    Future<void> fetchCenter() async {
      try {
        final center = await _centerService.fetchCenter(
          session: session,
          centerId: widget.centerId,
        );
        if (!mounted) return;
        setState(() {
          _center = center;
          _error = null;
        });
      } catch (error) {
        if (!mounted) return;
        setState(() => _error = error.toString());
      } finally {
        if (!mounted) return;
        setState(() => _isLoading = false);
      }
    }

    if (_center == null) {
      await awaitWithMinPageLoaderDuration(fetchCenter());
    } else {
      await fetchCenter();
    }
  }

  Future<void> _generateEmi() async {
    final session = _session;
    if (session == null || _isGeneratingEmi) return;

    setState(() => _isGeneratingEmi = true);
    try {
      final updated = await _centerService.generateEmi(
        session: session,
        centerId: widget.centerId,
      );
      if (!mounted) return;
      setState(() => _center = updated);
      await showAppSuccessMessage(
        context,
        message: 'EMI schedule generated for ${updated.name}.',
      );
    } catch (error) {
      if (!mounted) return;
      _showSnack(error.toString());
    } finally {
      if (mounted) setState(() => _isGeneratingEmi = false);
    }
  }

  Future<void> _addMember() async {
    final session = _session;
    final center = _center;
    if (session == null || center == null || _isUpdatingMembers) return;

    final customerId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _AddMemberSheet(
        session: session,
        customerService: _customerService,
        existingCustomerIds: center.members.map((m) => m.customerId).toSet(),
        branch: session.employee?.branch,
      ),
    );

    if (customerId == null) return;

    setState(() => _isUpdatingMembers = true);
    try {
      await _centerService.addMember(
        session: session,
        centerId: widget.centerId,
        customerId: customerId,
      );
      if (!mounted) return;
      await _load();
      _showSnack('Member added.');
    } catch (error) {
      if (!mounted) return;
      _showSnack(error.toString());
    } finally {
      if (mounted) setState(() => _isUpdatingMembers = false);
    }
  }

  Future<void> _removeMember(CenterMember member) async {
    final session = _session;
    if (session == null || _isUpdatingMembers) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.appColors.card,
        title: Text('Remove member?', style: AppTextStyles.label(context)),
        content: Text(
          'Remove ${member.customerName} from this center?',
          style: AppTextStyles.body(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE57373),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isUpdatingMembers = true);
    try {
      await _centerService.removeMember(
        session: session,
        centerId: widget.centerId,
        memberId: member.id,
      );
      if (!mounted) return;
      await _load();
      _showSnack('Member removed.');
    } catch (error) {
      if (!mounted) return;
      _showSnack(error.toString());
    } finally {
      if (mounted) setState(() => _isUpdatingMembers = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String _formatMoney(double? value) {
    if (value == null) return '';
    return _currencyFormat.format(value);
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    return DateFormat('dd MMM yyyy').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null || _isLoading) {
      return Scaffold(
        appBar: const ThemedAppBar(title: 'Center'),
        body: const Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    final permissions = PermissionService(session);
    final center = _center;

    return SessionScope(
      session: session,
      child: Scaffold(
        appBar: ThemedAppBar(
          title: center?.name ?? 'Center',
          actions: center == null
              ? const []
              : buildEntityEditDeleteAppBarActions(
                  context,
                  entityName: center.name,
                  canEdit: permissions.canEditCenter,
                  canDelete: permissions.canDeleteCenter,
                ),
        ),
        body: _buildBody(center, permissions),
        bottomNavigationBar: center == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EntityEditDeleteBar(
                    entityName: center.name,
                    canEdit: permissions.canEditCenter,
                    canDelete: permissions.canDeleteCenter,
                  ),
                  _ActionBar(
                    center: center,
                    permissions: permissions,
                    isGeneratingEmi: _isGeneratingEmi,
                    onGenerateEmi: _generateEmi,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBody(CenterDetail? center, PermissionService permissions) {
    if (_error != null && center == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
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
      );
    }

    if (center == null) {
      return Center(
        child: Text('Center not found.', style: AppTextStyles.body(context)),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          permissions.canCreateCenter && !center.emiGenerated ? 100 : 24,
        ),
        children: [
          CustomerSectionCard(
            title: 'Overview',
            trailing: CenterStatusChip(status: center.status),
            child: Column(
              children: [
                CustomerInfoRow(label: 'Code', value: center.displayCode),
                CustomerInfoRow(label: 'Branch', value: center.branch ?? ''),
                CustomerInfoRow(
                  label: 'Product',
                  value: center.productType?.label ?? '',
                ),
                CustomerInfoRow(
                  label: 'Start date',
                  value: _formatDate(center.startDate),
                ),
                CustomerInfoRow(
                  label: 'EMI schedule',
                  value: center.emiGenerated ? 'Generated' : 'Not generated',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: 'Loan & product',
            child: Column(
              children: [
                CustomerInfoRow(
                  label: 'Loan amount',
                  value: _formatMoney(center.loanAmount),
                ),
                CustomerInfoRow(
                  label: 'Interest rate',
                  value: center.interestRate != null
                      ? '${center.interestRate!.toStringAsFixed(2)}%'
                      : '',
                ),
                CustomerInfoRow(
                  label: 'Tenure',
                  value: center.tenureMonths != null
                      ? '${center.tenureMonths} months'
                      : '',
                ),
                CustomerInfoRow(
                  label: 'EMI amount',
                  value: _formatMoney(center.emiAmount),
                ),
                CustomerInfoRow(
                  label: 'Weight',
                  value: center.weight != null
                      ? '${center.weight!.toStringAsFixed(3)} g'
                      : '',
                ),
                CustomerInfoRow(label: 'Purity', value: center.purity ?? ''),
                CustomerInfoRow(label: 'Remarks', value: center.remarks ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: 'Members (${center.memberCount})',
            trailing: permissions.canCreateCenter
                ? IconButton(
                    icon: Icon(
                      Icons.person_add_outlined,
                      color: context.appColors.shinyGold,
                    ),
                    onPressed: _isUpdatingMembers ? null : _addMember,
                  )
                : null,
            child: center.members.isEmpty
                ? Text(
                    'No members linked yet.',
                    style: AppTextStyles.body(context).copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  )
                : Column(
                    children: [
                      for (final member in center.members) ...[
                        _MemberTile(
                          member: member,
                          canRemove: permissions.canCreateCenter,
                          isBusy: _isUpdatingMembers,
                          onRemove: () => _removeMember(member),
                          onTap: () => context.push(
                            AppRoutes.customerDetail(member.customerId),
                          ),
                        ),
                        if (member != center.members.last)
                          const SizedBox(height: 8),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.canRemove,
    required this.isBusy,
    required this.onRemove,
    required this.onTap,
  });

  final CenterMember member;
  final bool canRemove;
  final bool isBusy;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: context.appColors.gold.withValues(alpha: 0.18),
                child: Text(
                  member.customerName.isNotEmpty
                      ? member.customerName[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.subtitle(context).copyWith(
                    color: context.appColors.shinyGold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.customerName, style: AppTextStyles.label(context)),
                    Text(
                      member.displayCode,
                      style: AppTextStyles.subtitle(context),
                    ),
                    if (member.mobile != null)
                      Text(member.mobile!, style: AppTextStyles.body(context)),
                  ],
                ),
              ),
              if (member.isLeader)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.appColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Leader',
                    style: AppTextStyles.subtitle(context).copyWith(
                      color: context.appColors.shinyGold,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (canRemove)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  color: context.appColors.textSecondary,
                  onPressed: isBusy ? null : onRemove,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.center,
    required this.permissions,
    required this.isGeneratingEmi,
    required this.onGenerateEmi,
  });

  final CenterDetail center;
  final PermissionService permissions;
  final bool isGeneratingEmi;
  final VoidCallback onGenerateEmi;

  @override
  Widget build(BuildContext context) {
    if (!permissions.canCreateCenter || center.emiGenerated) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          color: context.appColors.card,
          border: Border(top: BorderSide(color: context.appColors.border)),
        ),
        child: AppPrimaryButton(
          label: 'Generate EMI schedule',
          isLoading: isGeneratingEmi,
          onPressed: isGeneratingEmi ? null : onGenerateEmi,
        ),
      ),
    );
  }
}

class _AddMemberSheet extends StatefulWidget {
  const _AddMemberSheet({
    required this.session,
    required this.customerService,
    required this.existingCustomerIds,
    this.branch,
  });

  final LoginResponse session;
  final CustomerService customerService;
  final Set<int> existingCustomerIds;
  final String? branch;

  @override
  State<_AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<_AddMemberSheet> {
  final _searchController = TextEditingController();
  List<CustomerDto> _customers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers({String? search}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await widget.customerService.fetchCustomers(
        session: widget.session,
        page: 1,
        pageSize: 50,
        status: CustomerStatus.approved,
        branch: widget.branch,
        search: search,
      );
      if (!mounted) return;
      setState(() {
        _customers = response.items
            .where((c) => !widget.existingCustomerIds.contains(c.id))
            .toList();
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.75;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SizedBox(
        height: maxHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text('Add member', style: AppTextStyles.label(context)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.body(context),
                decoration: InputDecoration(
                  hintText: 'Search approved customers',
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
                onSubmitted: (value) => _loadCustomers(search: value.trim()),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: AppLoader(size: AppLoaderSize.small))
                  : _error != null
                      ? Center(
                          child: Text(
                            _error!,
                            style: AppTextStyles.body(context),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : _customers.isEmpty
                          ? Center(
                              child: Text(
                                'No eligible customers found.',
                                style: AppTextStyles.body(context),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              itemCount: _customers.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final customer = _customers[index];
                                return ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: context.appColors.border,
                                    ),
                                  ),
                                  tileColor: context.appColors.surface,
                                  title: Text(
                                    customer.fullName,
                                    style: AppTextStyles.label(context),
                                  ),
                                  subtitle: Text(customer.displayCode),
                                  trailing: Icon(
                                    Icons.add_circle_outline,
                                    color: context.appColors.shinyGold,
                                  ),
                                  onTap: () =>
                                      Navigator.pop(context, customer.id),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
