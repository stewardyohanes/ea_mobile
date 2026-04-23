import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradegenz_app/core/notifications/in_app_notification.dart';

class NotificationStore {
  NotificationStore._();

  static const _storageKey = 'tradegenz.notifications.v1';
  static const _maxItems = 100;

  static Future<List<InAppNotification>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final rawItems = prefs.getStringList(_storageKey) ?? [];
    final notifications = <InAppNotification>[];

    for (final item in rawItems) {
      try {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        notifications.add(InAppNotification.fromJson(decoded));
      } catch (_) {
        // Skip broken entries to keep storage resilient.
      }
    }

    notifications.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    return notifications;
  }

  static Future<void> upsert(InAppNotification notification) async {
    final notifications = await getAll();
    final index = notifications.indexWhere((n) => n.id == notification.id);

    if (index != -1) {
      final current = notifications[index];
      notifications[index] = notification.copyWith(
        isRead: current.isRead || notification.isRead,
      );
    } else {
      notifications.add(notification);
    }

    notifications.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    await _save(notifications);
  }

  static Future<void> markRead(String id) async {
    final notifications = await getAll();
    final updated = notifications
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList();
    await _save(updated);
  }

  static Future<void> markReadBySignalId(String signalId) async {
    final notifications = await getAll();
    final updated = notifications
        .map(
          (item) =>
              item.signalId == signalId ? item.copyWith(isRead: true) : item,
        )
        .toList();
    await _save(updated);
  }

  static Future<void> markAllRead() async {
    final notifications = await getAll();
    final updated = notifications
        .map((item) => item.copyWith(isRead: true))
        .toList();
    await _save(updated);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  static Future<void> _save(List<InAppNotification> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = notifications
        .take(_maxItems)
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await prefs.setStringList(_storageKey, encoded);
  }
}
