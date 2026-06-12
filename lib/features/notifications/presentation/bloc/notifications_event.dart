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

/// Re-syncs the FCM token with the API after login or page reload (web only).
final class ResumeWebPushRegistration extends NotificationsEvent {
  const ResumeWebPushRegistration();
}
