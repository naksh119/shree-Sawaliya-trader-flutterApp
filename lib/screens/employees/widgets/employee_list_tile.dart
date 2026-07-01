import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/employees/models/employee_dto.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_status_chip.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/widgets/entity_edit_delete_actions.dart';

class EmployeeListTile extends StatelessWidget {
  const EmployeeListTile({
    required this.employee,
    required this.onTap,
    this.canEdit = false,
    this.canDelete = false,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final EmployeeDto employee;
  final VoidCallback onTap;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
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
              _EmployeeAvatar(employee: employee),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.displayName,
                      style: AppTextStyles.label(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.displayCode,
                      style: AppTextStyles.subtitle(context),
                    ),
                    if (employee.roleLabel.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        employee.roleLabel,
                        style: AppTextStyles.body(context),
                      ),
                    ],
                    if (employee.branch.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        employee.branch,
                        style: AppTextStyles.subtitle(context),
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
                    label: employee.isActive
                        ? context.l10n.active
                        : context.l10n.inactive,
                    compact: true,
                  ),
                  EntityEditDeleteTrailingActions(
                    entityName: employee.displayName,
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

class _EmployeeAvatar extends StatelessWidget {
  const _EmployeeAvatar({required this.employee});

  final EmployeeDto employee;

  @override
  Widget build(BuildContext context) {
    final photo = employee.employeePhoto?.trim();
    if (photo != null && photo.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: context.appColors.goldTint,
        backgroundImage: NetworkImage(photo),
      );
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: context.appColors.goldTint,
      child: BrandGradientText(
        text: employee.initials,
        style: AppTextStyles.label(context),
      ),
    );
  }
}

