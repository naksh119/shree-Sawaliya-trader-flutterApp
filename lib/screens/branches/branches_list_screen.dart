import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/session_bootstrap.dart';
import 'package:sawaliyatrader/core/auth/user_display.dart';
import 'package:sawaliyatrader/core/branches/branch_service.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/active_status_filter.dart';
import 'package:sawaliyatrader/core/widgets/app_search_field.dart';
import 'package:sawaliyatrader/core/widgets/create_fab_button.dart';
import 'package:sawaliyatrader/core/widgets/entity_edit_delete_actions.dart';
import 'package:sawaliyatrader/core/widgets/user_header_badge.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_status_chip.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/screens/branches/branch_delete_helper.dart';

class BranchesListScreen extends StatefulWidget {
  const BranchesListScreen({super.key});

  @override
  State<BranchesListScreen> createState() => _BranchesListScreenState();
}

class _BranchesListScreenState extends State<BranchesListScreen>
    with ListSessionBootstrapMixin {
  final _branchService = BranchService();
  final _scrollController = ScrollController();

  LoginResponse? get _session => session;

  final List<BranchDto> _items = [];
  ActiveStatusFilter _statusFilter = ActiveStatusFilter.all;
  String _searchQuery = '';
  int _page = 1;
  int _total = 0;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bootstrapListSession(
      (_) => _loadBranches(reset: true),
      onMissing: () => setState(() => _isLoading = false),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        isActive: _statusFilter.isActiveParam,
      );
      final response = await fetchBranches;

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

  void _onSearch(String query) {
    setState(() => _searchQuery = query);
    _loadBranches(reset: true);
  }

  void _onStatusSelected(ActiveStatusFilter? status) {
    if (status == null || status == _statusFilter) return;
    setState(() => _statusFilter = status);
    _loadBranches(reset: true);
  }

  Future<void> _deleteBranch(BranchDto branch) async {
    final session = _session;
    if (session == null || !mounted) return;

    final deleted = await confirmAndDeleteBranch(
      context: context,
      branchService: _branchService,
      session: session,
      branch: branch,
    );

    if (!deleted || !mounted) return;

    setState(() {
      _items.removeWhere((item) => item.id == branch.id);
      if (_total > 0) _total -= 1;
    });
  }

  Future<void> _editBranch(BranchDto branch) async {
    final updated = await context.push<bool>(
      AppRoutes.branchPatch(branch.id),
      extra: branch,
    );

    if (updated == true && mounted) {
      _loadBranches(reset: true);
    }
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
        appBar: ThemedAppBar(title: context.l10n.branches,
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
                  final created = await context.push<bool>(
                    AppRoutes.branchNew,
                    extra: session,
                  );
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
              child: Row(
                children: [
                  Expanded(
                    child: AppSearchField(
                      hintText: context.l10n.searchBranchesHint,
                      onSearch: _onSearch,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ActiveStatusFilterButton(
                    value: _statusFilter,
                    onSelected: _onStatusSelected,
                  ),
                ],
              ),
            ),
            if (!_isLoading && _error == null && _items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  context.l10n.branchesCount(_total),
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
                child: Text(context.l10n.retry),
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
            canEdit: permissions.canEditBranch,
            canDelete: permissions.canDeleteBranch,
            onTap: () async {
              final deleted = await context.push<bool>(
                AppRoutes.branchDetail(_items[index].id),
                extra: _items[index],
              );
              if (deleted == true && mounted) {
                _loadBranches(reset: true);
              }
            },
            onEdit: () => _editBranch(_items[index]),
            onDelete: () => _deleteBranch(_items[index]),
          );
        },
      ),
    );
  }

  String _emptyMessage(BuildContext context) {
    final status = _statusFilter.localizedSuffix(context);
    if (_searchQuery.isNotEmpty) {
      return context.l10n.noBranchesFoundForSearch(status, _searchQuery);
    }
    return context.l10n.noBranchesFound(status);
  }
}

extension _ActiveStatusFilterL10n on ActiveStatusFilter {
  String localizedSuffix(BuildContext context) => switch (this) {
        ActiveStatusFilter.all => '',
        ActiveStatusFilter.active => context.l10n.statusSuffixActive,
        ActiveStatusFilter.inactive => context.l10n.statusSuffixInactive,
      };
}

class _BranchListTile extends StatelessWidget {
  const _BranchListTile({
    required this.branch,
    required this.onTap,
    this.canEdit = false,
    this.canDelete = false,
    this.onEdit,
    this.onDelete,
  });

  final BranchDto branch;
  final VoidCallback onTap;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final location = branch.location?.trim() ?? '';

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
                child: BrandGradientText(
                  text: branch.initials,
                  style: AppTextStyles.label(context),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(branch.name, style: AppTextStyles.label(context)),
                    const SizedBox(height: 6),
                    _BranchMetaRow(
                      icon: Icons.tag_outlined,
                      text: branch.displayCode,
                      style: AppTextStyles.subtitle(context),
                    ),
                    if (branch.city.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _BranchMetaRow(
                        icon: Icons.location_city_outlined,
                        text: branch.city,
                        style: AppTextStyles.body(context).copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _BranchMetaRow(
                        icon: Icons.place_outlined,
                        text: location,
                        style: AppTextStyles.body(context).copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppStatusChip(
                    label: branch.isActive
                        ? context.l10n.active
                        : context.l10n.inactive,
                    compact: true,
                  ),
                  EntityEditDeleteTrailingActions(
                    entityName: branch.name,
                    canEdit: canEdit,
                    canDelete: canDelete,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchMetaRow extends StatelessWidget {
  const _BranchMetaRow({
    required this.icon,
    required this.text,
    required this.style,
  });

  final IconData icon;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrandGradientIcon(
          icon,
          size: 16,
          opacity: 0.75,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: style),
        ),
      ],
    );
  }
}

