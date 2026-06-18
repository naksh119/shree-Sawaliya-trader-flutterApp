import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/themed_app_bar.dart';

class ModulePlaceholderScreen extends StatelessWidget {
  const ModulePlaceholderScreen({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(title: title,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: AppTextStyles.body(context)),
            const SizedBox(height: 12),
            Text(
              'This module will be built in a future release.',
              style: AppTextStyles.subtitle(context),
            ),
          ],
        ),
      ),
    );
  }
}
