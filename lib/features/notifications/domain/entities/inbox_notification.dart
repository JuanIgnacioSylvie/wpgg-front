class InboxNotification {
  const InboxNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.route,
    this.readAt,
  });

  final String id;
  final String type;
  final String title;
  final String body;
  final String? route;
  final DateTime? readAt;
  final DateTime createdAt;

  bool get isUnread => readAt == null;

  factory InboxNotification.fromJson(Map<String, dynamic> json) {
    return InboxNotification(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'GENERAL',
      title: json['title'] as String,
      body: json['body'] as String,
      route: json['route'] as String?,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  InboxNotification markRead() {
    if (!isUnread) return this;
    return InboxNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      route: route,
      readAt: DateTime.now(),
      createdAt: createdAt,
    );
  }
}

class InboxPage {
  const InboxPage({
    required this.items,
    required this.unreadCount,
    this.nextCursor,
  });

  final List<InboxNotification> items;
  final int unreadCount;
  final String? nextCursor;
}
