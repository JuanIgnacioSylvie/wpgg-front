part of 'notifications_bloc.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

final class LoadNotificationPreference extends NotificationsEvent {
  const LoadNotificationPreference();
}

final class ToggleNotifications extends NotificationsEvent {
  const ToggleNotifications({required this.enabled});

  final bool enabled;
}

final class UnregisterPushOnLogout extends NotificationsEvent {
  const UnregisterPushOnLogout();
}
