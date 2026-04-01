import 'package:tradegenz_app/core/network/dio_client.dart';

class SubscriptionApi {
  SubscriptionApi._();

  static final _dio = DioClient.instance;

  /// Kirim purchase token ke backend untuk diverifikasi ke Google Play API.
  /// Return: { plan, plan_expires_at }
  static Future<Map<String, dynamic>> verifyPurchase({
    required String purchaseToken,
    required String productId,
  }) async {
    final response = await _dio.post(
      'subscription/verify',
      data: {
        'purchase_token': purchaseToken,
        'product_id': productId,
        'package_name': 'com.tradegenz.tradegenz_app',
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
