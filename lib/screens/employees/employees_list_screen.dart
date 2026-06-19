import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/user_display.dart';
import 'package:sawaliyatrader/core/employees/employee_service.dart';
import 'package:sawaliyatrader/core/employees/models/branch_option.dart';
import 'package:sawaliyatrader/core/employees/models/employee_dto.dart';
import 'package:sawaliyatrader/core/employees/models/role_option.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';
import 'package:sawaliyatrader/core/widgets/create_fab_button.dart';
import 'package:sawaliyatrader/core/widgets/user_header_badge.dart';
import 'package:sawaliyatrader/screens/employees/widgets/employee_list_tile.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

enum _StatusFilter { all, active, inactive }

const _kAllBranchesFilterId = 0;

class EmployeesListScreen extends StatefulWidget {
  const EmployeesListScreen({super.key});

  @override
  State<EmployeesListScreen> createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen> {
  final _authService = AuthService();
  final _employeeService = EmployeeService();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  LoginResponse? _session;
  final List<EmployeeDto> _items = [];
  List<RoleOption> _roles = [];
  List<BranchOption> _branches = [];
  int? _roleFilter;
  int _branchFilterId = _kAllBranchesFilterId;
  _StatusFilter _statusFilter = _StatusFilter.all;
  String _searchQuery = '';
  int _page = 1;
  int _total = 0;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  bool _sessionInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sessionInitialized) return;

    final inherited = SessionScope.maybeOf(context)?.session;
    if (inherited != null) {
      _sessionInitialized = true;
      _session = inherited;
      debugPrint(
        '[Employees] session from SessionScope userId=${inherited.id} '
        'role=${inherited.employee?.role} branch=${inherited.employee?.branch}',
      );
      _loadFilterOptions().then((_) => _loadEmployees(reset: true));
      return;
    }

    debugPrint('[Employees] no SessionScope yet, bootstrapping auth session');

    _sessionInitialized = true;
    _bootstrap();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await awaitWithMinPageLoaderDuration(_bootstrapWork());
  }

  Future<void> _bootstrapWork() async {
    final session = await _authService.getSession();
    if (!mounted) return;
    setState(() => _session = session);
    if (session != null) {
      await _loadFilterOptions();
      await _loadEmployees(reset: true);
    } else {
      setState(() => _isLoading = false);
    }
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

  bool? get _isActiveParam => switch (_statusFilter) {
    _StatusFilter.all => null,
    _StatusFilter.active => true,
    _StatusFilter.inactive => false,
  };

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
      'search=$_searchQuery role=$_roleFilter status=$_statusFilter '
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
        isActive: _isActiveParam,
        role: _roleFilter,
        roleCode: selectedRole?.code,
        branch: _branchFilterFor(session),
      );
      final response = reset && _items.isEmpty
          ? await awaitWithMinPageLoaderDuration(fetchEmployees)
          : await fetchEmployees;

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

  void _onSearchSubmitted(String value) {
    _searchQuery = value.trim();
    _loadEmployees(reset: true);
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

  void _onStatusSelected(_StatusFilter? status) {
    if (status == null) return;
    setState(() => _statusFilter = status);
    _loadEmployees(reset: true);
  }

  void _onBranchSelected(int? branchId) {
    if (branchId == null) return;
    setState(() => _branchFilterId = branchId);
    _loadEmployees(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session ?? SessionScope.maybeOf(context)?.session;
    if (session == null && _isLoading) {
      return const Scaffold(
        body: Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('Session unavailable. Please sign in again.')),
      );
    }

    final permissions = PermissionService(session);
    final userDisplay = UserDisplay.fromSession(session);

    return SessionScope(
      session: session,
      child: Scaffold(
        appBar: ThemedAppBar(
          title: 'Employees',
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
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.body(context),
                decoration: InputDecoration(
                  hintText: 'Search by name, code, or email',
                  hintStyle: AppTextStyles.body(
                    context,
                  ).copyWith(color: context.appColors.textSecondary),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.appColors.shinyGold.withValues(alpha: 0.7),
                  ),
                  filled: true,
                  fillColor: context.appColors.inputFill,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.appColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.appColors.border),
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _onSearchSubmitted,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: _StatusDropdown(
                      value: _statusFilter,
                      onChanged: _onStatusSelected,
                    ),
                  ),
                  if (_canFilterByBranch(session)) ...[
                    const SizedBox(width: 6),
                    Flexible(
                      flex: 3,
                      child: _BranchDropdown(
                        value: _branchFilterId,
                        branches: _branches,
                        onChanged: _onBranchSelected,
                      ),
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
                    _RoleChip(
                      label: _roles[i].code,
                      tooltip: _roles[i].name,
                      selected: _roleFilter == _roles[i].id,
                      onTap: () => _onRoleSelected(_roles[i].id),
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
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      debugPrint('[Employees] showing empty state: $_emptyMessage');
      return RefreshIndicator(
        onRefresh: () => _loadEmployees(reset: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 80),
            Center(
              child: Text(
                _emptyMessage,
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
          );
        },
      ),
    );
  }

  String get _emptyMessage {
    final status = switch (_statusFilter) {
      _StatusFilter.all => '',
      _StatusFilter.active => ' active',
      _StatusFilter.inactive => ' inactive',
    };
    final role = _selectedRole;
    final rolePart = role != null ? ' ${role.name}' : '';
    final branch = _selectedBranch;
    final branchPart = branch != null ? ' ${branch.name}' : '';
    return 'No$status$rolePart$branchPart employees found.';
  }
}

abstract final class _FilterDropdownMetrics {
  static const padding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);
  static const iconSize = 18.0;
  static const menuExtraWidth = 36.0;

  static TextStyle textStyle(BuildContext context) =>
      AppTextStyles.body(context).copyWith(fontSize: 13);
}

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({required this.value, required this.onChanged});

  final _StatusFilter value;
  final ValueChanged<_StatusFilter?> onChanged;

  @override
  Widget build(BuildContext context) {
    final textStyle = _FilterDropdownMetrics.textStyle(context);

    return Container(
      padding: _FilterDropdownMetrics.padding,
      decoration: AppDropdownDecoration.container(context),
      child: AppInlineDropdown<_StatusFilter>(
        value: value,
        isExpanded: true,
        style: textStyle,
        icon: Icon(
          Icons.expand_more_rounded,
          size: _FilterDropdownMetrics.iconSize,
          color: context.appColors.shinyGold.withValues(alpha: 0.8),
        ),
        items: [
          DropdownMenuItem(
            value: _StatusFilter.all,
            child: Text('All employees', style: textStyle, overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem(
            value: _StatusFilter.active,
            child: Text('Active employees', style: textStyle, overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem(
            value: _StatusFilter.inactive,
            child: Text('Inactive employees', style: textStyle, overflow: TextOverflow.ellipsis),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _BranchDropdown extends StatefulWidget {
  const _BranchDropdown({
    required this.value,
    required this.branches,
    required this.onChanged,
  });

  final int value;
  final List<BranchOption> branches;
  final ValueChanged<int?> onChanged;

  @override
  State<_BranchDropdown> createState() => _BranchDropdownState();
}

class _BranchDropdownState extends State<_BranchDropdown> {
  final _anchorKey = GlobalKey();

  String get _selectedLabel {
    if (widget.value == _kAllBranchesFilterId) return 'All branches';
    for (final branch in widget.branches) {
      if (branch.id == widget.value) return branch.label;
    }
    return 'All branches';
  }

  List<String> get _allLabels => [
        'All branches',
        for (final branch in widget.branches) branch.label,
      ];

  List<DropdownMenuItem<int>> get _items {
    final textStyle = _FilterDropdownMetrics.textStyle(context);

    return [
      DropdownMenuItem(
        value: _kAllBranchesFilterId,
        child: Text('All branches', style: textStyle),
      ),
      for (final branch in widget.branches)
        if (branch.id != null)
          DropdownMenuItem(
            value: branch.id!,
            child: Text(branch.label, style: textStyle),
          ),
    ];
  }

  double _menuWidthFor(BuildContext context, RenderBox button) {
    final style = _FilterDropdownMetrics.textStyle(context);
    final painter = TextPainter(
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    );

    var maxTextWidth = 0.0;
    for (final label in _allLabels) {
      painter.text = TextSpan(text: label, style: style);
      painter.layout();
      maxTextWidth = math.max(maxTextWidth, painter.width);
    }

    final contentWidth = maxTextWidth + _FilterDropdownMetrics.menuExtraWidth;
    return contentWidth.clamp(button.size.width, MediaQuery.sizeOf(context).width * 0.72);
  }

  Future<void> _openMenu() async {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final menuWidth = _menuWidthFor(context, box);
    final selected = await showAppDropdownMenu<int>(
      context: context,
      button: box,
      items: _items,
      menuMinWidth: menuWidth,
      menuMaxWidth: menuWidth,
    );
    if (selected != null && selected != widget.value) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = _FilterDropdownMetrics.textStyle(context);

    return Container(
      padding: _FilterDropdownMetrics.padding,
      decoration: AppDropdownDecoration.container(context),
      child: InkWell(
        key: _anchorKey,
        onTap: _openMenu,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedLabel,
                  style: textStyle,
                  maxLines: 1,
                ),
              ),
            ),
            Icon(
              Icons.expand_more_rounded,
              size: _FilterDropdownMetrics.iconSize,
              color: context.appColors.shinyGold.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.tooltip,
  });

  final String label;
  final String? tooltip;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chip = FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: AppTextStyles.subtitle(context).copyWith(
        color: selected
            ? context.appColors.gold
            : context.appColors.textPrimary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
      selectedColor: context.appColors.gold.withValues(alpha: 0.18),
      backgroundColor: context.appColors.card,
      side: BorderSide(
        color: selected
            ? context.appColors.gold.withValues(alpha: 0.5)
            : context.appColors.border,
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    );

    if (tooltip == null || tooltip!.isEmpty) return chip;

    return Tooltip(message: tooltip!, child: chip);
  }
}
