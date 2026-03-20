import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tradegenz_app/core/network/dio_client.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('=== Background message : ${message.notification?.title} ===');
}

class FcmService {
  FcmService._();

  static final _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission for iOS and Android 13+
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Check grant user permission
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('=== FCM permission granted ===');
      await _registerToken();
    } else {
      debugPrint('=== FCM permission denied ===');
    }

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('=== Foreground message : ${message.notification?.title} ===');
      // Later: Show local notification using flutter_local_notifications
    });
  }

  static Future<void> _registerToken() async {
    final token = await _messaging.getToken();
    if (token == null) return;

    debugPrint('=== FCM Token: $token ===');

    try {
      await DioClient.instance.post(
        '/device/register',
        data: {'token': token, 'platform': defaultTargetPlatform.toString()},
      );

      debugPrint('=== FCM token registered successfully ===');
    } catch (e) {
      debugPrint('=== Error registering FCM token ===');
    }
  }

  static Future<void> deleteToken() async {
    await _messaging.deleteToken();
  }
}
