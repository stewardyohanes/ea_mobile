import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'jwt_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _onboardingKey = 'onboarding_done';
  static const _disclaimerKey = 'disclaimer_accepted';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  static Future<void> setOnboardingDone() async {
    await _storage.write(key: _onboardingKey, value: 'true');
  }

  static Future<bool> isOnboardingDone() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static Future<void> setDisclaimerAccepted() async {
    await _storage.write(key: _disclaimerKey, value: 'true');
  }

  static Future<bool> isDisclaimerAccepted() async {
    final value = await _storage.read(key: _disclaimerKey);
    return value == 'true';
  }
}
