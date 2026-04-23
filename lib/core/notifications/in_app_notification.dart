class InAppNotification {
  final String id;
  final String title;
  final String body;
  final String? signalId;
  final DateTime receivedAt;
  final bool isRead;

  const InAppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.signalId,
    this.isRead = false,
  });

  InAppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? signalId,
    DateTime? receivedAt,
    bool? isRead,
  }) {
    return InAppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      signalId: signalId ?? this.signalId,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'signal_id': signalId,
      'received_at': receivedAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  factory InAppNotification.fromJson(Map<String, dynamic> json) {
    return InAppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      signalId: json['signal_id']?.toString(),
      receivedAt:
          DateTime.tryParse(json['received_at']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['is_read'] as bool? ?? false,
    );
  }
}
