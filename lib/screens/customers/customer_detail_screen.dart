import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/customers/customer_service.dart';
import 'package:sawaliyatrader/core/customers/models/customer_detail.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/permissions/app_permission.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/permission_widgets.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_section_card.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_status_chip.dart';
import 'package:sawaliyatrader/core/widgets/app_image_viewer.dart';
import 'package:sawaliyatrader/core/widgets/app_message.dart';
import 'package:sawaliyatrader/core/widgets/entity_edit_delete_actions.dart';
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

    await fetchCustomer();
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
      await showAppSuccessMessage(
        context,
        message: context.l10n.statusUpdatedTo(status.localizedLabel(context)),
      );
    } catch (error) {
      if (!mounted) return;
      await showAppErrorMessage(context, message: error.toString());
    } finally {
      if (!mounted) return;
      setState(() => _isUpdatingStatus = false);
    }
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
        appBar: ThemedAppBar(title: context.l10n.customer,
        ),
        body: const Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    final permissions = PermissionService(session);
    final customer = _customer;

    return SessionScope(
      session: session,
      child: Scaffold(
        appBar: ThemedAppBar(
          title: customer?.fullName ?? context.l10n.customer,
        ),
        body: _buildBody(customer, permissions),
        bottomNavigationBar: customer == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EntityEditDeleteBar(
                    entityName: customer.fullName,
                    canEdit: permissions.canEditCustomer,
                    canDelete: permissions.canDeleteCustomer,
                  ),
                  _StatusActionBar(
                    customer: customer,
                    permissions: permissions,
                    isUpdating: _isUpdatingStatus,
                    onApprove: () => _updateStatus(CustomerStatus.approved),
                    onReject: () => _updateStatus(CustomerStatus.rejected),
                    onMarkApplied: () => _updateStatus(CustomerStatus.applied),
                    onMarkUnderReview: () =>
                        _updateStatus(CustomerStatus.underReview),
                  ),
                ],
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
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (customer == null) {
      return Center(child: Text(context.l10n.customerNotFound, style: AppTextStyles.body(context)));
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          CustomerSectionCard(
            title: context.l10n.overview,
            trailing: CustomerStatusChip(status: customer.status),
            child: Column(
              children: [
                CustomerInfoRow(label: context.l10n.code, value: customer.displayCode),
                CustomerInfoRow(label: context.l10n.mobile, value: customer.mobile ?? ''),
                CustomerInfoRow(label: context.l10n.email, value: customer.email ?? ''),
                CustomerInfoRow(label: context.l10n.branchLabel, value: customer.branch ?? ''),
                CustomerInfoRow(
                  label: context.l10n.sourcedBy,
                  value: customer.sourcedBy ?? '',
                ),
                CustomerInfoRow(
                  label: context.l10n.created,
                  value: _formatDate(customer.createdAt),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: context.l10n.personalDetails,
            child: Column(
              children: [
                CustomerInfoRow(
                  label: context.l10n.aadhaar,
                  value: customer.aadhaarNumber ?? '',
                ),
                CustomerInfoRow(label: context.l10n.pan, value: customer.panNumber ?? ''),
                CustomerInfoRow(
                  label: context.l10n.dateOfBirth,
                  value: _formatDate(customer.dateOfBirth),
                ),
                CustomerInfoRow(
                  label: context.l10n.gender,
                  value: localizedGenderLabel(
                    context.l10n,
                    customer.gender,
                  ),
                ),
                CustomerInfoRow(
                  label: context.l10n.occupation,
                  value: customer.occupation ?? '',
                ),
                CustomerInfoRow(
                  label: context.l10n.monthlyIncome,
                  value: _formatMoney(customer.monthlyIncome),
                ),
                CustomerInfoRow(
                  label: context.l10n.address,
                  value: customer.fullAddress,
                ),
              ],
            ),
          ),
          if (appPreviewImageIsNetworkUrl(customer.livePhoto) ||
              appPreviewImageIsNetworkUrl(customer.housePhoto)) ...[
            const SizedBox(height: 12),
            CustomerSectionCard(
              title: context.l10n.photos,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (appPreviewImageIsNetworkUrl(customer.livePhoto)) ...[
                    Text(context.l10n.customerImage, style: AppTextStyles.subtitle(context)),
                    const SizedBox(height: 8),
                    AppPreviewImage(
                      imageUrl: customer.livePhoto,
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(12),
                      viewerTitle: context.l10n.customerImage,
                    ),
                  ],
                  if (appPreviewImageIsNetworkUrl(customer.livePhoto) &&
                      appPreviewImageIsNetworkUrl(customer.housePhoto))
                    const SizedBox(height: 16),
                  if (appPreviewImageIsNetworkUrl(customer.housePhoto)) ...[
                    Text(context.l10n.housePhoto, style: AppTextStyles.subtitle(context)),
                    const SizedBox(height: 8),
                    AppPreviewImage(
                      imageUrl: customer.housePhoto,
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(12),
                      viewerTitle: context.l10n.housePhoto,
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          CustomerSectionCard(
            title: context.l10n.familyMembers,
            child: customer.familyMembers.isEmpty
                ? Text(context.l10n.noFamilyMembers, style: AppTextStyles.subtitle(context))
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
            title: context.l10n.maternalHouse,
            child: customer.maternalHouse == null ||
                    customer.maternalHouse!.isEmpty
                ? Text(
                    context.l10n.noMaternalHouseDetails,
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
            title: context.l10n.otherLoans,
            child: customer.otherLoans.isEmpty
                ? Text(context.l10n.noOtherLoans, style: AppTextStyles.subtitle(context))
                : Column(
                    children: [
                      for (final loan in customer.otherLoans)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loan.lenderName ?? context.l10n.loan,
                                style: AppTextStyles.label(context),
                              ),
                              if (loan.loanAmount != null)
                                Text(
                                  context.l10n.amountWithValue(
                                    _formatMoney(loan.loanAmount),
                                  ),
                                  style: AppTextStyles.body(context),
                                ),
                              if (loan.outstandingAmount != null)
                                Text(
                                  context.l10n.outstandingWithValue(
                                    _formatMoney(loan.outstandingAmount),
                                  ),
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
            title: context.l10n.guarantors,
            child: customer.guarantors.isEmpty
                ? Text(context.l10n.noGuarantors, style: AppTextStyles.subtitle(context))
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
            title: context.l10n.documents,
            child: customer.documents.isEmpty
                ? Text(context.l10n.noDocuments, style: AppTextStyles.subtitle(context))
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
            child: Text(context.l10n.markApplied),
          ),
        ),
      );
    }

    if (canEdit && customer.status == CustomerStatus.applied) {
      children.add(
        Expanded(
          child: OutlinedButton(
            onPressed: isUpdating ? null : onMarkUnderReview,
            child: Text(context.l10n.sendForReview),
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
            child: Text(context.l10n.reject),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PermissionButton(
            permission: AppPermission.customerApprove,
            service: permissions,
            label: isUpdating ? context.l10n.saving : context.l10n.approve,
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
