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

    dio.interceptors.add(_AuthInterceptor());

    return dio;
  }
}

class _AuthInterceptor extends Interceptor {
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized globally
    if (err.response?.statusCode == 401) {
      // You can add logic here to log out the user or refresh the token
      // For example, you might want to clear the token from storage:
      SecureStorage.deleteToken();
      // And then navigate to the login screen or show a message
    }
    handler.next(err);
  }
}
