import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/permissions/employee_role.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_message.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  late final Future<LoginResponse?> _sessionFuture;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _sessionFuture = _authService.getSession();
  }

  Future<void> _onLogout() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.logOutQuestion,
          style: AppTextStyles.heading(context).copyWith(fontSize: 22),
        ),
        content: Text(
          l10n.logOutConfirmMessage,
          style: AppTextStyles.body(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel, style: AppTextStyles.link(context)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.logout,
              style: AppTextStyles.link(context).copyWith(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoggingOut = true);

    try {
      await _authService.logout();
      if (!mounted) return;
      context.go(AppRoutes.login);
    } on ApiException catch (error) {
      if (!mounted) return;
      await showAppErrorMessage(context, message: error.message);
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: ThemedAppBar(title: l10n.profile),
      body: FutureBuilder<LoginResponse?>(
        future: _sessionFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: AppLoader(size: kAppPageLoaderSize));
          }

          final session = snapshot.data;
          if (session == null) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.noSessionFound,
                style: AppTextStyles.body(context),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(session: session),
                const SizedBox(height: 20),
                _ProfileSection(
                  title: l10n.account,
                  children: [
                    _ProfileInfoRow(label: l10n.userId, value: '${session.id}'),
                    _ProfileInfoRow(
                      label: l10n.superuser,
                      value: session.isSuperuser ? l10n.yes : l10n.no,
                    ),
                    _ProfileInfoRow(
                      label: l10n.accessToken,
                      value: _maskToken(session.access),
                    ),
                  ],
                ),
                if (session.employee != null) ...[
                  const SizedBox(height: 16),
                  _ProfileSection(
                    title: l10n.employee,
                    children: [
                      _ProfileInfoRow(
                        label: l10n.employeeId,
                        value: '${session.employee!.employeeId}',
                      ),
                      _ProfileInfoRow(
                        label: l10n.employeeCode,
                        value: session.employee!.employeeCode,
                      ),
                      _ProfileInfoRow(
                        label: l10n.role,
                        value:
                            '${session.employee!.role} (${EmployeeRole.displayNameFor(session.employee!.role)})',
                      ),
                      _ProfileInfoRow(
                        label: l10n.branchLabel,
                        value: session.employee!.branch,
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  _ProfileSection(
                    title: l10n.employee,
                    children: [
                      _ProfileInfoRow(
                        label: l10n.linkedEmployee,
                        value: l10n.noneSuperuserAccount,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                _ProfileSection(
                  title: l10n.permissionsCount(session.permissions.length),
                  children: [
                    if (session.permissions.isEmpty)
                      Text(
                        l10n.noGranularPermissions,
                        style: AppTextStyles.subtitle(context),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: session.permissions
                            .map((permission) => _PermissionChip(permission))
                            .toList(),
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                _LogoutButton(
                  isLoading: _isLoggingOut,
                  onPressed: _isLoggingOut ? null : _onLogout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _maskToken(String token) {
    if (token.length <= 16) return '••••••••';
    return '${token.substring(0, 8)}…${token.substring(token.length - 8)}';
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.session});

  final LoginResponse session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final employee = session.employee;
    final title = employee?.employeeCode ??
        (session.isSuperuser
            ? l10n.administrator
            : l10n.userNumber(session.id));
    final subtitle = employee != null
        ? '${EmployeeRole.displayNameFor(employee.role)} · ${employee.branch}'
        : session.isSuperuser
            ? l10n.superuser
            : l10n.signedIn;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: context.appColors.gold.withValues(alpha: 0.25),
            child: Icon(Icons.person, color: context.appColors.shinyGold, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label(context).copyWith(fontSize: 18)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.subtitle(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.label(context)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTextStyles.subtitle(context)),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body(context))),
        ],
      ),
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
        border: Border.all(color: context.appColors.gold.withValues(alpha: 0.35)),
      ),
      child: Text(permission, style: AppTextStyles.subtitle(context).copyWith(fontSize: 14)),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.gold,
          foregroundColor: AppColors.navy,
          disabledBackgroundColor: colors.gold.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: isLoading
            ? const AppLoader(size: AppLoaderSize.small)
            : const Icon(Icons.logout),
        label: Text(
          l10n.logout,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }
}
