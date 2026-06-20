import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/branches/branch_patch_service.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_message.dart';
import 'package:sawaliyatrader/screens/customers/widgets/customer_section_card.dart';

/// Set to `false` or delete this file (+ [BranchPatchService]) to remove PATCH UI.
const kBranchPatchUiEnabled = true;

/// Optional PATCH partial-update actions on branch detail.
///
/// **API:** `PATCH /branches/api/{id}/`
/// **Request type:** PATCH
/// **Purpose:** Quick partial updates (e.g. toggle active status) without full PUT edit.
class BranchPatchSection extends StatefulWidget {
  const BranchPatchSection({
    required this.branch,
    required this.branchId,
    required this.session,
    required this.detailLoadedFromApi,
    required this.onBranchUpdated,
    this.onBranchNotFound,
    super.key,
  });

  final BranchDto branch;
  final int branchId;
  final LoginResponse session;
  final bool detailLoadedFromApi;
  final ValueChanged<BranchDto> onBranchUpdated;
  final VoidCallback? onBranchNotFound;

  @override
  State<BranchPatchSection> createState() => _BranchPatchSectionState();
}

class _BranchPatchSectionState extends State<BranchPatchSection> {
  final _patchService = BranchPatchService();
  bool _isPatching = false;

  Future<void> _toggleActiveStatus() async {
    if (_isPatching || !widget.detailLoadedFromApi || !mounted) return;

    final nextActive = !widget.branch.isActive;

    setState(() => _isPatching = true);

    try {
      final updated = await _patchService.patchBranch(
        session: widget.session,
        branchId: widget.branchId,
        fields: BranchPatchPayload.activeStatus(nextActive),
      );

      if (!mounted) return;
      widget.onBranchUpdated(updated);

      await showAppSuccessMessage(
        context,
        message: updated.isActive
            ? '${updated.name} marked active.'
            : '${updated.name} marked inactive.',
      );
    } catch (error) {
      if (!mounted) return;

      if (error is ApiException && error.statusCode == 404) {
        widget.onBranchNotFound?.call();
        return;
      }

      final message =
          error is ApiException ? error.message : error.toString();
      await showAppErrorMessage(context, message: message);
    } finally {
      if (mounted) setState(() => _isPatching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kBranchPatchUiEnabled) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        CustomerSectionCard(
          title: 'Quick update (PATCH)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PATCH /branches/api/{id}/ — partial update; only changed fields are sent.',
                style: AppTextStyles.subtitle(context).copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isPatching || !widget.detailLoadedFromApi
                    ? null
                    : _toggleActiveStatus,
                icon: _isPatching
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.appColors.shinyGold,
                        ),
                      )
                    : Icon(
                        widget.branch.isActive
                            ? Icons.pause_circle_outline
                            : Icons.check_circle_outline,
                      ),
                label: Text(
                  widget.branch.isActive
                      ? 'Mark inactive'
                      : 'Mark active',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
