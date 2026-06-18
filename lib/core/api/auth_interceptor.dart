import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';

/// Attaches the access token to every API call and refreshes on 401.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required Future<String?> Function() getAccessToken,
    required Future<String> Function() onRefresh,
    required Future<void> Function() onRefreshFailed,
  })  : _dio = dio,
        _getAccessToken = getAccessToken,
        _onRefresh = onRefresh,
        _onRefreshFailed = onRefreshFailed;

  final Dio _dio;
  final Future<String?> Function() _getAccessToken;
  final Future<String> Function() _onRefresh;
  final Future<void> Function() _onRefreshFailed;

  Future<String>? _refreshing;

  static const _retriedKey = 'auth_retried';

  static const _publicPaths = {
    ApiConfig.loginPath,
    ApiConfig.refreshPath,
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublicPath(options.path)) {
      return handler.next(options);
    }

    try {
      final token = await _getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        debugPrint('[Auth] No access token available for ${options.path}');
      }
      handler.next(options);
    } catch (error, stack) {
      debugPrint('[Auth] Failed to read access token: $error\n$stack');
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          message: 'Failed to attach auth token',
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRefresh(err)) {
      return handler.next(err);
    }

    if (err.requestOptions.extra[_retriedKey] == true) {
      debugPrint('[Auth] Token refresh already attempted for ${err.requestOptions.path}');
      return handler.next(err);
    }

    try {
      debugPrint('[Auth] 401 on ${err.requestOptions.path}, refreshing token…');
      final access = await (_refreshing ??= _onRefresh().whenComplete(
        () => _refreshing = null,
      ));

      final options = err.requestOptions;
      options.extra[_retriedKey] = true;
      options.headers['Authorization'] = 'Bearer $access';

      debugPrint('[Auth] Retrying ${options.path} with refreshed token');
      final response = await _dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } catch (error, stack) {
      debugPrint('[Auth] Refresh/retry failed: $error\n$stack');
      await _onRefreshFailed();
      return handler.next(err);
    }
  }

  bool _shouldRefresh(DioException err) {
    if (err.response?.statusCode != 401) return false;
    return !_isPublicPath(err.requestOptions.path);
  }

  bool _isPublicPath(String path) {
    final normalized = path.endsWith('/') && path.length > 1
        ? path.substring(0, path.length - 1)
        : path;
    for (final publicPath in _publicPaths) {
      final publicNormalized = publicPath.endsWith('/') && publicPath.length > 1
          ? publicPath.substring(0, publicPath.length - 1)
          : publicPath;
      if (normalized == publicNormalized) return true;
    }
    return false;
  }
}
