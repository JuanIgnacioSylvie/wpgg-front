import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/notifications_remote_datasource.dart';
import '../../domain/entities/inbox_notification.dart';

part 'notifications_inbox_event.dart';
part 'notifications_inbox_state.dart';

class NotificationsInboxBloc
    extends Bloc<NotificationsInboxEvent, NotificationsInboxState> {
  NotificationsInboxBloc(this._remote) : super(const NotificationsInboxInitial()) {
    on<LoadNotificationsInbox>(_onLoad);
    on<RefreshNotificationsInbox>(_onRefresh);
    on<MarkNotificationRead>(_onMarkRead);
    on<MarkAllNotificationsRead>(_onMarkAllRead);
    if (kIsWeb) {
      _pollTimer = Timer.periodic(
        const Duration(seconds: 20),
        (_) => add(const RefreshNotificationsInbox()),
      );
    }
  }

  final NotificationsRemoteDataSource _remote;
  Timer? _pollTimer;

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoad(
    LoadNotificationsInbox event,
    Emitter<NotificationsInboxState> emit,
  ) async {
    if (state is NotificationsInboxLoaded) {
      return;
    }
    emit(const NotificationsInboxLoading());
    await _fetch(emit);
  }

  Future<void> _onRefresh(
    RefreshNotificationsInbox event,
    Emitter<NotificationsInboxState> emit,
  ) async {
    await _fetch(emit, keepLoaded: state is NotificationsInboxLoaded);
  }

  Future<void> _fetch(
    Emitter<NotificationsInboxState> emit, {
    bool keepLoaded = false,
  }) async {
    try {
      final page = await _remote.fetchInbox();
      emit(
        NotificationsInboxLoaded(
          items: page.items,
          unreadCount: page.unreadCount,
        ),
      );
    } catch (e) {
      if (!keepLoaded) {
        emit(NotificationsInboxError(e.toString()));
      }
    }
  }

  Future<void> _onMarkRead(
    MarkNotificationRead event,
    Emitter<NotificationsInboxState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsInboxLoaded) return;

    final updatedItems = current.items
        .map(
          (n) => n.id == event.id ? n.markRead() : n,
        )
        .toList();
    final wasUnread = current.items.any(
      (n) => n.id == event.id && n.isUnread,
    );
    emit(
      current.copyWith(
        items: updatedItems,
        unreadCount: wasUnread
            ? (current.unreadCount - 1).clamp(0, 999)
            : current.unreadCount,
      ),
    );

    try {
      await _remote.markInboxRead(event.id);
    } catch (_) {
      emit(current);
    }
  }

  Future<void> _onMarkAllRead(
    MarkAllNotificationsRead event,
    Emitter<NotificationsInboxState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsInboxLoaded) return;

    emit(
      current.copyWith(
        items: current.items.map((n) => n.markRead()).toList(),
        unreadCount: 0,
      ),
    );

    try {
      await _remote.markAllInboxRead();
    } catch (_) {
      emit(current);
    }
  }
}
