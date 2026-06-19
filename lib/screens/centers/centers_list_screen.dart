import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/auth/user_display.dart';
import 'package:sawaliyatrader/core/centers/center_service.dart';
import 'package:sawaliyatrader/core/centers/models/center_dto.dart';
import 'package:sawaliyatrader/core/centers/models/center_status.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/permissions/session_scope.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/create_fab_button.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/widgets/user_header_badge.dart';
import 'package:sawaliyatrader/screens/centers/widgets/center_list_tile.dart';

class CentersListScreen extends StatefulWidget {
  const CentersListScreen({super.key});

  @override
  State<CentersListScreen> createState() => _CentersListScreenState();
}

class _CentersListScreenState extends State<CentersListScreen> {
  final _authService = AuthService();
  final _centerService = CenterService();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  LoginResponse? _session;
  final List<CenterDto> _items = [];
  CenterStatus? _statusFilter;
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
    if (session != null) await _loadCenters(reset: true);
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoadingMore || _isLoading) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }
    if (_items.length >= _total) return;
    _loadCenters();
  }

  Future<void> _loadCenters({bool reset = false}) async {
    final session = _session;
    if (session == null) return;

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
      final fetchCenters = _centerService.fetchCenters(
        session: session,
        page: reset ? 1 : _page,
        search: _searchQuery.isEmpty ? null : _searchQuery,
        status: _statusFilter,
        branch: session.employee?.branch,
      );
      final response = reset && _items.isEmpty
          ? await awaitWithMinPageLoaderDuration(fetchCenters)
          : await fetchCenters;

      if (!mounted) return;
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
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _onSearchSubmitted(String value) {
    _searchQuery = value.trim();
    _loadCenters(reset: true);
  }

  void _onStatusSelected(CenterStatus? status) {
    setState(() => _statusFilter = status);
    _loadCenters(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null) {
      return const Scaffold(
        body: Center(child: AppLoader(size: kAppPageLoaderSize)),
      );
    }

    final permissions = PermissionService(session);
    final userDisplay = UserDisplay.fromSession(session);

    return SessionScope(
      session: session,
      child: Scaffold(
        appBar: ThemedAppBar(
          title: 'Centers',
          actions: [
            UserHeaderBadge(
              initials: userDisplay.initials,
              onTap: () => context.push(AppRoutes.profile),
            ),
          ],
        ),
        floatingActionButton: permissions.canCreateCenter
            ? CreateFabButton(
                onTap: () async {
                  final created = await context.push<bool>(AppRoutes.centerNew);
                  if (created == true && mounted) {
                    await _loadCenters(reset: true);
                  }
                },
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.body(context),
                decoration: InputDecoration(
                  hintText: 'Search by name or code',
                  hintStyle: AppTextStyles.body(context).copyWith(
                    color: context.appColors.textSecondary,
                  ),
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
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _statusFilter == null,
                    onTap: () => _onStatusSelected(null),
                  ),
                  for (final status in CenterStatus.filterOptions) ...[
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: status.label,
                      selected: _statusFilter == status,
                      color: status.color,
                      onTap: () => _onStatusSelected(status),
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
              Text(
                _error!,
                style: AppTextStyles.body(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _loadCenters(reset: true),
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
      return RefreshIndicator(
        onRefresh: () => _loadCenters(reset: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 80),
            Center(
              child: Text(
                'No centers found.',
                style: AppTextStyles.body(context),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadCenters(reset: true),
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          permissions.canCreateCenter ? 88 : 24,
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

          final center = _items[index];
          return CenterListTile(
            center: center,
            canEdit: permissions.canEditCenter,
            canDelete: permissions.canDeleteCenter,
            onTap: () => context.push(AppRoutes.centerDetail(center.id)),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? context.appColors.gold;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: AppTextStyles.subtitle(context).copyWith(
        color: selected ? activeColor : context.appColors.textPrimary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
      selectedColor: activeColor.withValues(alpha: 0.18),
      backgroundColor: context.appColors.card,
      side: BorderSide(
        color: selected
            ? activeColor.withValues(alpha: 0.5)
            : context.appColors.border,
      ),
      showCheckmark: false,
    );
  }
}
