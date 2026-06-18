import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/api/auth_interceptor.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';

class ApiClient {
  ApiClient._({
    required Dio dio,
    required CookieJar cookieJar,
  })  : _dio = dio,
        _cookieJar = cookieJar;

  static ApiClient? _instance;
  static Future<void>? _initializing;

  final Dio _dio;
  final CookieJar _cookieJar;

  /// Shared client with cookie persistence and auth refresh. Call from [main].
  static Future<ApiClient> initialize({
    Future<String> Function()? onRefresh,
    Future<void> Function()? onRefreshFailed,
  }) async {
    if (_instance != null) return _instance!;
    _initializing ??= _create(
      onRefresh: onRefresh,
      onRefreshFailed: onRefreshFailed,
    );
    await _initializing;
    return _instance!;
  }

  static Future<void> _create({
    Future<String> Function()? onRefresh,
    Future<void> Function()? onRefreshFailed,
  }) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final cookieJar = await _createCookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    if (onRefresh != null && onRefreshFailed != null) {
      dio.interceptors.add(
        AuthInterceptor(
          dio: dio,
          onRefresh: onRefresh,
          onRefreshFailed: onRefreshFailed,
        ),
      );
    }

    _instance = ApiClient._(dio: dio, cookieJar: cookieJar);
  }

  static Future<CookieJar> _createCookieJar() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return PersistCookieJar(
        storage: FileStorage('${directory.path}/.cookies/'),
      );
    } catch (error) {
      debugPrint('Cookie persistence unavailable, using in-memory jar: $error');
      return CookieJar();
    }
  }

  factory ApiClient({Dio? dio, CookieJar? cookieJar}) {
    if (_instance != null) return _instance!;
    if (dio != null) {
      return ApiClient._(
        dio: dio,
        cookieJar: cookieJar ?? CookieJar(),
      );
    }
    debugPrint(
      'ApiClient used before initialize(); cookies and refresh are disabled.',
    );
    return ApiClient._(
      dio: Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ),
      ),
      cookieJar: CookieJar(),
    );
  }

  Dio get dio => _dio;

  Future<void> clearCookies() => _cookieJar.deleteAll();

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      final body = response.data;

      debugPrint(
        'API POST $path → status: ${response.statusCode}, body: $body',
      );

      if (body == null) {
        throw const ApiException('Empty response from server');
      }

      return body;
    } on DioException catch (error) {
      debugPrint(
        'API POST $path failed → status: ${error.response?.statusCode}, '
        'body: ${error.response?.data}',
      );
      throw _mapDioError(error);
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      final body = response.data;

      debugPrint(
        'API GET $path → status: ${response.statusCode}, body: $body',
      );

      if (body == null) {
        throw const ApiException('Empty response from server');
      }

      return body;
    } on DioException catch (error) {
      debugPrint(
        'API GET $path failed → status: ${error.response?.statusCode}, '
        'body: ${error.response?.data}',
      );
      throw _mapDioError(error);
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(path, data: data);
      final body = response.data;

      debugPrint(
        'API PATCH $path → status: ${response.statusCode}, body: $body',
      );

      if (body == null) {
        throw const ApiException('Empty response from server');
      }

      return body;
    } on DioException catch (error) {
      debugPrint(
        'API PATCH $path failed → status: ${error.response?.statusCode}, '
        'body: ${error.response?.data}',
      );
      throw _mapDioError(error);
    }
  }

  ApiException _mapDioError(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['error'] as String?;
      if (message != null && message.isNotEmpty) {
        return ApiException(message, statusCode: error.response?.statusCode);
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const ApiException(
          'Unable to reach the server. Check your connection.',
        );
      default:
        return ApiException(
          'Something went wrong. Please try again.',
          statusCode: error.response?.statusCode,
        );
    }
  }
}
