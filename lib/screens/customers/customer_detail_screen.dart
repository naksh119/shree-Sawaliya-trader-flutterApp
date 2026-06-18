import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/customers/customer_service.dart';
import 'package:sawaliyatrader/core/customers/models/customer_detail.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/app_permission.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/permission_widgets.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_section_card.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_status_chip.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({required this.customerId, super.key});

  final int customerId;

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _authService = AuthService();
  final _customerService = CustomerService();
  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  LoginResponse? _session;
  CustomerDetail? _customer;
  bool _isLoading = true;
  bool _isUpdatingStatus = false;
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

    Future<void> fetchCustomer() async {
      try {
        final customer = await _customerService.fetchCustomer(
          session: session,
          customerId: widget.customerId,
        );
        if (!mounted) return;
        setState(() {
          _customer = customer;
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

    if (_customer == null) {
      await awaitWithMinPageLoaderDuration(fetchCustomer());
    } else {
      await fetchCustomer();
    }
  }

  Future<void> _updateStatus(CustomerStatus status) async {
    final session = _session;
    if (session == null || _isUpdatingStatus) return;

    setState(() => _isUpdatingStatus = true);
    try {
      final updated = await _customerService.updateStatus(
        session: session,
        customerId: widget.customerId,
        status: status,
      );
      if (!mounted) return;
      setState(() => _customer = updated);
      _showSnack('Status updated to ${status.label}');
    } catch (error) {
      if (!mounted) return;
      _showSnack(error.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isUpdatingStatus = false);
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
        appBar: ThemedAppBar(title: 'Customer',
        ),
        body: const Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    final permissions = PermissionService(session);
    final customer = _customer;

    return SessionScope(
      session: session,
      child: Scaffold(
        appBar: ThemedAppBar(title: customer?.fullName ?? 'Customer'),
        body: _buildBody(customer, permissions),
        bottomNavigationBar: customer == null
            ? null
            : _StatusActionBar(
                customer: customer,
                permissions: permissions,
                isUpdating: _isUpdatingStatus,
                onApprove: () => _updateStatus(CustomerStatus.approved),
                onReject: () => _updateStatus(CustomerStatus.rejected),
                onMarkApplied: () => _updateStatus(CustomerStatus.applied),
                onMarkUnderReview: () =>
                    _updateStatus(CustomerStatus.underReview),
              ),
      ),
    );
  }

  Widget _buildBody(CustomerDetail? customer, PermissionService permissions) {
    if (_error != null && customer == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, style: AppTextStyles.body(context), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _load,
                style: FilledButton.styleFrom(backgroundColor: context.appColors.gold),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (customer == null) {
      return Center(child: Text('Customer not found.', style: AppTextStyles.body(context)));
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          CustomerSectionCard(
            title: 'Overview',
            trailing: CustomerStatusChip(status: customer.status),
            child: Column(
              children: [
                CustomerInfoRow(label: 'Code', value: customer.displayCode),
                CustomerInfoRow(label: 'Mobile', value: customer.mobile ?? ''),
                CustomerInfoRow(label: 'Email', value: customer.email ?? ''),
                CustomerInfoRow(label: 'Branch', value: customer.branch ?? ''),
                CustomerInfoRow(
                  label: 'Sourced by',
                  value: customer.sourcedBy ?? '',
                ),
                CustomerInfoRow(
                  label: 'Created',
                  value: _formatDate(customer.createdAt),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: 'Personal Details',
            child: Column(
              children: [
                CustomerInfoRow(
                  label: 'Aadhaar',
                  value: customer.aadhaarNumber ?? '',
                ),
                CustomerInfoRow(label: 'PAN', value: customer.panNumber ?? ''),
                CustomerInfoRow(
                  label: 'Date of birth',
                  value: _formatDate(customer.dateOfBirth),
                ),
                CustomerInfoRow(label: 'Gender', value: customer.gender ?? ''),
                CustomerInfoRow(
                  label: 'Occupation',
                  value: customer.occupation ?? '',
                ),
                CustomerInfoRow(
                  label: 'Monthly income',
                  value: _formatMoney(customer.monthlyIncome),
                ),
                CustomerInfoRow(
                  label: 'Address',
                  value: customer.fullAddress,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: 'Family Members',
            child: customer.familyMembers.isEmpty
                ? Text('No family members added.', style: AppTextStyles.subtitle(context))
                : Column(
                    children: [
                      for (final member in customer.familyMembers)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(member.name, style: AppTextStyles.label(context)),
                                    if (member.relationship != null)
                                      Text(
                                        member.relationship!,
                                        style: AppTextStyles.subtitle(context),
                                      ),
                                    if (member.mobile != null)
                                      Text(
                                        member.mobile!,
                                        style: AppTextStyles.body(context),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: 'Maternal House',
            child: customer.maternalHouse == null ||
                    customer.maternalHouse!.isEmpty
                ? Text(
                    'No maternal house details.',
                    style: AppTextStyles.subtitle(context),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (customer.maternalHouse!.contactName != null)
                        Text(
                          customer.maternalHouse!.contactName!,
                          style: AppTextStyles.label(context),
                        ),
                      if (customer.maternalHouse!.contactMobile != null)
                        Text(
                          customer.maternalHouse!.contactMobile!,
                          style: AppTextStyles.body(context),
                        ),
                      if (customer.maternalHouse!.fullAddress.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          customer.maternalHouse!.fullAddress,
                          style: AppTextStyles.body(context),
                        ),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: 'Other Loans',
            child: customer.otherLoans.isEmpty
                ? Text('No other loans recorded.', style: AppTextStyles.subtitle(context))
                : Column(
                    children: [
                      for (final loan in customer.otherLoans)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loan.lenderName ?? 'Loan',
                                style: AppTextStyles.label(context),
                              ),
                              if (loan.loanAmount != null)
                                Text(
                                  'Amount: ${_formatMoney(loan.loanAmount)}',
                                  style: AppTextStyles.body(context),
                                ),
                              if (loan.outstandingAmount != null)
                                Text(
                                  'Outstanding: ${_formatMoney(loan.outstandingAmount)}',
                                  style: AppTextStyles.subtitle(context),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: 'Guarantors',
            child: customer.guarantors.isEmpty
                ? Text('No guarantors added.', style: AppTextStyles.subtitle(context))
                : Column(
                    children: [
                      for (final guarantor in customer.guarantors)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(guarantor.name, style: AppTextStyles.label(context)),
                              if (guarantor.mobile != null)
                                Text(guarantor.mobile!, style: AppTextStyles.body(context)),
                              if (guarantor.relationship != null)
                                Text(
                                  guarantor.relationship!,
                                  style: AppTextStyles.subtitle(context),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: 'Documents',
            child: customer.documents.isEmpty
                ? Text('No documents uploaded.', style: AppTextStyles.subtitle(context))
                : Column(
                    children: [
                      for (final doc in customer.documents)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                color: context.appColors.shinyGold,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  doc.displayName,
                                  style: AppTextStyles.body(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusActionBar extends StatelessWidget {
  const _StatusActionBar({
    required this.customer,
    required this.permissions,
    required this.isUpdating,
    required this.onApprove,
    required this.onReject,
    required this.onMarkApplied,
    required this.onMarkUnderReview,
  });

  final CustomerDetail customer;
  final PermissionService permissions;
  final bool isUpdating;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onMarkApplied;
  final VoidCallback onMarkUnderReview;

  @override
  Widget build(BuildContext context) {
    final canApprove = permissions.canApproveCustomer;
    final canEdit = permissions.canEditCustomer;
    if (!canApprove && !canEdit) return const SizedBox.shrink();

    final children = <Widget>[];

    if (canEdit && customer.status == CustomerStatus.sourced) {
      children.add(
        Expanded(
          child: OutlinedButton(
            onPressed: isUpdating ? null : onMarkApplied,
            child: const Text('Mark Applied'),
          ),
        ),
      );
    }

    if (canEdit && customer.status == CustomerStatus.applied) {
      children.add(
        Expanded(
          child: OutlinedButton(
            onPressed: isUpdating ? null : onMarkUnderReview,
            child: const Text('Send for Review'),
          ),
        ),
      );
    }

    if (canApprove && customer.status.canApproveOrReject) {
      children.addAll([
        Expanded(
          child: OutlinedButton(
            onPressed: isUpdating ? null : onReject,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE57373),
            ),
            child: const Text('Reject'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PermissionButton(
            permission: AppPermission.customerApprove,
            service: permissions,
            label: isUpdating ? 'Saving…' : 'Approve',
            onPressed: isUpdating ? null : onApprove,
          ),
        ),
      ]);
    }

    if (children.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: context.appColors.card,
          border: Border(
            top: BorderSide(color: context.appColors.border),
          ),
        ),
        child: Row(children: children),
      ),
    );
  }
}
