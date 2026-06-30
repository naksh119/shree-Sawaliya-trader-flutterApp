import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/widgets/app_image_viewer.dart';

/// Reusable image upload field with preview, used across employee, customer, and branch forms.
class AppPhotoPicker extends StatelessWidget {
  const AppPhotoPicker({
    required this.label,
    required this.image,
    required this.onPick,
    this.onClear,
    this.existingImageUrl,
    this.existingImageLabel,
    this.hint,
    this.errorText,
    this.placeholderIcon = Icons.image_outlined,
    super.key,
  });

  final String label;
  final PickedImage? image;
  final VoidCallback onPick;
  final VoidCallback? onClear;
  final String? existingImageUrl;
  final String? existingImageLabel;
  final String? hint;
  final String? errorText;
  final IconData placeholderIcon;

  bool get _hasNewPhoto => image?.isNotEmpty ?? false;

  bool get _showExistingPreview {
    final url = existingImageUrl;
    return !_hasNewPhoto && url != null && url.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hintText = hint ?? l10n.uploadPhotoOptional;
    final picked = image;
    final previewProvider = _previewImageProvider(picked);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showExistingPreview) ...[
          _LargePreviewSection(
            caption: existingImageLabel ?? l10n.currentImageCaption(label),
            child: appPreviewImageIsNetworkUrl(existingImageUrl)
                ? AppPreviewImage(
                    imageUrl: existingImageUrl,
                    height: 140,
                    width: 140,
                    fit: BoxFit.contain,
                    borderRadius: BorderRadius.circular(12),
                    viewerTitle: label,
                    placeholder: _ExistingPlaceholder(
                      icon: placeholderIcon,
                      label: l10n.imageOnFile,
                    ),
                  )
                : _ExistingPlaceholder(
                    icon: placeholderIcon,
                    label: l10n.imageOnFile,
                  ),
          ),
          const SizedBox(height: 16),
        ],
        Text(label, style: AppTextStyles.label(context)),
        const SizedBox(height: 8),
        Row(
          children: [
            _PreviewAvatar(
              image: picked,
              previewProvider: previewProvider,
              placeholderIcon: placeholderIcon,
              viewerTitle: label,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _hasNewPhoto
                        ? (picked?.name ?? l10n.photoSelected)
                        : hintText,
                    style: AppTextStyles.subtitle(context).copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  if (_hasNewPhoto || _showExistingPreview) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.tapPreviewFullSize,
                      style: AppTextStyles.subtitle(context).copyWith(
                        color: context.appColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: onPick,
                        icon: BrandGradientIcon(
                          Icons.upload_file,
                          size: 20,
                        ),
                        label: Text(
                          _hasNewPhoto ? l10n.changePhoto : l10n.choosePhoto,
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
                          tooltip: l10n.removePhoto,
                          icon: BrandGradientIcon(
                            Icons.close,
                            opacity: 0.7,
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

  ImageProvider? _previewImageProvider(PickedImage? picked) {
    if (picked == null || !picked.isNotEmpty) return null;
    if (picked.bytes != null) return MemoryImage(picked.bytes!);
    if (picked.path != null) return FileImage(File(picked.path!));
    return null;
  }
}

class _LargePreviewSection extends StatelessWidget {
  const _LargePreviewSection({
    required this.caption,
    required this.child,
  });

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: AppTextStyles.subtitle(context).copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ExistingPlaceholder extends StatelessWidget {
  const _ExistingPlaceholder({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.appColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BrandGradientIcon(
            icon,
            size: 36,
            opacity: 0.7,
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.subtitle(context)),
        ],
      ),
    );
  }
}

class _PreviewAvatar extends StatelessWidget {
  const _PreviewAvatar({
    required this.image,
    required this.previewProvider,
    required this.placeholderIcon,
    required this.viewerTitle,
  });

  final PickedImage? image;
  final ImageProvider? previewProvider;
  final IconData placeholderIcon;
  final String viewerTitle;

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: 32,
      backgroundColor: context.appColors.inputFill,
      backgroundImage: previewProvider,
      child: previewProvider == null
          ? BrandGradientIcon(
              placeholderIcon,
              size: 32,
              opacity: 0.7,
            )
          : null,
    );

    final picked = image;
    if (picked == null || !picked.isNotEmpty) return avatar;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showAppImageViewerForPicked(
          context,
          picked,
          title: viewerTitle,
        ),
        customBorder: const CircleBorder(),
        child: avatar,
      ),
    );
  }
}
