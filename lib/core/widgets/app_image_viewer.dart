import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';

/// Whether [url] points to a remote image that can be loaded and previewed.
bool appPreviewImageIsNetworkUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.startsWith('http://') || url.startsWith('https://');
}

/// Whether [path] points to a common local image file.
bool appPreviewImageIsLocalImagePath(String? path) {
  if (path == null || path.isEmpty) return false;
  final ext = path.split('.').last.toLowerCase();
  return const {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'heic',
    'heif',
  }.contains(ext);
}

Future<void> showAppImageViewer(
  BuildContext context, {
  String? imageUrl,
  Uint8List? imageBytes,
  String? imagePath,
  String? title,
}) {
  assert(
    imageUrl != null || imageBytes != null || imagePath != null,
    'Provide imageUrl, imageBytes, or imagePath.',
  );

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black87,
    builder: (dialogContext) {
      final resolvedTitle = title ?? dialogContext.l10n.imagePreview;
      return Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: dialogContext.l10n.close,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              if (resolvedTitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    resolvedTitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4,
                  child: Center(
                    child: _ViewerImage(
                      imageUrl: imageUrl,
                      imageBytes: imageBytes,
                      imagePath: imagePath,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Opens the viewer for a locally picked upload image.
Future<void> showAppImageViewerForPicked(
  BuildContext context,
  PickedImage image, {
  String? title,
}) {
  if (image.bytes != null) {
    return showAppImageViewer(
      context,
      imageBytes: image.bytes,
      title: title,
    );
  }
  if (image.path != null) {
    return showAppImageViewer(
      context,
      imagePath: image.path,
      title: title,
    );
  }
  return Future.value();
}

/// Displays an image preview with built-in tap-to-view fullscreen behavior.
class AppPreviewImage extends StatelessWidget {
  const AppPreviewImage({
    this.imageUrl,
    this.imageBytes,
    this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.viewerTitle,
    this.enableViewer = true,
    this.placeholder,
    super.key,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? viewerTitle;
  final bool enableViewer;
  final Widget? placeholder;

  bool get _canView =>
      enableViewer &&
      (imageBytes != null ||
          imagePath != null ||
          appPreviewImageIsNetworkUrl(imageUrl));

  void _openViewer(BuildContext context) {
    if (!_canView) return;
    showAppImageViewer(
      context,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      imagePath: imagePath,
      title: viewerTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if (imageBytes != null) {
      image = Image.memory(
        imageBytes!,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (imagePath != null) {
      image = Image.file(
        File(imagePath!),
        width: width,
        height: height,
        fit: fit,
      );
    } else if (appPreviewImageIsNetworkUrl(imageUrl)) {
      image = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            placeholder ?? _defaultPlaceholder(context),
      );
    } else {
      return placeholder ?? _defaultPlaceholder(context);
    }

    final radius = borderRadius;
    final clipped = radius != null
        ? ClipRRect(borderRadius: radius, child: image)
        : image;

    if (!_canView) return clipped;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openViewer(context),
        borderRadius: radius ?? BorderRadius.zero,
        child: clipped,
      ),
    );
  }

  Widget _defaultPlaceholder(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: BrandGradientIcon(
        Icons.broken_image_outlined,
        opacity: 0.54,
      ),
    );
  }
}

class _ViewerImage extends StatelessWidget {
  const _ViewerImage({
    this.imageUrl,
    this.imageBytes,
    this.imagePath,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, fit: BoxFit.contain);
    }
    if (imagePath != null) {
      return Image.file(File(imagePath!), fit: BoxFit.contain);
    }
    return Image.network(
      imageUrl!,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: CircularProgressIndicator(color: Colors.white54),
        );
      },
      errorBuilder: (_, __, ___) => BrandGradientIcon(
        Icons.broken_image_outlined,
        size: 64,
        opacity: 0.54,
      ),
    );
  }
}
