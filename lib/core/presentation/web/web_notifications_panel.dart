import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_fonts.dart';
import '../../l10n/l10n_extension.dart';
import '../../../features/notifications/domain/entities/inbox_notification.dart';
import '../../../features/notifications/presentation/bloc/notifications_inbox_bloc.dart';
import '../../../l10n/app_localizations.dart';
import 'web_colors.dart';
import 'web_motion.dart';

/// Full-screen overlay layer: subtle barrier + panel anchored beside the bell.
class WebNotificationsPanelLayer extends StatelessWidget {
  const WebNotificationsPanelLayer({
    super.key,
    required this.animation,
    required this.anchorRect,
    required this.onClose,
    required this.bloc,
  });

  final Animation<double> animation;
  final Rect anchorRect;
  final VoidCallback onClose;
  final NotificationsInboxBloc bloc;

  static const _panelWidth = 320.0;
  static const _panelMaxHeight = 420.0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final panelLeft = anchorRect.right + 10;
    final panelHeight = math.min(
      _panelMaxHeight,
      media.height - anchorRect.top - 16,
    );
    final panelTop = math.max(16.0, anchorRect.bottom - panelHeight);

    final curved = CurvedAnimation(parent: animation, curve: WebMotion.curve);

    return Stack(
      children: [
        Positioned.fill(
          child: FadeTransition(
            opacity: curved,
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black.withValues(alpha: 0.12),
              ),
            ),
          ),
        ),
        Positioned(
          left: panelLeft,
          top: panelTop,
          width: _panelWidth,
          height: panelHeight,
          child: FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-0.04, 0),
                end: Offset.zero,
              ).animate(curved),
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: WebMotion.scaleEnter,
                  end: 1,
                ).animate(curved),
                alignment: Alignment.bottomLeft,
                child: Material(
                  color: Colors.transparent,
                  child: BlocProvider.value(
                    value: bloc,
                    child: _WebNotificationsPanel(onClose: onClose),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WebNotificationsPanel extends StatelessWidget {
  const _WebNotificationsPanel({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WebColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PanelHeader(onClose: onClose),
            const Divider(height: 1, color: WebColors.borderSubtle),
            Expanded(
              child: BlocBuilder<NotificationsInboxBloc, NotificationsInboxState>(
                builder: (context, state) {
                  return switch (state) {
                    NotificationsInboxInitial() ||
                    NotificationsInboxLoading() =>
                      const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: WebColors.textMuted,
                          ),
                        ),
                      ),
                    NotificationsInboxError(:final message) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppFonts.lexendDeca,
                              color: WebColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    NotificationsInboxLoaded(:final items, :final unreadCount) =>
                      items.isEmpty
                          ? _EmptyState(message: l10n.notificationsInboxEmpty)
                          : _NotificationList(
                              items: items,
                              unreadCount: unreadCount,
                              onClose: onClose,
                            ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.navNotifications,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WebColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          BlocBuilder<NotificationsInboxBloc, NotificationsInboxState>(
            buildWhen: (prev, curr) =>
                prev is NotificationsInboxLoaded &&
                curr is NotificationsInboxLoaded &&
                prev.unreadCount != curr.unreadCount,
            builder: (context, state) {
              if (state is! NotificationsInboxLoaded || state.unreadCount == 0) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () {
                  context
                      .read<NotificationsInboxBloc>()
                      .add(const MarkAllNotificationsRead());
                },
                style: TextButton.styleFrom(
                  foregroundColor: WebColors.textSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.notificationsMarkAllRead,
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 18, color: WebColors.textMuted),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              size: 32,
              color: WebColors.textMuted.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WebColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({
    required this.items,
    required this.unreadCount,
    required this.onClose,
  });

  final List<InboxNotification> items;
  final int unreadCount;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        indent: 14,
        endIndent: 14,
        color: WebColors.borderSubtle,
      ),
      itemBuilder: (context, index) {
        return _NotificationTile(
          notification: items[index],
          staggerIndex: index,
          onTap: () => _onTap(context, items[index]),
        );
      },
    );
  }

  void _onTap(BuildContext context, InboxNotification notification) {
    final bloc = context.read<NotificationsInboxBloc>();
    if (notification.isUnread) {
      bloc.add(MarkNotificationRead(notification.id));
    }
    final route = notification.route;
    if (route != null && route.isNotEmpty) {
      onClose();
      context.go(route);
    }
  }
}

class _NotificationTile extends StatefulWidget {
  const _NotificationTile({
    required this.notification,
    required this.staggerIndex,
    required this.onTap,
  });

  final InboxNotification notification;
  final int staggerIndex;
  final VoidCallback onTap;

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.notification;
    final l10n = context.l10n;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: _hovered
            ? WebColors.sidebarHover.withValues(alpha: 0.65)
            : n.isUnread
                ? WebColors.surfaceElevated.withValues(alpha: 0.35)
                : Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: _TypeIcon(type: n.type, isUnread: n.isUnread),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppFonts.lexendDeca,
                                color: WebColors.textPrimary,
                                fontSize: 13,
                                fontWeight: n.isUnread
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            _relative(l10n, n.createdAt),
                            style: const TextStyle(
                              fontFamily: AppFonts.lexendDeca,
                              color: WebColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        n.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: WebColors.textSecondary,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _relative(AppLocalizations l10n, DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.isNegative || diff.inMinutes < 1) return l10n.timeAgoJustNow;
    if (diff.inMinutes < 60) return l10n.timeAgoMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeAgoHours(diff.inHours);
    return l10n.timeAgoDays(diff.inDays);
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type, required this.isUnread});

  final String type;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      'MISSION_COMPLETED' => Icons.emoji_events_outlined,
      'TEST' => Icons.notifications_active_outlined,
      _ => Icons.notifications_none_outlined,
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, size: 18, color: WebColors.textSecondary),
        if (isUnread)
          Positioned(
            right: -3,
            top: -3,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: WebColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

Rect? notificationsPanelAnchorRect(GlobalKey anchorKey) {
  final renderBox =
      anchorKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null || !renderBox.hasSize) return null;
  final offset = renderBox.localToGlobal(Offset.zero);
  return offset & renderBox.size;
}
