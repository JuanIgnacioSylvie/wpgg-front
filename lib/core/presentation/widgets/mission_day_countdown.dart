import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/app_fonts.dart';
import '../web/web_colors.dart';
import '../web/web_motion.dart';

/// Live countdown until the current mission day ends (HH:MM:SS).
class MissionDayCountdown extends StatefulWidget {
  const MissionDayCountdown({
    super.key,
    required this.initialSeconds,
    required this.labelBuilder,
    this.style,
    this.showUrgencyContainer = false,
  });

  final int initialSeconds;
  final String Function(String formattedTime) labelBuilder;
  final TextStyle? style;
  final bool showUrgencyContainer;

  @override
  State<MissionDayCountdown> createState() => _MissionDayCountdownState();
}

class _MissionDayCountdownState extends State<MissionDayCountdown>
    with SingleTickerProviderStateMixin {
  static const totalDaySeconds = 86400;
  static const criticalThresholdSeconds = 3600;

  late int _remainingSeconds;
  Timer? _timer;
  AnimationController? _pulseController;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    if (widget.showUrgencyContainer) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
      );
      _syncPulseAnimation();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        }
      });
      _syncPulseAnimation();
    });
  }

  @override
  void didUpdateWidget(MissionDayCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSeconds != widget.initialSeconds) {
      _remainingSeconds = widget.initialSeconds;
      _syncPulseAnimation();
    }
    if (oldWidget.showUrgencyContainer != widget.showUrgencyContainer) {
      if (widget.showUrgencyContainer && _pulseController == null) {
        _pulseController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 900),
        );
        _syncPulseAnimation();
      } else if (!widget.showUrgencyContainer) {
        _pulseController?.dispose();
        _pulseController = null;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController?.dispose();
    super.dispose();
  }

  double get _urgency {
    final remaining = _remainingSeconds.clamp(0, totalDaySeconds);
    return (1 - remaining / totalDaySeconds).clamp(0.0, 1.0);
  }

  bool get _isCritical =>
      _remainingSeconds > 0 && _remainingSeconds < criticalThresholdSeconds;

  void _syncPulseAnimation() {
    final controller = _pulseController;
    if (controller == null) return;

    if (_isCritical && WebMotion.animationsEnabled(context)) {
      if (!controller.isAnimating) {
        controller.repeat(reverse: true);
      }
    } else {
      controller
        ..stop()
        ..value = 0;
    }
  }

  static String _formatDuration(int totalSeconds) {
    final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  TextStyle _resolveTextStyle({required Color textColor}) {
    final base = widget.style ??
        const TextStyle(
          fontFamily: AppFonts.lexendDeca,
          color: WebColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        );

    return base.copyWith(
      color: textColor,
      fontWeight: _isCritical ? FontWeight.w700 : base.fontWeight,
    );
  }

  Widget _buildLabel({required Color textColor}) {
    return Text(
      widget.labelBuilder(_formatDuration(_remainingSeconds)),
      style: _resolveTextStyle(textColor: textColor),
    );
  }

  BoxDecoration _urgencyDecoration({required double pulse}) {
    const accent = WebColors.accent;
    final urgency = _urgency;
    final isCritical = _isCritical;

    final bgColor = Color.lerp(
      WebColors.surface,
      accent.withValues(alpha: 0.88),
      isCritical ? 1.0 : urgency * 0.72,
    )!;

    final borderColor = Color.lerp(
      WebColors.borderSubtle,
      accent,
      isCritical ? 1.0 : urgency.clamp(0.0, 1.0),
    )!;

    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: borderColor,
        width: isCritical ? 1.5 : 1,
      ),
      boxShadow: isCritical
          ? [
              BoxShadow(
                color: accent.withValues(alpha: 0.25 + pulse * 0.35),
                blurRadius: 10 + pulse * 10,
                spreadRadius: pulse * 1.5,
              ),
            ]
          : urgency > 0.08
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: urgency * 0.22),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
    );
  }

  Color _urgencyTextColor() {
    if (_isCritical) return Colors.white;

    return Color.lerp(
      WebColors.textSecondary,
      WebColors.accent,
      _urgency * 0.9,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showUrgencyContainer) {
      return _buildLabel(textColor: widget.style?.color ?? WebColors.textSecondary);
    }

    final textColor = _urgencyTextColor();
    final urgency = _urgency;
    final controller = _pulseController;

    Widget container({required double pulse}) {
      return AnimatedContainer(
        duration: WebMotion.resolve(context, WebMotion.normal),
        curve: WebMotion.curve,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: _urgencyDecoration(pulse: pulse),
        child: _buildLabel(textColor: textColor),
      );
    }

    if (_isCritical && controller != null) {
      return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final pulse = Curves.easeInOut.transform(controller.value);
          return Transform.scale(
            scale: 1 + pulse * 0.035,
            child: container(pulse: pulse),
          );
        },
      );
    }

    return container(pulse: urgency > 0.5 ? 0.15 : 0);
  }
}
