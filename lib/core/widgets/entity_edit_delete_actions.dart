import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/app_confirm_dialog.dart';
import 'package:sawaliyatrader/core/widgets/app_delete_button.dart';
import 'package:sawaliyatrader/core/widgets/app_gradient_icon_button.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
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
    final confirmed = await showAppConfirmDialog(
      context,
      title: l10n.deleteEntityQuestion(entityName),
      message: l10n.deleteCannotUndo,
      confirmLabel: l10n.delete,
      destructive: true,
    );

    if (confirmed != true || !context.mounted) return;

    await showAppSuccessMessage(
      context,
      message: l10n.deleteEntityComingSoon(entityName),
    );
  }
}

/// Edit + Delete icons stacked vertically inside gradient-bordered containers.
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
          AppGradientIconButton(
            size: buttonSize,
            tooltip: l10n.edit,
            icon: Icons.edit_outlined,
            onPressed: onEdit ??
                () => EntityActionPlaceholder.onEdit(context, entityName),
          ),
        if (canEdit && canDelete) SizedBox(height: gap),
        if (canDelete)
          AppGradientIconButton(
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
                child: AppDeleteButton(
                  label: l10n.delete,
                  onPressed: onDelete ??
                      () => EntityActionPlaceholder.onDelete(context, entityName),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
