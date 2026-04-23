import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tradegenz_app/core/notifications/in_app_notification.dart';
import 'package:tradegenz_app/core/notifications/notification_store.dart';

class NotificationNotifier extends AsyncNotifier<List<InAppNotification>> {
  @override
  Future<List<InAppNotification>> build() async {
    return NotificationStore.getAll();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => NotificationStore.getAll());
  }

  Future<void> clearAll() async {
    await NotificationStore.clear();
    state = const AsyncData([]);
  }

  Future<void> markRead(String id) async {
    final current = state.asData?.value;
    if (current == null) return;

    final updated = current
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList();
    state = AsyncData(updated);
    await NotificationStore.markRead(id);
  }

  Future<void> markAllRead() async {
    final current = state.asData?.value;
    if (current == null) return;

    final updated = current.map((item) => item.copyWith(isRead: true)).toList();
    state = AsyncData(updated);
    await NotificationStore.markAllRead();
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationNotifier, List<InAppNotification>>(
      NotificationNotifier.new,
    );
