String? readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return null;
}

int? readInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
  return null;
}

double? readDouble(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
  return null;
}

DateTime? readDateTime(Map<String, dynamic> json, List<String> keys) {
  final raw = readString(json, keys);
  if (raw == null) return null;
  return DateTime.tryParse(raw);
}

bool? readBool(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value.toString().trim().toLowerCase();
    if (text == 'true' || text == '1') return true;
    if (text == 'false' || text == '0') return false;
  }
  return null;
}

Map<String, dynamic>? asJsonMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return null;
}

List<Map<String, dynamic>> mapsFromList(dynamic raw) {
  if (raw is! List) return const [];
  return raw.map(asJsonMap).whereType<Map<String, dynamic>>().toList();
}

Map<String, dynamic> dataMap(Map<String, dynamic> body) {
  final data = body['data'];
  final mapped = asJsonMap(data);
  if (mapped != null) return mapped;
  return body;
}

/// Extracts list items from API bodies where `data` may be a list or a paginated map.
List<Map<String, dynamic>> listMapsFromBody(Map<String, dynamic> body) {
  final data = body['data'];
  if (data is List) {
    return mapsFromList(data);
  }

  final dataMapValue = asJsonMap(data);
  if (dataMapValue != null) {
    final nested = dataMapValue['results'] ??
        dataMapValue['items'] ??
        dataMapValue['branches'] ??
        dataMapValue['employees'];
    final nestedItems = mapsFromList(nested);
    if (nestedItems.isNotEmpty) return nestedItems;
  }

  return mapsFromList(body['results'] ?? body['items']);
}

int? paginationInt(Map<String, dynamic> body, List<String> keys) {
  final topLevel = readInt(body, keys);
  if (topLevel != null) return topLevel;

  final data = asJsonMap(body['data']);
  if (data != null) {
    return readInt(data, keys);
  }

  return null;
}
