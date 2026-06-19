import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

/// A locally selected image file ready for multipart upload.
class PickedImage {
  const PickedImage({this.path, this.name, this.bytes});

  final String? path;
  final String? name;
  final Uint8List? bytes;

  bool get isEmpty => path == null && bytes == null;
  bool get isNotEmpty => !isEmpty;

  static Future<PickedImage?> pick() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    if (file.path == null && file.bytes == null) return null;

    return PickedImage(
      path: file.path,
      name: file.name,
      bytes: file.bytes,
    );
  }

  Future<MultipartFile> toMultipartFile({required String defaultFileName}) async {
    final filename = name ?? defaultFileName;
    if (path != null) {
      return MultipartFile.fromFile(path!, filename: filename);
    }
    return MultipartFile.fromBytes(bytes!, filename: filename);
  }
}
