import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/language_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/theme_toggle_button.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemedAppBar({
    this.title,
    this.titleWidget,
    this.leading,
    this.actions = const [],
    this.automaticallyImplyLeading,
    this.showLanguageDropdown = false,
    this.showThemeToggle = false,
    super.key,
  }) : assert(title != null || titleWidget != null);

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget> actions;
  final bool? automaticallyImplyLeading;
  final bool showLanguageDropdown;
  final bool showThemeToggle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? leading == null,
      leading: leading,
      title: titleWidget ?? Text(title!, style: AppTextStyles.heading(context)),
      actions: [
        if (showLanguageDropdown) const LanguageDropdown(),
        if (showThemeToggle) const ThemeToggleButton(),
        ...actions,
      ],
    );
  }
}
