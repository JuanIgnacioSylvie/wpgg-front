part of 'notifications_inbox_bloc.dart';

sealed class NotificationsInboxState {
  const NotificationsInboxState();
}

final class NotificationsInboxInitial extends NotificationsInboxState {
  const NotificationsInboxInitial();
}

final class NotificationsInboxLoading extends NotificationsInboxState {
  const NotificationsInboxLoading();
}

final class NotificationsInboxLoaded extends NotificationsInboxState {
  const NotificationsInboxLoaded({
    required this.items,
    required this.unreadCount,
  });

  final List<InboxNotification> items;
  final int unreadCount;

  NotificationsInboxLoaded copyWith({
    List<InboxNotification>? items,
    int? unreadCount,
  }) {
    return NotificationsInboxLoaded(
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

final class NotificationsInboxError extends NotificationsInboxState {
  const NotificationsInboxError(this.message);

  final String message;
}
