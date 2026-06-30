import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';

/// Applies the brand teal → navy gradient to any child.
///
/// The child should use [Colors.white] as its fill color (text, icons, etc.)
/// so the shader mask can tint it correctly.
class BrandGradientMask extends StatelessWidget {
  const BrandGradientMask({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) =>
          AppColors.brandGradient.createShader(bounds),
      child: child,
    );
  }
}

/// Brand-highlighted text — uses [AppTextStyles.highlighted] by default.
class BrandGradientText extends StatelessWidget {
  const BrandGradientText({
    required this.text,
    super.key,
    this.style,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = (style ?? AppTextStyles.highlighted(context))
        .copyWith(color: Colors.white);

    return BrandGradientMask(
      child: Text(
        text,
        textAlign: textAlign,
        style: resolvedStyle,
      ),
    );
  }
}

/// Brand-highlighted icon.
class BrandGradientIcon extends StatelessWidget {
  const BrandGradientIcon(
    this.icon, {
    super.key,
    this.size,
    this.opacity = 1,
  });

  final IconData icon;
  final double? size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final iconWidget = BrandGradientMask(
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );

    if (opacity >= 1) return iconWidget;
    return Opacity(opacity: opacity, child: iconWidget);
  }
}
