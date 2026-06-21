import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/employees/employee_service.dart';
import 'package:sawaliyatrader/core/employees/models/employee_dto.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_message.dart';

/// Shows a confirmation dialog and deletes the employee via API.
/// Returns `true` when the employee was deleted successfully.
Future<bool> confirmAndDeleteEmployee({
  required BuildContext context,
  required EmployeeService employeeService,
  required LoginResponse session,
  required EmployeeDto employee,
  int? employeeId,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final l10n = dialogContext.l10n;
      return AlertDialog(
      title: Text(
        l10n.deleteEntityQuestion(employee.displayName),
        style: AppTextStyles.heading(dialogContext),
      ),
      content: Text(
        l10n.employeeDeleteConfirmMessage,
        style: AppTextStyles.body(dialogContext),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: dialogContext.appColors.gold,
            foregroundColor: AppColors.navy,
          ),
          child: Text(l10n.delete),
        ),
      ],
    );
    },
  );

  if (confirmed != true || !context.mounted) return false;

  try {
    await employeeService.deleteEmployee(
      session: session,
      employeeId: employeeId ?? employee.id,
    );

    if (!context.mounted) return false;

    await showAppSuccessMessage(
      context,
      message: context.l10n.employeeDeleted(employee.displayName),
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
