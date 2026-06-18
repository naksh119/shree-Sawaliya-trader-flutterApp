import 'package:sawaliyatrader/core/api/api_exception.dart';

/// Parses Django / DRF validation errors from API responses.
Map<String, String> parseApiFieldErrors(dynamic error) {
  if (error == null) return const {};

  if (error is Map) {
    return _parseErrorMap(error);
  }

  if (error is String) {
    final trimmed = error.trim();
    if (trimmed.startsWith('{')) {
      return _parseErrorDetailString(trimmed);
    }
  }

  return const {};
}

/// Builds an [ApiException] from an API `error` payload (string, map, or repr).
ApiException apiExceptionFromError(
  dynamic error, {
  required String fallback,
  int? statusCode,
}) {
  final fieldErrors = parseApiFieldErrors(error);
  if (fieldErrors.isNotEmpty) {
    return ApiException(
      'Please fix the highlighted fields.',
      statusCode: statusCode,
      fieldErrors: fieldErrors,
    );
  }

  if (error is String && error.trim().isNotEmpty) {
    return ApiException(error.trim(), statusCode: statusCode);
  }

  return ApiException(fallback, statusCode: statusCode);
}

Map<String, String> _parseErrorMap(Map<dynamic, dynamic> error) {
  final result = <String, String>{};
  for (final entry in error.entries) {
    final message = _messageFromValue(entry.value);
    if (message != null) {
      result[entry.key.toString()] = message;
    }
  }
  return result;
}

String? _messageFromValue(dynamic value) {
  if (value is List) {
    final messages = value
        .map(_messageFromItem)
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    if (messages.isEmpty) return null;
    return messages.join(' ');
  }

  if (value is String && value.trim().isNotEmpty) {
    return _messageFromItem(value);
  }

  return null;
}

String _messageFromItem(dynamic item) {
  if (item is String) {
    return _extractErrorDetailMessage(item) ?? item;
  }
  if (item is Map && item['string'] != null) {
    return item['string'].toString();
  }
  final text = item.toString();
  return _extractErrorDetailMessage(text) ?? text;
}

String? _extractErrorDetailMessage(String text) {
  final match = RegExp(r"string='([^']*)'").firstMatch(text);
  return match?.group(1)?.trim();
}

Map<String, String> _parseErrorDetailString(String error) {
  final result = <String, String>{};
  final fieldPattern = RegExp(r"'([\w_]+)'\s*:\s*\[([^\]]*)\]");
  final messagePattern = RegExp(r"string='([^']*)'");

  for (final match in fieldPattern.allMatches(error)) {
    final field = match.group(1)!;
    final block = match.group(2)!;
    final messages = messagePattern
        .allMatches(block)
        .map((m) => m.group(1)!.trim())
        .where((message) => message.isNotEmpty)
        .toList();
    if (messages.isNotEmpty) {
      result[field] = messages.join(' ');
    }
  }

  return result;
}
