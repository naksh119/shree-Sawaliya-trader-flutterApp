import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class CustomerDocument {
  const CustomerDocument({
    required this.id,
    required this.documentType,
    this.fileName,
    this.fileUrl,
    this.uploadedAt,
  });

  factory CustomerDocument.fromJson(Map<String, dynamic> json) {
    return CustomerDocument(
      id: readInt(json, ['id']) ?? 0,
      documentType:
          readString(json, ['document_type', 'type']) ?? 'DOCUMENT',
      fileName: readString(json, ['file_name', 'name']),
      fileUrl: readString(json, ['file_url', 'url', 'file']),
      uploadedAt: readDateTime(json, ['uploaded_at', 'created_at']),
    );
  }

  final int id;
  final String documentType;
  final String? fileName;
  final String? fileUrl;
  final DateTime? uploadedAt;

  String get displayName => fileName ?? documentType;
}
