import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/session_bootstrap.dart';
import 'package:sawaliyatrader/core/auth/user_display.dart';
import 'package:sawaliyatrader/core/employees/employee_service.dart';
import 'package:sawaliyatrader/core/employees/models/branch_option.dart';
import 'package:sawaliyatrader/core/employees/models/employee_dto.dart';
import 'package:sawaliyatrader/core/employees/models/role_option.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_filter_chip.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/app_search_field.dart';
import 'package:sawaliyatrader/core/widgets/create_fab_button.dart';
import 'package:sawaliyatrader/core/widgets/user_header_badge.dart';
import 'package:sawaliyatrader/screens/employees/employee_delete_helper.dart';
import 'package:sawaliyatrader/screens/employees/widgets/employee_list_tile.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

const _kAllBranchesFilterId = 0;

class EmployeesListScreen extends StatefulWidget {
  const EmployeesListScreen({super.key});

  @override
  State<EmployeesListScreen> createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen>
    with ListSessionBootstrapMixin {
  final _employeeService = EmployeeService();
  final _scrollController = ScrollController();

  LoginResponse? get _session => session;

  final List<EmployeeDto> _items = [];
  List<RoleOption> _roles = [];
  List<BranchOption> _branches = [];
  int? _roleFilter;
  int _branchFilterId = _kAllBranchesFilterId;
  String _searchQuery = '';
  int _page = 1;
  int _total = 0;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bootstrapListSession(
      (_) async {
        await _loadFilterOptions();
        await _loadEmployees(reset: true);
      },
      onMissing: () => setState(() => _isLoading = false),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_usesClientSideFiltering) return;
    if (!_scrollController.hasClients || _isLoadingMore || _isLoading) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }
    if (_items.length >= _total) return;
    _loadEmployees();
  }

  bool _canFilterByBranch(LoginResponse session) {
    final permissions = PermissionService(session);
    return permissions.isSuperuser ||
        permissions.hasRole(EmployeeRole.admin) ||
        permissions.hasRole(EmployeeRole.hrm);
  }

  Future<void> _loadFilterOptions() async {
    final session = _session;
    if (session == null) return;

    final canFilterByBranch = _canFilterByBranch(session);

    try {
      final results = await Future.wait([
        _employeeService.fetchRoles(session: session),
        if (canFilterByBranch)
          _employeeService.fetchBranches(session: session)
        else
          Future<List<BranchOption>>.value(const []),
      ]);

      if (!mounted) return;

      final roles = (results[0] as List<RoleOption>)
          .where((role) => role.isActive && role.code.isNotEmpty)
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      var branches = <BranchOption>[];
      if (canFilterByBranch) {
        branches = (results[1] as List<BranchOption>)
            .where((branch) => branch.id != null)
            .toList();
        branches.sort((a, b) => a.name.compareTo(b.name));
      }

      setState(() {
        _roles = roles;
        _branches = branches;
        if (_roleFilter == null && _roles.isNotEmpty) {
          _roleFilter = _roles.first.id;
        }
      });
    } catch (error) {
      debugPrint('[Employees] load filter options failed: $error');
    }
  }

  Future<void> _loadEmployees({bool reset = false}) async {
    final session = _session;
    if (session == null) {
      debugPrint('[Employees] _loadEmployees skipped: session is null');
      return;
    }

    final branchFilter = _branchFilterFor(session);
    debugPrint(
      '[Employees] _loadEmployees reset=$reset page=${reset ? 1 : _page} '
      'search=$_searchQuery role=$_roleFilter '
      'branchFilter=$branchFilter isLoading=$_isLoading',
    );

    if (reset) {
      setState(() {
        _isLoading = true;
        _error = null;
        _page = 1;
      });
    } else {
      setState(() => _isLoadingMore = true);
    }

    try {
      final selectedRole = _selectedRole;
      final fetchEmployees = _employeeService.fetchEmployees(
        session: session,
        page: reset ? 1 : _page,
        pageSize: _usesClientSideFiltering ? 200 : 20,
        search: _searchQuery.isEmpty ? null : _searchQuery,
        role: _roleFilter,
        roleCode: selectedRole?.code,
        branch: _branchFilterFor(session),
      );
      final response = await fetchEmployees;

      if (!mounted) return;
      final filteredItems = _filterEmployees(response.items);
      setState(() {
        if (reset) {
          _items
            ..clear()
            ..addAll(filteredItems);
        } else {
          _items.addAll(filteredItems);
        }
        _total = _usesClientSideFiltering
            ? filteredItems.length
            : response.total;
        _page = response.page + 1;
        _error = null;
      });
      debugPrint(
        '[Employees] UI updated items=${_items.length} total=$_total '
        'isLoading=$_isLoading error=$_error',
      );
    } catch (error, stack) {
      if (!mounted) return;
      debugPrint('[Employees] load failed: $error');
      debugPrint('[Employees] stack: $stack');
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
        debugPrint(
          '[Employees] load finished isLoading=$_isLoading '
          'items=${_items.length} error=$_error',
        );
      }
    }
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query);
    _loadEmployees(reset: true);
  }

  Future<void> _deleteEmployee(EmployeeDto employee) async {
    final session = _session;
    if (session == null || !mounted) return;

    final deleted = await confirmAndDeleteEmployee(
      context: context,
      employeeService: _employeeService,
      session: session,
      employee: employee,
    );

    if (!deleted || !mounted) return;

    setState(() {
      _items.removeWhere((item) => item.id == employee.id);
      if (_total > 0) _total -= 1;
    });
  }

  String? _branchFilterFor(LoginResponse session) {
    if (_canFilterByBranch(session)) {
      if (_branchFilterId == _kAllBranchesFilterId) return null;
      return _branchFilterId.toString();
    }
    return session.employee?.branch;
  }

  void _onRoleSelected(int roleId) {
    setState(() => _roleFilter = roleId);
    _loadEmployees(reset: true);
  }

  RoleOption? get _selectedRole {
    if (_roleFilter == null) return null;
    for (final role in _roles) {
      if (role.id == _roleFilter) return role;
    }
    return null;
  }

  BranchOption? get _selectedBranch {
    if (_branchFilterId == _kAllBranchesFilterId) return null;
    for (final branch in _branches) {
      if (branch.id == _branchFilterId) return branch;
    }
    return null;
  }

  bool get _usesClientSideFiltering =>
      _selectedRole != null || _selectedBranch != null;

  List<EmployeeDto> _filterEmployees(List<EmployeeDto> items) {
    return _filterBySelectedBranch(_filterBySelectedRole(items));
  }

  List<EmployeeDto> _filterBySelectedRole(List<EmployeeDto> items) {
    final selected = _selectedRole;
    if (selected == null) return items;

    return items
        .where(
          (employee) => employee.matchesRole(
            roleId: selected.id,
            roleCode: selected.code,
            roleName: selected.name,
          ),
        )
        .toList();
  }

  List<EmployeeDto> _filterBySelectedBranch(List<EmployeeDto> items) {
    final selected = _selectedBranch;
    if (selected == null) return items;

    return items
        .where(
          (employee) => employee.matchesBranch(
            branchName: selected.name,
            branchCode: selected.code,
          ),
        )
        .toList();
  }

  void _onBranchSelected(int? branchId) {
    if (branchId == null) return;
    setState(() => _branchFilterId = branchId);
    _loadEmployees(reset: true);
  }

  List<DropdownMenuItem<int>> _branchFilterItems(BuildContext context) {
    final textStyle = AppTextStyles.body(context);

    Widget label(String text) => Text(
          text,
          style: textStyle,
          softWrap: false,
          maxLines: 1,
        );

    return [
      DropdownMenuItem(
        value: _kAllBranchesFilterId,
        child: label(context.l10n.allBranches),
      ),
      for (final branch in _branches)
        if (branch.id != null)
          DropdownMenuItem(
            value: branch.id!,
            child: label(branch.label),
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null && _isLoading) {
      return const Scaffold(
        body: Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    if (session == null) {
      return Scaffold(
        body: Center(child: Text(context.l10n.sessionUnavailable)),
      );
    }

    final permissions = PermissionService(session);
    final userDisplay = UserDisplay.fromSession(session);

    return SessionScope(
      session: session,
      child: Scaffold(
        appBar: ThemedAppBar(
          title: context.l10n.employees,
          actions: [
            UserHeaderBadge(
              initials: userDisplay.initials,
              onTap: () => context.push(AppRoutes.profile),
            ),
          ],
        ),
        floatingActionButton: permissions.canCreateEmployee
            ? CreateFabButton(
                onTap: () async {
                  final created = await context.push<bool>(
                    AppRoutes.employeeNew,
                    extra: session,
                  );
                  if (created == true) _loadEmployees(reset: true);
                },
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppSearchField(
                      hintText: context.l10n.searchEmployeesHint,
                      onSearch: _onSearch,
                    ),
                  ),
                  if (_canFilterByBranch(session)) ...[
                    const SizedBox(width: 8),
                    AppFilterIconButton<int>(
                      value: _branchFilterId,
                      items: _branchFilterItems(context),
                      onSelected: _onBranchSelected,
                      icon: Icons.store_outlined,
                      tooltip: context.l10n.branchLabel,
                      menuItemStyle: AppTextStyles.body(context),
                      menuItemHeight: 44,
                      menuItemPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      menuMaxWidth: MediaQuery.sizeOf(context).width - 32,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (var i = 0; i < _roles.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    AppFilterChip(
                      label: _roles[i].code,
                      tooltip: _roles[i].name,
                      selected: _roleFilter == _roles[i].id,
                      onTap: () => _onRoleSelected(_roles[i].id),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody(permissions)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(PermissionService permissions) {
    debugPrint(
      '[Employees] _buildBody isLoading=$_isLoading items=${_items.length} '
      'error=$_error canCreate=${permissions.canCreateEmployee}',
    );

    if (_isLoading && _items.isEmpty) {
      debugPrint('[Employees] showing list loader');
      return const Center(child: AppLoader(size: kAppPageLoaderSize));
    }

    if (_error != null && _items.isEmpty) {
      debugPrint('[Employees] showing error UI: $_error');
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
                onPressed: () => _loadEmployees(reset: true),
                style: FilledButton.styleFrom(
                  backgroundColor: context.appColors.gold,
                ),
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      debugPrint('[Employees] showing empty state: ${_emptyMessage(context)}');
      return RefreshIndicator(
        onRefresh: () => _loadEmployees(reset: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 80),
            Center(
              child: Text(
                _emptyMessage(context),
                style: AppTextStyles.body(context),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadEmployees(reset: true),
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          permissions.canCreateEmployee ? 88 : 24,
        ),
        itemCount: _items.length + (_isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index >= _items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: AppLoader(size: AppLoaderSize.small)),
            );
          }

          final employee = _items[index];
          return EmployeeListTile(
            employee: employee,
            canEdit: permissions.canEditEmployee,
            canDelete: permissions.canDeleteEmployee,
            onTap: () => context.push(AppRoutes.employeeDetail(employee.id)),
            onEdit: permissions.canEditEmployee
                ? () => context.push(AppRoutes.employeePatch(employee.id))
                : null,
            onDelete: permissions.canDeleteEmployee
                ? () => _deleteEmployee(employee)
                : null,
          );
        },
      ),
    );
  }

  String _emptyMessage(BuildContext context) {
    final l10n = context.l10n;
    final role = _selectedRole;
    final rolePart = role != null ? ' ${role.name}' : '';
    final branch = _selectedBranch;
    final branchPart = branch != null ? ' ${branch.name}' : '';
    return l10n.noEmployeesFound('', rolePart, branchPart);
  }
}