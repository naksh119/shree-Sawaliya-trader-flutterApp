import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

/// Reusable image upload field with preview, used across employee, customer, and center forms.
class AppPhotoPicker extends StatelessWidget {
  const AppPhotoPicker({
    required this.label,
    required this.image,
    required this.onPick,
    this.onClear,
    this.hint = 'Upload a photo (optional).',
    this.errorText,
    this.placeholderIcon = Icons.image_outlined,
    super.key,
  });

  final String label;
  final PickedImage? image;
  final VoidCallback onPick;
  final VoidCallback? onClear;
  final String hint;
  final String? errorText;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = image?.isNotEmpty ?? false;
    final previewBytes = image?.bytes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label(context)),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: context.appColors.inputFill,
              backgroundImage:
                  previewBytes != null ? MemoryImage(previewBytes) : null,
              child: previewBytes == null
                  ? Icon(
                      placeholderIcon,
                      size: 32,
                      color: context.appColors.textSecondary,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasPhoto
                        ? (image?.name ?? 'Photo selected')
                        : hint,
                    style: AppTextStyles.subtitle(context).copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: onPick,
                        icon: Icon(
                          Icons.upload_file,
                          color: context.appColors.shinyGold,
                          size: 20,
                        ),
                        label: Text(
                          hasPhoto ? 'Change photo' : 'Choose photo',
                          style: AppTextStyles.body(context),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: context.appColors.border),
                        ),
                      ),
                      if (onClear != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: onClear,
                          tooltip: 'Remove photo',
                          icon: Icon(
                            Icons.close,
                            color: context.appColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: AppTextStyles.subtitle(context).copyWith(
              color: Colors.red.shade300,
            ),
          ),
        ],
      ],
    );
  }
}
