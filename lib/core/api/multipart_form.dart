import 'package:dio/dio.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';

bool multipartHasFiles(Map<String, PickedImage> files) =>
    files.values.any((file) => file.isNotEmpty);

Future<FormData> buildMultipartFormData({
  required Map<String, dynamic> fields,
  Map<String, PickedImage> files = const {},
}) async {
  final formMap = <String, dynamic>{};

  for (final entry in fields.entries) {
    final value = entry.value;
    if (value == null) continue;
    if (value is List) {
      formMap[entry.key] = value;
    } else {
      formMap[entry.key] = value.toString();
    }
  }

  for (final entry in files.entries) {
    if (entry.value.isEmpty) continue;
    formMap[entry.key] = await entry.value.toMultipartFile(
      defaultFileName: '${entry.key}.jpg',
    );
  }

  return FormData.fromMap(formMap);
}
