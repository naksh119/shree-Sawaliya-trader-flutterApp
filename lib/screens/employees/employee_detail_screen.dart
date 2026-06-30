import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/employees/employee_service.dart';
import 'package:sawaliyatrader/core/employees/models/employee_detail.dart';
import 'package:sawaliyatrader/core/locale/l10n_extensions.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_image_viewer.dart';
import 'package:sawaliyatrader/core/widgets/entity_edit_delete_actions.dart';
import 'package:sawaliyatrader/screens/employees/employee_delete_helper.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_section_card.dart';
import 'package:sawaliyatrader/core/widgets/app_status_chip.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class EmployeeDetailScreen extends StatefulWidget {
  const EmployeeDetailScreen({required this.employeeId, super.key});

  final int employeeId;

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final _authService = AuthService();
  final _employeeService = EmployeeService();
  final _dateFormat = DateFormat('dd MMM yyyy');

  LoginResponse? _session;
  EmployeeDetail? _employee;
  bool _isLoading = true;
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

    Future<void> fetchEmployee() async {
      try {
        final employee = await _employeeService.fetchEmployee(
          session: session,
          employeeId: widget.employeeId,
        );
        if (!mounted) return;
        setState(() {
          _employee = employee;
          _error = null;
        });
      } catch (error) {
        if (!mounted) return;
        setState(() => _error = error.toString());
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    await fetchEmployee();
  }

  Future<void> _patchEditEmployee(EmployeeDetail employee) async {
    final updated = await context.push<bool>(
      AppRoutes.employeePatch(widget.employeeId),
      extra: employee,
    );

    if (updated == true && mounted) {
      await _load();
    }
  }

  Future<void> _deleteEmployee(EmployeeDetail employee) async {
    final session = _session;
    if (session == null || !mounted) return;

    final deleted = await confirmAndDeleteEmployee(
      context: context,
      employeeService: _employeeService,
      session: session,
      employee: employee,
      employeeId: widget.employeeId,
    );

    if (deleted && mounted) {
      context.pop(true);
    }
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    return _dateFormat.format(value);
  }

  String _formatEnum(String? value) {
    if (value == null || value.isEmpty) return '';
    final l10n = context.l10n;
    final gender = localizedGenderLabel(l10n, value);
    if (gender != value) return gender;
    final marital = localizedMaritalStatusLabel(l10n, value);
    if (marital != value) return marital;
    return value
        .toLowerCase()
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }

  String _formatInt(int? value) {
    if (value == null) return '';
    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null || _isLoading) {
      return const Scaffold(
        body: Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    final employee = _employee;
    final l10n = context.l10n;
    if (_error != null || employee == null) {
      return Scaffold(
        appBar: ThemedAppBar(title: l10n.employee),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _error ?? l10n.employeeNotFound,
                  style: AppTextStyles.body(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _load,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.appColors.gold,
                  ),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final permissions = PermissionService(session);

    return SessionScope(
      session: session,
      child: Scaffold(
        appBar: ThemedAppBar(
          title: employee.displayName,
        ),
        body: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _EmployeeHeader(employee: employee),
              const SizedBox(height: 16),
              CustomerSectionCard(
                title: l10n.account,
                child: Column(
                  children: [
                    CustomerInfoRow(label: l10n.userId, value: '${employee.id}'),
                    if (employee.employeeId != null)
                      CustomerInfoRow(
                        label: l10n.profileId,
                        value: '${employee.employeeId}',
                      ),
                    CustomerInfoRow(
                      label: l10n.email,
                      value: employee.email ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.status,
                      value: employee.isActive ? l10n.active : l10n.inactive,
                    ),
                    CustomerInfoRow(
                      label: l10n.deleted,
                      value: employee.isDeleted ? l10n.yes : l10n.no,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: l10n.personal,
                child: Column(
                  children: [
                    CustomerInfoRow(label: l10n.name, value: employee.displayName),
                    CustomerInfoRow(
                      label: l10n.employeeCode,
                      value: employee.displayCode,
                    ),
                    CustomerInfoRow(
                      label: l10n.fatherName,
                      value: employee.fatherName ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.dateOfBirth,
                      value: _formatDate(employee.dateOfBirth),
                    ),
                    CustomerInfoRow(
                      label: l10n.placeOfBirth,
                      value: employee.placeOfBirth ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.gender,
                      value: _formatEnum(employee.gender),
                    ),
                    CustomerInfoRow(
                      label: l10n.maritalStatus,
                      value: _formatEnum(employee.maritalStatus),
                    ),
                    CustomerInfoRow(
                      label: l10n.nationality,
                      value: employee.nationality ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.languagesKnown,
                      value: employee.languagesKnown ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.membersInFamily,
                      value: _formatInt(employee.membersInFamily),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: l10n.identity,
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: l10n.aadhaar,
                      value: employee.aadhaarCardNo ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.pan,
                      value: employee.panCardNo ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: l10n.contact,
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: l10n.primaryMobile,
                      value: employee.mobile ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.secondaryMobile,
                      value: employee.secondaryMobile ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.emergencyContact,
                      value: employee.emergencyContactName ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.relation,
                      value: employee.emergencyContactRelation ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.contactNumber,
                      value: employee.emergencyContactNumber ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: l10n.address,
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: l10n.presentAddress,
                      value: employee.addressLine1 ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.permanentAddress,
                      value: employee.permanentAddress ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: l10n.physical,
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: l10n.heightCm,
                      value: employee.heightCm ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.weightKg,
                      value: employee.weightKg ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.bloodGroup,
                      value: employee.bloodGroup ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: l10n.employmentDetails,
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: l10n.role,
                      value:
                          employee.roleName ??
                          EmployeeRole.displayNameFor(employee.role),
                    ),
                    CustomerInfoRow(label: l10n.roleCode, value: employee.role),
                    if (employee.roleId != null)
                      CustomerInfoRow(
                        label: l10n.roleId,
                        value: '${employee.roleId}',
                      ),
                    CustomerInfoRow(
                      label: l10n.roleDescription,
                      value: employee.roleDescription ?? '',
                    ),
                    CustomerInfoRow(label: l10n.branchLabel, value: employee.branch),
                    CustomerInfoRow(
                      label: l10n.branchCode,
                      value: employee.branchCode ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.branchCity,
                      value: employee.branchCity ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.branchLocation,
                      value: employee.branchLocation ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.dateOfAppointment,
                      value: _formatDate(employee.dateOfAppointment),
                    ),
                    CustomerInfoRow(
                      label: l10n.dateOfJoining,
                      value: _formatDate(employee.dateOfJoining),
                    ),
                    CustomerInfoRow(
                      label: l10n.dateOfConfirmation,
                      value: _formatDate(employee.dateOfConfirmation),
                    ),
                    CustomerInfoRow(
                      label: l10n.payableFromDate,
                      value: _formatDate(employee.payableFromDate),
                    ),
                    CustomerInfoRow(
                      label: l10n.performanceAppraisal,
                      value: employee.performanceAppraisal ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.educationalQualifications,
                      value: employee.educationalQualifications ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.professionalQualifications,
                      value: employee.professionalQualifications ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.warningNotes,
                      value: employee.warningNotes ?? '',
                    ),
                    CustomerInfoRow(
                      label: l10n.remarks,
                      value: employee.remarks ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: l10n.permissionsSection,
                child: _PermissionList(
                  userPermissions: employee.permissions,
                  rolePermissions: employee.rolePermissions,
                ),
              ),
              if (employee.createdAt != null) ...[
                const SizedBox(height: 12),
                CustomerSectionCard(
                  title: l10n.record,
                  child: Column(
                    children: [
                      CustomerInfoRow(
                        label: l10n.created,
                        value: _formatDate(employee.createdAt),
                      ),
                      CustomerInfoRow(
                        label: l10n.updated,
                        value: _formatDate(employee.updatedAt),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: EntityEditDeleteBar(
          entityName: employee.displayName,
          canEdit: permissions.canEditEmployee,
          canDelete: permissions.canDeleteEmployee,
          onEdit: () => _patchEditEmployee(employee),
          onDelete: () => _deleteEmployee(employee),
        ),
      ),
    );
  }
}

class _PermissionList extends StatelessWidget {
  const _PermissionList({
    required this.userPermissions,
    required this.rolePermissions,
  });

  final List<String> userPermissions;
  final List<String> rolePermissions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (userPermissions.isEmpty && rolePermissions.isEmpty) {
      return Text(
        l10n.noGranularPermissions,
        style: AppTextStyles.subtitle(context),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (userPermissions.isNotEmpty) ...[
          Text(l10n.userPermissions, style: AppTextStyles.subtitle(context)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: userPermissions
                .map((permission) => _PermissionChip(permission))
                .toList(),
          ),
        ],
        if (rolePermissions.isNotEmpty) ...[
          if (userPermissions.isNotEmpty) const SizedBox(height: 12),
          Text(l10n.rolePermissions, style: AppTextStyles.subtitle(context)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: rolePermissions
                .map((permission) => _PermissionChip(permission))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip(this.permission);

  final String permission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.appColors.gold.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.appColors.gold.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        permission,
        style: AppTextStyles.subtitle(context).copyWith(fontSize: 14),
      ),
    );
  }
}

class _EmployeeHeader extends StatelessWidget {
  const _EmployeeHeader({required this.employee});

  final EmployeeDetail employee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        children: [
          _EmployeeAvatar(employee: employee),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.displayName, style: AppTextStyles.label(context)),
                const SizedBox(height: 4),
                Text(
                  employee.displayCode,
                  style: AppTextStyles.subtitle(context),
                ),
                const SizedBox(height: 4),
                Text(
                  '${employee.roleName ?? employee.roleLabel} · ${employee.branch}',
                  style: AppTextStyles.body(context),
                ),
              ],
            ),
          ),
          AppStatusChip(
            label: employee.isActive
                ? context.l10n.active
                : context.l10n.inactive,
          ),
        ],
      ),
    );
  }
}

class _EmployeeAvatar extends StatelessWidget {
  const _EmployeeAvatar({required this.employee});

  final EmployeeDetail employee;

  @override
  Widget build(BuildContext context) {
    final photo = employee.employeePhoto?.trim();
    if (photo != null &&
        photo.isNotEmpty &&
        appPreviewImageIsNetworkUrl(photo)) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showAppImageViewer(
            context,
            imageUrl: photo,
            title: context.l10n.employeePhoto,
          ),
          customBorder: const CircleBorder(),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: context.appColors.gold.withValues(alpha: 0.18),
            backgroundImage: NetworkImage(photo),
          ),
        ),
      );
    }

    if (photo != null && photo.isNotEmpty) {
      return CircleAvatar(
        radius: 32,
        backgroundColor: context.appColors.gold.withValues(alpha: 0.18),
        backgroundImage: NetworkImage(photo),
      );
    }

    return CircleAvatar(
      radius: 32,
      backgroundColor: context.appColors.gold.withValues(alpha: 0.18),
      child: BrandGradientText(
        text: employee.initials,
        style: AppTextStyles.heading(context).copyWith(fontSize: 22),
      ),
    );
  }
}
