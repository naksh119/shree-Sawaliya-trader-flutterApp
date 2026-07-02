import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/branches/branch_service.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/app_confirm_dialog.dart';
import 'package:sawaliyatrader/core/widgets/app_message.dart';

/// Shows a confirmation dialog and deletes the branch via API.
/// Returns `true` when the branch was deleted successfully.
Future<bool> confirmAndDeleteBranch({
  required BuildContext context,
  required BranchService branchService,
  required LoginResponse session,
  required BranchDto branch,
  int? branchId,
}) async {
  final l10n = context.l10n;
  final confirmed = await showAppConfirmDialog(
    context,
    title: l10n.deleteEntityQuestion(branch.name),
    message: l10n.branchDeleteConfirmMessage,
    confirmLabel: l10n.delete,
    destructive: true,
  );

  if (confirmed != true || !context.mounted) return false;

  try {
    await branchService.deleteBranch(
      session: session,
      branchId: branchId ?? branch.id,
    );

    if (!context.mounted) return false;

    await showAppSuccessMessage(
      context,
      message: context.l10n.branchDeleted(branch.name),
    );
    return true;
  } catch (error) {
    if (!context.mounted) return false;

    final message =
        error is ApiException ? error.message : error.toString();
    await showAppErrorMessage(context, message: message);
    return false;
  }
}
