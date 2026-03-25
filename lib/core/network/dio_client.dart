import 'package:dio/dio.dart';
import 'package:tradegenz_app/core/storage/secure_storage.dart';

class DioClient {
  DioClient._();

  static final Dio _dio = _createDio();

  static Dio get instance => _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.tradegenz.com/api/v1/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    dio.interceptors.add(_AuthInterceptor(dio));

    return dio;
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;

  _AuthInterceptor(this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Hanya handle 401 dan bukan dari endpoint refresh/login sendiri
    final path = err.requestOptions.path;
    final isAuthEndpoint =
        path.contains('/auth/refresh') || path.contains('/auth/login');

    if (err.response?.statusCode == 401 && !isAuthEndpoint && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await SecureStorage.getRefreshToken();
        if (refreshToken == null) {
          await _clearSessionAndReject(handler, err);
          return;
        }

        // Pakai Dio baru untuk hindari interceptor loop
        final refreshDio = Dio(BaseOptions(
          baseUrl: _dio.options.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ));

        final response = await refreshDio.post(
          '/auth/refresh',
          data: {'refresh_token': refreshToken},
        );

        final newAccessToken = response.data['token'] as String;
        final newRefreshToken = response.data['refresh_token'] as String;

        await SecureStorage.saveToken(newAccessToken);
        await SecureStorage.saveRefreshToken(newRefreshToken);

        // Retry request asal dengan token baru
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _dio.fetch(retryOptions);
        handler.resolve(retryResponse);
      } catch (_) {
        await _clearSessionAndReject(handler, err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _clearSessionAndReject(
    ErrorInterceptorHandler handler,
    DioException err,
  ) async {
    await SecureStorage.deleteToken();
    await SecureStorage.deleteRefreshToken();
    handler.next(err);
  }
}
