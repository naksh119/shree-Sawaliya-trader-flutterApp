import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/employees/models/employee_dto.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/entity_edit_delete_actions.dart';

class EmployeeListTile extends StatelessWidget {
  const EmployeeListTile({
    required this.employee,
    required this.onTap,
    this.canEdit = false,
    this.canDelete = false,
    super.key,
  });

  final EmployeeDto employee;
  final VoidCallback onTap;
  final bool canEdit;
  final bool canDelete;

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
                  _ActiveChip(isActive: employee.isActive),
                  EntityEditDeleteTrailingActions(
                    entityName: employee.displayName,
                    canEdit: canEdit,
                    canDelete: canDelete,
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
        backgroundColor: context.appColors.gold.withValues(alpha: 0.18),
        backgroundImage: NetworkImage(photo),
      );
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: context.appColors.gold.withValues(alpha: 0.18),
      child: Text(
        employee.initials,
        style: AppTextStyles.label(
          context,
        ).copyWith(color: context.appColors.shinyGold),
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? const Color(0xFF4CAF50)
        : context.appColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: AppTextStyles.subtitle(
          context,
        ).copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 11),
      ),
    );
  }
}
