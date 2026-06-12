import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/firebase/firebase_bootstrap.dart';
import '../../data/datasources/notifications_remote_datasource.dart';
import '../../data/notifications_local_store.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(
    this._remote,
    this._local,
  ) : super(const NotificationsInitial()) {
    on<LoadNotificationPreference>(_onLoad);
    on<ToggleNotifications>(_onToggle);
    on<UnregisterPushOnLogout>(_onLogoutUnregister);
  }

  final NotificationsRemoteDataSource _remote;
  final NotificationsLocalStore _local;

  Future<void> _onLoad(
    LoadNotificationPreference event,
    Emitter<NotificationsState> emit,
  ) async {
    clearFcmRecoveryFlags();
    emit(NotificationsLoaded(enabled: _local.enabled));
  }

  Future<void> _onToggle(
    ToggleNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading(enabled: event.enabled));

    try {
      if (event.enabled) {
        if (!kIsWeb) {
          throw Exception('Push notifications are only available on web for now.');
        }

        clearFcmRecoveryFlags();
        final token = await fetchWebPushToken();
        if (token == null || token.isEmpty) {
          throw Exception('Notification permission denied or unavailable.');
        }

        await _remote.registerDevice(token: token, platform: 'web');
        await _local.setEnabled(true);
        await _local.setToken(token);
        emit(const NotificationsLoaded(enabled: true));
        return;
      }

      final token = _local.token;
      if (token != null && token.isNotEmpty) {
        try {
          await _remote.unregisterDevice(token: token);
        } catch (_) {
          // Session may already be invalid; still clear locally.
        }
        await deleteWebPushToken();
      }
      await _local.setEnabled(false);
      await _local.setToken(null);
      emit(const NotificationsLoaded(enabled: false));
    } catch (e) {
      emit(
        NotificationsLoaded(
          enabled: _local.enabled,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> unregisterPushToken() async {
    add(const UnregisterPushOnLogout());
    await stream.where((s) => s is NotificationsLoaded).first;
  }

  Future<void> _onLogoutUnregister(
    UnregisterPushOnLogout event,
    Emitter<NotificationsState> emit,
  ) async {
    final token = _local.token;
    if (token != null && token.isNotEmpty) {
      try {
        await _remote.unregisterDevice(token: token);
      } catch (_) {}
      await deleteWebPushToken();
    }
    await _local.setEnabled(false);
    await _local.setToken(null);
    emit(const NotificationsLoaded(enabled: false));
  }
}
