import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_message.dart';

/// Placeholder handlers until edit/delete APIs are wired.
abstract final class EntityActionPlaceholder {
  static Future<void> onEdit(BuildContext context, String entityName) {
    final l10n = context.l10n;
    return showAppSuccessMessage(
      context,
      message: l10n.editEntityComingSoon(entityName),
    );
  }

  static Future<void> onDelete(BuildContext context, String entityName) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.deleteEntityQuestion(entityName),
          style: AppTextStyles.heading(context),
        ),
        content: Text(
          l10n.deleteCannotUndo,
          style: AppTextStyles.body(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel, style: AppTextStyles.link(context)),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.appColors.gold,
              foregroundColor: AppColors.navy,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await showAppSuccessMessage(
      context,
      message: l10n.deleteEntityComingSoon(entityName),
    );
  }
}

class _BrandIconButton extends StatelessWidget {
  const _BrandIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.size = 34,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
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
            child: BrandGradientIcon(
              icon,
              size: size * 0.5,
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

    final l10n = context.l10n;
    final buttonSize = compact ? 34.0 : 38.0;
    final gap = compact ? 6.0 : 8.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canEdit)
          _BrandIconButton(
            size: buttonSize,
            tooltip: l10n.edit,
            icon: Icons.edit_outlined,
            onPressed: onEdit ??
                () => EntityActionPlaceholder.onEdit(context, entityName),
          ),
        if (canEdit && canDelete) SizedBox(height: gap),
        if (canDelete)
          _BrandIconButton(
            size: buttonSize,
            tooltip: l10n.delete,
            icon: Icons.delete_outline,
            onPressed: onDelete ??
                () => EntityActionPlaceholder.onDelete(context, entityName),
          ),
      ],
    );
  }
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

    final l10n = context.l10n;

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
                  icon: BrandGradientIcon(Icons.edit_outlined, size: 18),
                  label: Text(l10n.edit),
                ),
              ),
            if (canEdit && canDelete) const SizedBox(width: 12),
            if (canDelete)
              Expanded(
                child: FilledButton.icon(
                  onPressed: onDelete ??
                      () => EntityActionPlaceholder.onDelete(context, entityName),
                  style: FilledButton.styleFrom(
                    backgroundColor: context.appColors.gold,
                    foregroundColor: AppColors.navy,
                  ),
                  icon: BrandGradientIcon(Icons.delete_outline, size: 18),
                  label: Text(l10n.delete),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
