import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../bloc/missions_bloc.dart';

class MissionSyncButton extends StatelessWidget {
  const MissionSyncButton({
    super.key,
    this.useWebStyle = false,
  });

  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<MissionsBloc, MissionsState>(
      buildWhen: (prev, curr) =>
          prev.missionSyncStatus != curr.missionSyncStatus,
      builder: (context, state) {
        final status = state.missionSyncStatus;
        if (status == MissionSyncUiStatus.hidden) {
          return const SizedBox.shrink();
        }

        final label = switch (status) {
          MissionSyncUiStatus.syncing => l10n.missionSyncSyncing,
          MissionSyncUiStatus.upToDate => l10n.missionSyncUpToDate,
          MissionSyncUiStatus.error => l10n.missionSyncRetry,
          _ => l10n.missionSyncUpdateNow,
        };

        final enabled = status == MissionSyncUiStatus.updatesAvailable ||
            status == MissionSyncUiStatus.error ||
            status == MissionSyncUiStatus.unknown;

        void onPressed() {
          if (!enabled) return;
          context.read<MissionsBloc>().add(const SyncMissionsNow());
        }

        if (useWebStyle) {
          return _WebMissionSyncChip(
            label: label,
            status: status,
            enabled: enabled,
            onPressed: onPressed,
          );
        }

        return _MobileMissionSyncChip(
          label: label,
          status: status,
          enabled: enabled,
          onPressed: onPressed,
        );
      },
    );
  }
}

class _WebMissionSyncChip extends StatelessWidget {
  const _WebMissionSyncChip({
    required this.label,
    required this.status,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final MissionSyncUiStatus status;
  final bool enabled;
  final VoidCallback onPressed;

  bool get _isReady =>
      status == MissionSyncUiStatus.updatesAvailable ||
      status == MissionSyncUiStatus.unknown ||
      status == MissionSyncUiStatus.error;

  bool get _isDone => status == MissionSyncUiStatus.upToDate;

  bool get _isSyncing => status == MissionSyncUiStatus.syncing;

  @override
  Widget build(BuildContext context) {
    final Color fg;
    final Color bg;
    final Color border;
    final List<BoxShadow>? shadow;

    if (_isReady) {
      fg = WebColors.accent;
      bg = WebColors.accent.withValues(alpha: 0.14);
      border = WebColors.accent.withValues(alpha: 0.55);
      shadow = [
        BoxShadow(
          color: WebColors.accent.withValues(alpha: 0.22),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];
    } else if (_isDone) {
      fg = WebColors.online;
      bg = WebColors.online.withValues(alpha: 0.1);
      border = WebColors.online.withValues(alpha: 0.35);
      shadow = null;
    } else if (_isSyncing) {
      fg = WebColors.textSecondary;
      bg = WebColors.surfaceElevated;
      border = WebColors.border;
      shadow = null;
    } else {
      fg = WebColors.textMuted;
      bg = WebColors.surfaceElevated;
      border = WebColors.border;
      shadow = null;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(999),
        hoverColor: _isReady
            ? WebColors.accent.withValues(alpha: 0.08)
            : WebColors.sidebarHover,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border, width: _isReady ? 1.5 : 1),
            boxShadow: shadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _WebSyncLeadingIcon(status: status),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  color: fg,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebSyncLeadingIcon extends StatelessWidget {
  const _WebSyncLeadingIcon({required this.status});

  final MissionSyncUiStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == MissionSyncUiStatus.syncing) {
      return SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: WebColors.textSecondary,
        ),
      );
    }

    if (status == MissionSyncUiStatus.upToDate) {
      return Icon(
        Icons.check_circle_rounded,
        size: 15,
        color: WebColors.online,
      );
    }

    if (status == MissionSyncUiStatus.error) {
      return Icon(
        Icons.refresh_rounded,
        size: 15,
        color: WebColors.accent,
      );
    }

    // updatesAvailable / unknown — pulsing dot + sync icon
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _PulseDot(),
        const SizedBox(width: 5),
        Icon(
          Icons.sync_rounded,
          size: 14,
          color: WebColors.accent,
        ),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: WebColors.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: WebColors.accent.withValues(alpha: 0.55),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileMissionSyncChip extends StatelessWidget {
  const _MobileMissionSyncChip({
    required this.label,
    required this.status,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final MissionSyncUiStatus status;
  final bool enabled;
  final VoidCallback onPressed;

  bool get _isReady =>
      status == MissionSyncUiStatus.updatesAvailable ||
      status == MissionSyncUiStatus.unknown ||
      status == MissionSyncUiStatus.error;

  bool get _isDone => status == MissionSyncUiStatus.upToDate;

  @override
  Widget build(BuildContext context) {
    final fg = _isDone
        ? const Color(0xFF86EFAC)
        : _isReady
            ? WpggBrand.white
            : WpggBrand.white.withValues(alpha: 0.55);
    final bg = _isReady
        ? WpggBrand.primary
        : _isDone
            ? const Color(0xFF22C55E).withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.08);
    final border = _isReady
        ? WpggBrand.primary
        : _isDone
            ? const Color(0xFF22C55E).withValues(alpha: 0.45)
            : Colors.white.withValues(alpha: 0.15);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border, width: _isReady ? 1.5 : 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == MissionSyncUiStatus.syncing)
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: fg,
                  ),
                )
              else if (_isDone)
                Icon(Icons.check_circle_rounded, size: 15, color: fg)
              else
                Icon(Icons.sync_rounded, size: 14, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Polls mission sync status while mounted (dashboard / home).
class MissionSyncStatusPoller extends StatefulWidget {
  const MissionSyncStatusPoller({super.key, required this.child});

  final Widget child;

  static const pollInterval = Duration(seconds: 90);

  @override
  State<MissionSyncStatusPoller> createState() =>
      _MissionSyncStatusPollerState();
}

class _MissionSyncStatusPollerState extends State<MissionSyncStatusPoller>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkStatus();
    }
  }

  void _checkStatus() {
    if (!mounted) return;
    context.read<MissionsBloc>().add(const CheckMissionSyncStatus());
  }

  @override
  Widget build(BuildContext context) {
    return _MissionSyncPollScope(
      onTick: _checkStatus,
      child: widget.child,
    );
  }
}

class _MissionSyncPollScope extends StatefulWidget {
  const _MissionSyncPollScope({
    required this.onTick,
    required this.child,
  });

  final VoidCallback onTick;
  final Widget child;

  @override
  State<_MissionSyncPollScope> createState() => _MissionSyncPollScopeState();
}

class _MissionSyncPollScopeState extends State<_MissionSyncPollScope> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(MissionSyncStatusPoller.pollInterval, _scheduleNext);
  }

  void _scheduleNext() {
    if (!mounted) return;
    widget.onTick();
    Future<void>.delayed(MissionSyncStatusPoller.pollInterval, _scheduleNext);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
