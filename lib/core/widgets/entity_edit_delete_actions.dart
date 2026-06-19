import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Placeholder handlers until edit/delete APIs are wired.
abstract final class EntityActionPlaceholder {
  static void onEdit(BuildContext context, String entityName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit $entityName — API coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<void> onDelete(BuildContext context, String entityName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $entityName?', style: AppTextStyles.heading(context)),
        content: Text(
          'This action cannot be undone. The delete API will be connected soon.',
          style: AppTextStyles.body(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delete $entityName — API coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _GoldenIconButton extends StatelessWidget {
  const _GoldenIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconColor,
    this.size = 34,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: context.appColors.gold.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: context.appColors.gold.withValues(alpha: 0.42),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: size * 0.5,
              color: iconColor ?? context.appColors.shinyGold,
            ),
          ),
        ),
      ),
    );
  }
}

/// Edit + Delete icons stacked vertically inside golden containers.
class EntityEditDeleteIconStack extends StatelessWidget {
  const EntityEditDeleteIconStack({
    required this.entityName,
    required this.canEdit,
    required this.canDelete,
    this.onEdit,
    this.onDelete,
    this.compact = false,
    super.key,
  });

  final String entityName;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (!canEdit && !canDelete) return const SizedBox.shrink();

    final buttonSize = compact ? 34.0 : 38.0;
    final gap = compact ? 6.0 : 8.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canEdit)
          _GoldenIconButton(
            size: buttonSize,
            tooltip: 'Edit',
            icon: Icons.edit_outlined,
            onPressed: onEdit ??
                () => EntityActionPlaceholder.onEdit(context, entityName),
          ),
        if (canEdit && canDelete) SizedBox(height: gap),
        if (canDelete)
          _GoldenIconButton(
            size: buttonSize,
            tooltip: 'Delete',
            icon: Icons.delete_outline,
            iconColor: Colors.red.shade400,
            onPressed: onDelete ??
                () => EntityActionPlaceholder.onDelete(context, entityName),
          ),
      ],
    );
  }
}

/// Edit + Delete icon buttons for [ThemedAppBar.actions].
List<Widget> buildEntityEditDeleteAppBarActions(
  BuildContext context, {
  required String entityName,
  required bool canEdit,
  required bool canDelete,
  VoidCallback? onEdit,
  VoidCallback? onDelete,
}) {
  if (!canEdit && !canDelete) return const [];

  return [
    Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: EntityEditDeleteIconStack(
          entityName: entityName,
          canEdit: canEdit,
          canDelete: canDelete,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
      ),
    ),
  ];
}

/// Compact edit/delete icons for list tiles.
class EntityEditDeleteTrailingActions extends StatelessWidget {
  const EntityEditDeleteTrailingActions({
    required this.entityName,
    required this.canEdit,
    required this.canDelete,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final String entityName;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return EntityEditDeleteIconStack(
      entityName: entityName,
      canEdit: canEdit,
      canDelete: canDelete,
      onEdit: onEdit,
      onDelete: onDelete,
      compact: true,
    );
  }
}

/// Bottom action bar with Edit and Delete buttons on detail screens.
class EntityEditDeleteBar extends StatelessWidget {
  const EntityEditDeleteBar({
    required this.entityName,
    required this.canEdit,
    required this.canDelete,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final String entityName;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (!canEdit && !canDelete) return const SizedBox.shrink();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: context.appColors.card,
          border: Border(top: BorderSide(color: context.appColors.border)),
        ),
        child: Row(
          children: [
            if (canEdit)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit ??
                      () => EntityActionPlaceholder.onEdit(context, entityName),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
              ),
            if (canEdit && canDelete) const SizedBox(width: 12),
            if (canDelete)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete ??
                      () => EntityActionPlaceholder.onDelete(context, entityName),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade300),
                  ),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
