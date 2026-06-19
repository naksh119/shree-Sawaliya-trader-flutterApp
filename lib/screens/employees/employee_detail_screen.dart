import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/employees/employee_service.dart';
import 'package:sawaliyatrader/core/employees/models/employee_detail.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/entity_edit_delete_actions.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_section_card.dart';
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

    if (_employee == null) {
      await awaitWithMinPageLoaderDuration(fetchEmployee());
    } else {
      await fetchEmployee();
    }
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    return _dateFormat.format(value);
  }

  String _formatEnum(String? value) {
    if (value == null || value.isEmpty) return '';
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
    if (_error != null || employee == null) {
      return Scaffold(
        appBar: ThemedAppBar(title: 'Employee'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _error ?? 'Employee not found.',
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
                title: 'Account',
                child: Column(
                  children: [
                    CustomerInfoRow(label: 'User ID', value: '${employee.id}'),
                    if (employee.employeeId != null)
                      CustomerInfoRow(
                        label: 'Profile ID',
                        value: '${employee.employeeId}',
                      ),
                    CustomerInfoRow(
                      label: 'Email',
                      value: employee.email ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Status',
                      value: employee.isActive ? 'Active' : 'Inactive',
                    ),
                    CustomerInfoRow(
                      label: 'Deleted',
                      value: employee.isDeleted ? 'Yes' : 'No',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: 'Personal',
                child: Column(
                  children: [
                    CustomerInfoRow(label: 'Name', value: employee.displayName),
                    CustomerInfoRow(
                      label: 'Employee code',
                      value: employee.displayCode,
                    ),
                    CustomerInfoRow(
                      label: 'Father name',
                      value: employee.fatherName ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Date of birth',
                      value: _formatDate(employee.dateOfBirth),
                    ),
                    CustomerInfoRow(
                      label: 'Place of birth',
                      value: employee.placeOfBirth ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Gender',
                      value: _formatEnum(employee.gender),
                    ),
                    CustomerInfoRow(
                      label: 'Marital status',
                      value: _formatEnum(employee.maritalStatus),
                    ),
                    CustomerInfoRow(
                      label: 'Nationality',
                      value: employee.nationality ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Languages known',
                      value: employee.languagesKnown ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Members in family',
                      value: _formatInt(employee.membersInFamily),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: 'Identity',
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: 'Aadhaar',
                      value: employee.aadhaarCardNo ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'PAN',
                      value: employee.panCardNo ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: 'Contact',
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: 'Primary mobile',
                      value: employee.mobile ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Secondary mobile',
                      value: employee.secondaryMobile ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Emergency contact',
                      value: employee.emergencyContactName ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Emergency relation',
                      value: employee.emergencyContactRelation ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Emergency number',
                      value: employee.emergencyContactNumber ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: 'Address',
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: 'Present address',
                      value: employee.addressLine1 ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Permanent address',
                      value: employee.permanentAddress ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: 'Physical',
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: 'Height (cm)',
                      value: employee.heightCm ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Weight (kg)',
                      value: employee.weightKg ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Blood group',
                      value: employee.bloodGroup ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: 'Employment',
                child: Column(
                  children: [
                    CustomerInfoRow(
                      label: 'Role',
                      value:
                          employee.roleName ??
                          EmployeeRole.displayNameFor(employee.role),
                    ),
                    CustomerInfoRow(label: 'Role code', value: employee.role),
                    if (employee.roleId != null)
                      CustomerInfoRow(
                        label: 'Role ID',
                        value: '${employee.roleId}',
                      ),
                    CustomerInfoRow(
                      label: 'Role description',
                      value: employee.roleDescription ?? '',
                    ),
                    CustomerInfoRow(label: 'Branch', value: employee.branch),
                    CustomerInfoRow(
                      label: 'Branch code',
                      value: employee.branchCode ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Branch city',
                      value: employee.branchCity ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Branch location',
                      value: employee.branchLocation ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Date of appointment',
                      value: _formatDate(employee.dateOfAppointment),
                    ),
                    CustomerInfoRow(
                      label: 'Date of joining',
                      value: _formatDate(employee.dateOfJoining),
                    ),
                    CustomerInfoRow(
                      label: 'Date of confirmation',
                      value: _formatDate(employee.dateOfConfirmation),
                    ),
                    CustomerInfoRow(
                      label: 'Payable from',
                      value: _formatDate(employee.payableFromDate),
                    ),
                    CustomerInfoRow(
                      label: 'Performance appraisal',
                      value: employee.performanceAppraisal ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Educational qualifications',
                      value: employee.educationalQualifications ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Professional qualifications',
                      value: employee.professionalQualifications ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Warning notes',
                      value: employee.warningNotes ?? '',
                    ),
                    CustomerInfoRow(
                      label: 'Remarks',
                      value: employee.remarks ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomerSectionCard(
                title: 'Permissions',
                child: _PermissionList(
                  userPermissions: employee.permissions,
                  rolePermissions: employee.rolePermissions,
                ),
              ),
              if (employee.createdAt != null) ...[
                const SizedBox(height: 12),
                CustomerSectionCard(
                  title: 'Record',
                  child: Column(
                    children: [
                      CustomerInfoRow(
                        label: 'Created',
                        value: _formatDate(employee.createdAt),
                      ),
                      CustomerInfoRow(
                        label: 'Updated',
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
    if (userPermissions.isEmpty && rolePermissions.isEmpty) {
      return Text(
        'No permissions assigned.',
        style: AppTextStyles.subtitle(context),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (userPermissions.isNotEmpty) ...[
          Text('User permissions', style: AppTextStyles.subtitle(context)),
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
          Text('Role permissions', style: AppTextStyles.subtitle(context)),
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
    final statusColor = employee.isActive
        ? const Color(0xFF4CAF50)
        : context.appColors.textPrimary;

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              employee.isActive ? 'Active' : 'Inactive',
              style: AppTextStyles.subtitle(
                context,
              ).copyWith(color: statusColor, fontWeight: FontWeight.w600),
            ),
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
      child: Text(
        employee.initials,
        style: AppTextStyles.heading(
          context,
        ).copyWith(color: context.appColors.shinyGold, fontSize: 22),
      ),
    );
  }
}
