import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/locale/locale_context.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown.dart';
import 'package:sawaliyatrader/core/widgets/app_dropdown_decoration.dart';
import 'package:sawaliyatrader/core/widgets/brand_gradient.dart';
import 'package:sawaliyatrader/core/widgets/app_image_viewer.dart';

class CustomerWizardDocumentsStep extends StatelessWidget {
  const CustomerWizardDocumentsStep({
    super.key,
    required this.documentType,
    required this.pickedFilePath,
    required this.pickedFileName,
    required this.apiError,
    required this.onPickDocument,
    required this.onDocumentTypeChanged,
  });

  final String documentType;
  final String? pickedFilePath;
  final String? pickedFileName;
  final String? Function(String field) apiError;
  final VoidCallback onPickDocument;
  final ValueChanged<String> onDocumentTypeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.uploadKycDocument,
          style: AppTextStyles.subtitle(context),
        ),
        const SizedBox(height: 16),
        AppDropdownFormField<String>(
          value: documentType,
          decoration: AppDropdownDecoration.formField(
            context,
            labelText: l10n.documentType,
          ).copyWith(errorText: apiError('document_type')),
          validator: (value) =>
              apiError('document_type') ??
              (value == null || value.isEmpty ? l10n.required : null),
          items: [
            DropdownMenuItem(
              value: 'AADHAAR',
              child: Text(l10n.documentTypeAadhaar),
            ),
            DropdownMenuItem(value: 'PAN', child: Text(l10n.documentTypePan)),
            DropdownMenuItem(
              value: 'PHOTO',
              child: Text(l10n.documentTypePhoto),
            ),
            DropdownMenuItem(
              value: 'OTHER',
              child: Text(l10n.documentTypeOther),
            ),
          ],
          onChanged: (value) {
            if (value != null) onDocumentTypeChanged(value);
          },
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onPickDocument,
          icon: BrandGradientIcon(Icons.upload_file),
          label: Text(
            pickedFileName ?? l10n.chooseFile,
            style: AppTextStyles.body(context),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(
              color: apiError('file') != null
                  ? Colors.red.shade300
                  : context.appColors.border,
            ),
          ),
        ),
        if (apiError('file') != null) ...[
          const SizedBox(height: 8),
          Text(
            apiError('file')!,
            style: AppTextStyles.body(context).copyWith(
              color: Colors.red.shade700,
              fontSize: 12,
            ),
          ),
        ],
        if (pickedFilePath != null &&
            appPreviewImageIsLocalImagePath(pickedFilePath)) ...[
          const SizedBox(height: 12),
          Text(
            l10n.selectedPreview,
            style: AppTextStyles.subtitle(context).copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          AppPreviewImage(
            imagePath: pickedFilePath,
            height: 140,
            width: 140,
            fit: BoxFit.contain,
            borderRadius: BorderRadius.circular(12),
            viewerTitle: l10n.documentPreview,
          ),
        ],
      ],
    );
  }
}
