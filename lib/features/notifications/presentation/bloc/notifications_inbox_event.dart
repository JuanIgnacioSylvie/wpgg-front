part of 'notifications_inbox_bloc.dart';

sealed class NotificationsInboxEvent {
  const NotificationsInboxEvent();
}

final class LoadNotificationsInbox extends NotificationsInboxEvent {
  const LoadNotificationsInbox();
}

final class RefreshNotificationsInbox extends NotificationsInboxEvent {
  const RefreshNotificationsInbox();
}

final class MarkNotificationRead extends NotificationsInboxEvent {
  const MarkNotificationRead(this.id);

  final String id;
}

final class MarkAllNotificationsRead extends NotificationsInboxEvent {
  const MarkAllNotificationsRead();
}
