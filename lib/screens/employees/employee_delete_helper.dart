import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/employees/employee_service.dart';
import 'package:sawaliyatrader/core/employees/models/employee_dto.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/app_confirm_dialog.dart';
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
  final l10n = context.l10n;
  final confirmed = await showAppConfirmDialog(
    context,
    title: l10n.deleteEntityQuestion(employee.displayName),
    message: l10n.employeeDeleteConfirmMessage,
    confirmLabel: l10n.delete,
    destructive: true,
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
