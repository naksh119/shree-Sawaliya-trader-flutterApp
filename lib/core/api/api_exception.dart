class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.fieldErrors = const {},
  });

  final String message;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  bool get hasFieldErrors => fieldErrors.isNotEmpty;

  @override
  String toString() => message;
}
