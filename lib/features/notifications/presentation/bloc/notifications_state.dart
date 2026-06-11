part of 'notifications_bloc.dart';

sealed class NotificationsState {
  const NotificationsState();
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading({required this.enabled});

  final bool enabled;
}

final class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({
    required this.enabled,
    this.errorMessage,
  });

  final bool enabled;
  final String? errorMessage;

  NotificationsLoaded copyWith({
    bool? enabled,
    String? errorMessage,
  }) {
    return NotificationsLoaded(
      enabled: enabled ?? this.enabled,
      errorMessage: errorMessage,
    );
  }
}
