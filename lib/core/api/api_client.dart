import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sawaliyatrader/core/api/api_error_parser.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/api/auth_interceptor.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

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
    Future<String?> Function()? getAccessToken,
    Future<String> Function()? onRefresh,
    Future<void> Function()? onRefreshFailed,
  }) async {
    if (_instance != null) return _instance!;
    _initializing ??= _create(
      getAccessToken: getAccessToken,
      onRefresh: onRefresh,
      onRefreshFailed: onRefreshFailed,
    );
    await _initializing;
    return _instance!;
  }

  static Future<void> _create({
    Future<String?> Function()? getAccessToken,
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

    if (onRefresh != null &&
        onRefreshFailed != null &&
        getAccessToken != null) {
      final retryDio = Dio(dio.options);
      retryDio.interceptors.add(CookieManager(cookieJar));

      dio.interceptors.add(
        AuthInterceptor(
          retryDio: retryDio,
          getAccessToken: getAccessToken,
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

  /// Django [APPEND_SLASH] redirects missing slashes with 301; POST then loses its body.
  static String _normalizePath(String path) {
    if (path.isEmpty || path.endsWith('/')) return path;
    return '$path/';
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    final requestPath = _normalizePath(path);
    try {
      final response = await _dio.post<dynamic>(
        requestPath,
        data: data,
      );
      final body = asJsonMap(response.data);

      debugPrint(
        'API POST $requestPath → status: ${response.statusCode}, body: $body',
      );

      if (body == null) {
        throw const ApiException('Empty response from server');
      }

      return body;
    } on DioException catch (error) {
      debugPrint(
        'API POST $requestPath failed → status: ${error.response?.statusCode}, '
        'body: ${error.response?.data}',
      );
      throw _mapDioError(error);
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final requestPath = _normalizePath(path);
    try {
      final response = await _dio.get<dynamic>(
        requestPath,
        queryParameters: queryParameters,
      );
      final body = asJsonMap(response.data);

      // debugPrint(
      //   'API GET $path → status: ${response.statusCode}, '
      //   'success: ${body?['success']}, count: ${body?['count']}, '
      //   'dataType: ${body?['data']?.runtimeType}',
      // );

      if (body == null) {
        throw const ApiException('Empty response from server');
      }

      return body;
    } on DioException catch (error) {
      // debugPrint(
      //   'API GET $path failed → status: ${error.response?.statusCode}, '
      //   'body: ${error.response?.data}',
      // );
      throw _mapDioError(error);
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final requestPath = _normalizePath(path);
    try {
      final response = await _dio.delete<Map<String, dynamic>>(requestPath);
      final body = response.data;

      debugPrint(
        'API DELETE $requestPath → status: ${response.statusCode}, body: $body',
      );

      if (body == null) {
        return {'success': true};
      }

      return body;
    } on DioException catch (error) {
      debugPrint(
        'API DELETE $requestPath failed → status: ${error.response?.statusCode}, '
        'body: ${error.response?.data}',
      );
      throw _mapDioError(error);
    }
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required FormData data,
  }) async {
    final requestPath = _normalizePath(path);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        requestPath,
        data: data,
        options: Options(contentType: 'multipart/form-data'),
      );
      final body = response.data;

      debugPrint(
        'API POST (multipart) $requestPath → status: ${response.statusCode}',
      );

      if (body == null) {
        throw const ApiException('Empty response from server');
      }

      return body;
    } on DioException catch (error) {
      debugPrint(
        'API POST (multipart) $requestPath failed → status: ${error.response?.statusCode}',
      );
      throw _mapDioError(error);
    }
  }

  Future<Map<String, dynamic>> putMultipart(
    String path, {
    required FormData data,
  }) async {
    final requestPath = _normalizePath(path);
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        requestPath,
        data: data,
        options: Options(contentType: 'multipart/form-data'),
      );
      final body = response.data;

      debugPrint(
        'API PUT (multipart) $requestPath → status: ${response.statusCode}',
      );

      if (body == null) {
        throw const ApiException('Empty response from server');
      }

      return body;
    } on DioException catch (error) {
      debugPrint(
        'API PUT (multipart) $requestPath failed → status: ${error.response?.statusCode}',
      );
      throw _mapDioError(error);
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    final requestPath = _normalizePath(path);
    try {
      final response =
          await _dio.patch<dynamic>(requestPath, data: data);
      final body = asJsonMap(response.data);

      debugPrint(
        'API PATCH $requestPath → status: ${response.statusCode}, body: $body',
      );

      if (body == null) {
        throw const ApiException('Empty response from server');
      }

      return body;
    } on DioException catch (error) {
      debugPrint(
        'API PATCH $requestPath failed → status: ${error.response?.statusCode}, '
        'body: ${error.response?.data}',
      );
      throw _mapDioError(error);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    final requestPath = _normalizePath(path);
    try {
      final response = await _dio.put<dynamic>(requestPath, data: data);
      final body = asJsonMap(response.data);

      debugPrint(
        'API PUT $requestPath → status: ${response.statusCode}, body: $body',
      );

      if (body == null) {
        throw const ApiException('Empty response from server');
      }

      return body;
    } on DioException catch (error) {
      debugPrint(
        'API PUT $requestPath failed → status: ${error.response?.statusCode}, '
        'body: ${error.response?.data}',
      );
      throw _mapDioError(error);
    }
  }

  ApiException _mapDioError(DioException error) {
    final responseData = error.response?.data;
    final statusCode = error.response?.statusCode;

    final body = asJsonMap(responseData);
    if (body != null) {
      return apiExceptionFromError(
        body['error'],
        fallback: 'Something went wrong. Please try again.',
        statusCode: statusCode,
      );
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
