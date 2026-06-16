import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';

/// Live per-mission countdown shown on mission cards (`endsAt` from API).
class MissionCardCountdown extends StatefulWidget {
  const MissionCardCountdown({
    super.key,
    required this.endsAt,
    this.accentColor,
    this.fontSize = 11,
    this.useWebStyle = false,
  });

  final DateTime? endsAt;
  final Color? accentColor;
  final double fontSize;
  final bool useWebStyle;

  @override
  State<MissionCardCountdown> createState() => _MissionCardCountdownState();
}

class _MissionCardCountdownState extends State<MissionCardCountdown> {
  static const _criticalThresholdSeconds = 3600;

  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _secondsUntil(widget.endsAt);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds = _secondsUntil(widget.endsAt);
      });
    });
  }

  @override
  void didUpdateWidget(MissionCardCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endsAt != widget.endsAt) {
      _remainingSeconds = _secondsUntil(widget.endsAt);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _secondsUntil(DateTime? endsAt) {
    if (endsAt == null) return 0;
    final seconds =
        endsAt.toUtc().difference(DateTime.now().toUtc()).inSeconds;
    return seconds > 0 ? seconds : 0;
  }

  String _formatDuration(int totalSeconds) {
    final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.endsAt == null || _remainingSeconds <= 0) {
      return const SizedBox.shrink();
    }

    final isCritical = _remainingSeconds < _criticalThresholdSeconds;
    final accent = widget.accentColor ??
        (widget.useWebStyle ? WebColors.accent : WpggBrand.primary);
    final textColor = widget.useWebStyle
        ? (isCritical ? WebColors.accent : WebColors.textMuted)
        : (isCritical ? accent : Colors.black54);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.schedule_rounded,
          size: widget.fontSize + 1,
          color: isCritical ? accent : textColor,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            context.l10n.endsIn(_formatDuration(_remainingSeconds)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: textColor,
              fontSize: widget.fontSize,
              fontWeight: isCritical ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
