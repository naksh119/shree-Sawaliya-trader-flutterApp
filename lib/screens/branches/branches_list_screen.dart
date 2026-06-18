import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/user_display.dart';
import 'package:sawaliyatrader/core/branches/branch_service.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/create_fab_button.dart';
import 'package:sawaliyatrader/core/widgets/user_header_badge.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

enum _StatusFilter { all, active, inactive }

class BranchesListScreen extends StatefulWidget {
  const BranchesListScreen({super.key});

  @override
  State<BranchesListScreen> createState() => _BranchesListScreenState();
}

class _BranchesListScreenState extends State<BranchesListScreen> {
  final _authService = AuthService();
  final _branchService = BranchService();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  LoginResponse? _session;
  final List<BranchDto> _items = [];
  _StatusFilter _statusFilter = _StatusFilter.all;
  String _searchQuery = '';
  int _page = 1;
  int _total = 0;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _loadGeneration = 0;

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
      _loadBranches(reset: true);
      return;
    }

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
      await _loadBranches(reset: true);
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoadingMore || _isLoading) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }
    if (_items.length >= _total) return;
    _loadBranches();
  }

  bool? get _isActiveParam => switch (_statusFilter) {
        _StatusFilter.all => null,
        _StatusFilter.active => true,
        _StatusFilter.inactive => false,
      };

  Future<void> _loadBranches({bool reset = false}) async {
    final session = _session;
    if (session == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final generation = ++_loadGeneration;

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
      final fetchBranches = _branchService.fetchBranches(
        session: session,
        page: reset ? 1 : _page,
        pageSize: 50,
        search: _searchQuery.isEmpty ? null : _searchQuery,
        isActive: _isActiveParam,
      );
      final response = reset && _items.isEmpty
          ? await awaitWithMinPageLoaderDuration(fetchBranches)
          : await fetchBranches;

      if (!mounted || generation != _loadGeneration) return;

      setState(() {
        if (reset) {
          _items
            ..clear()
            ..addAll(response.items);
        } else {
          _items.addAll(response.items);
        }
        _total = response.total;
        _page = response.page + 1;
        _error = null;
      });
    } catch (error) {
      if (!mounted || generation != _loadGeneration) return;
      setState(() {
        _error = error is ApiException ? error.message : error.toString();
      });
    } finally {
      if (mounted && generation == _loadGeneration) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  void _onSearchSubmitted(String value) {
    _searchQuery = value.trim();
    _loadBranches(reset: true);
  }

  void _clearSearch() {
    _searchController.clear();
    if (_searchQuery.isEmpty) return;
    setState(() => _searchQuery = '');
    _loadBranches(reset: true);
  }

  void _onStatusSelected(_StatusFilter? status) {
    if (status == null || status == _statusFilter) return;
    setState(() => _statusFilter = status);
    _loadBranches(reset: true);
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
      return const Scaffold(
        body: Center(child: Text('Session unavailable. Please sign in again.')),
      );
    }

    final permissions = PermissionService(session);
    final userDisplay = UserDisplay.fromSession(session);

    return SessionScope(
      session: session,
      child: Scaffold(
        appBar: ThemedAppBar(title: 'Branches',
          actions: [
            UserHeaderBadge(
              initials: userDisplay.initials,
              onTap: () => context.push(AppRoutes.profile),
            ),
          ],
        ),
        floatingActionButton: permissions.canManageBranches
            ? CreateFabButton(
                onTap: () async {
                  final created =
                      await context.push<bool>(AppRoutes.branchNew);
                  if (created == true && mounted) {
                    _loadBranches(reset: true);
                  }
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
                  hintText: 'Search by name, code, or city',
                  hintStyle: AppTextStyles.body(context).copyWith(
                    color: context.appColors.textSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.appColors.shinyGold.withValues(alpha: 0.7),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: context.appColors.textSecondary,
                          ),
                          onPressed: _clearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor: context.appColors.inputFill,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.appColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.appColors.border,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _onSearchSubmitted,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: _StatusDropdown(
                value: _statusFilter,
                onChanged: _onStatusSelected,
              ),
            ),
            if (!_isLoading && _error == null && _items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  '$_total branches',
                  style: AppTextStyles.subtitle(context),
                ),
              ),
            Expanded(child: _buildBody(permissions)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(PermissionService permissions) {
    if (_isLoading && _items.isEmpty) {
      return const Center(child: AppLoader(size: kAppPageLoaderSize));
    }

    if (_error != null && _items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, style: AppTextStyles.body(context), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _loadBranches(reset: true),
                style: FilledButton.styleFrom(backgroundColor: context.appColors.gold),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadBranches(reset: true),
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
      onRefresh: () => _loadBranches(reset: true),
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          permissions.canManageBranches ? 88 : 24,
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

          return _BranchListTile(
            branch: _items[index],
            onTap: () => context.push(
              AppRoutes.branchDetail(_items[index].id),
              extra: _items[index],
            ),
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
    if (_searchQuery.isNotEmpty) {
      return 'No$status branches found for "$_searchQuery".';
    }
    return 'No$status branches found.';
  }
}

class _BranchListTile extends StatelessWidget {
  const _BranchListTile({
    required this.branch,
    required this.onTap,
  });

  final BranchDto branch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final location = branch.locationLine;

    return Material(
      color: context.appColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.appColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: context.appColors.gold.withValues(alpha: 0.18),
                child: Text(
                  branch.initials,
                  style: AppTextStyles.label(context).copyWith(color: context.appColors.shinyGold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(branch.name, style: AppTextStyles.label(context)),
                    const SizedBox(height: 4),
                    Text(
                      location.isNotEmpty ? location : 'No location set',
                      style: AppTextStyles.body(context).copyWith(
                        color: location.isNotEmpty
                            ? context.appColors.textSecondary
                            : context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _BranchActiveChip(isActive: branch.isActive),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchActiveChip extends StatelessWidget {
  const _BranchActiveChip({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF4CAF50) : context.appColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: AppTextStyles.subtitle(context).copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({
    required this.value,
    required this.onChanged,
  });

  final _StatusFilter value;
  final ValueChanged<_StatusFilter?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_StatusFilter>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.expand_more_rounded,
            color: context.appColors.shinyGold.withValues(alpha: 0.8),
          ),
          style: AppTextStyles.body(context),
          dropdownColor: context.appColors.card,
          items: const [
            DropdownMenuItem(
              value: _StatusFilter.all,
              child: Text('All branches'),
            ),
            DropdownMenuItem(
              value: _StatusFilter.active,
              child: Text('Active branches'),
            ),
            DropdownMenuItem(
              value: _StatusFilter.inactive,
              child: Text('Inactive branches'),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
