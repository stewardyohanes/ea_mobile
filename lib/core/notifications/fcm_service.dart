import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tradegenz_app/core/network/dio_client.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('=== Background message: ${message.notification?.title} ===');
}

// Channel Android untuk sinyal trading
const _androidChannel = AndroidNotificationChannel(
  'signal_channel',
  'Trading Signals',
  description: 'Notifikasi sinyal trading baru',
  importance: Importance.high,
);

final _localNotif = FlutterLocalNotificationsPlugin();

class FcmService {
  FcmService._();

  static final _messaging = FirebaseMessaging.instance;

  // Callback navigasi saat notifikasi di-tap — diset dari main.dart
  static void Function(String signalId)? onNotificationTap;

  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup flutter_local_notifications
    await _localNotif.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (details) {
        // Dipanggil saat user tap notifikasi foreground
        final signalId = details.payload;
        if (signalId != null) onNotificationTap?.call(signalId);
      },
    );

    // Buat Android notification channel
    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Minta izin notifikasi
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('=== FCM permission granted ===');
      await _registerToken();
    } else {
      debugPrint('=== FCM permission denied ===');
    }

    // Foreground: tampilkan sebagai local notification
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('=== Foreground message: ${message.notification?.title} ===');
      _showLocalNotification(message);
    });

    // Background tap: app sudah berjalan, user tap notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final signalId = message.data['signal_id'];
      if (signalId != null) onNotificationTap?.call(signalId as String);
    });

    // Cold start: app dibuka pertama kali lewat tap notifikasi
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final signalId = initialMessage.data['signal_id'];
      if (signalId != null) onNotificationTap?.call(signalId as String);
    }
  }

  static void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotif.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data['signal_id'] as String?,
    );
  }

  static Future<void> _registerToken() async {
    final token = await _messaging.getToken();
    if (token == null) return;

    debugPrint('=== FCM Token: $token ===');

    try {
      await DioClient.instance.post(
        '/devices',
        data: {'token': token, 'platform': defaultTargetPlatform.toString()},
      );
      debugPrint('=== FCM token registered ===');
    } catch (e) {
      debugPrint('=== Error registering FCM token: $e ===');
    }
  }

  static Future<void> deleteToken() async {
    await _messaging.deleteToken();
  }
}
