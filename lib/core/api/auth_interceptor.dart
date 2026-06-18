import 'package:dio/dio.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';

/// Retries failed requests after refreshing the access token on 401.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required Future<String> Function() onRefresh,
    required Future<void> Function() onRefreshFailed,
  })  : _dio = dio,
        _onRefresh = onRefresh,
        _onRefreshFailed = onRefreshFailed;

  final Dio _dio;
  final Future<String> Function() _onRefresh;
  final Future<void> Function() _onRefreshFailed;

  Future<String>? _refreshing;

  static const _authPaths = {
    ApiConfig.loginPath,
    ApiConfig.refreshPath,
    ApiConfig.logoutPath,
  };

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRefresh(err)) {
      return handler.next(err);
    }

    try {
      final access = await (_refreshing ??= _onRefresh().whenComplete(
        () => _refreshing = null,
      ));
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $access';
      final response = await _dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } catch (_) {
      await _onRefreshFailed();
      return handler.next(err);
    }
  }

  bool _shouldRefresh(DioException err) {
    if (err.response?.statusCode != 401) return false;
    return !_authPaths.contains(err.requestOptions.path);
  }
}
