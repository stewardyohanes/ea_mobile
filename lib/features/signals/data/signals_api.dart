import 'package:tradegenz_app/core/network/dio_client.dart';
import 'package:tradegenz_app/features/signals/models/signal_model.dart';

class SignalsApi {
  SignalsApi._();

  static final _dio = DioClient.instance;

  static Future<List<Signal>> getSignals({
    int page = 1,
    int limit = 20,
    String? direction,
  }) async {
    final response = await _dio.get(
      '/signals',
      queryParameters: {'page': page, 'limit': limit, 'direction': ?direction},
    );

    final List data = response.data['data'] as List? ?? [];
    return data.map((json) => Signal.fromJson(json)).toList();
  }

  static Future<Signal> getSignalById(String id) async {
    final response = await _dio.get('signals/$id');
    return Signal.fromJson(response.data as Map<String, dynamic>);
  }
}
