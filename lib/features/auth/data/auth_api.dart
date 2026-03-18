import 'package:tradegenz_app/core/network/dio_client.dart';
import 'package:tradegenz_app/shared/models/user_model.dart';

class AuthApi {
  AuthApi._();

  static final _dio = DioClient.instance;

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      'auth/login',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    final response = await _dio.post(
      'auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  static Future<User> getMe() async {
    final response = await _dio.get('/auth/me');
    return User.fromJson(response.data as Map<String, dynamic>);
  }
}
