import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/branches/branch_service.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
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
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        'Delete ${branch.name}?',
        style: AppTextStyles.heading(dialogContext),
      ),
      content: Text(
        'This will permanently remove the branch. This action cannot be undone.',
        style: AppTextStyles.body(dialogContext),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: dialogContext.appColors.gold,
            foregroundColor: AppColors.navy,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
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
      message: 'Branch ${branch.name} deleted.',
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
