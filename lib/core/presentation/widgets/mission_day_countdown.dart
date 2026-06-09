import 'dart:async';

import 'package:flutter/material.dart';

/// Live countdown until the current mission day ends (HH:MM:SS).
class MissionDayCountdown extends StatefulWidget {
  const MissionDayCountdown({
    super.key,
    required this.initialSeconds,
    required this.labelBuilder,
    this.style,
  });

  final int initialSeconds;
  final String Function(String formattedTime) labelBuilder;
  final TextStyle? style;

  @override
  State<MissionDayCountdown> createState() => _MissionDayCountdownState();
}

class _MissionDayCountdownState extends State<MissionDayCountdown> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        }
      });
    });
  }

  @override
  void didUpdateWidget(MissionDayCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSeconds != widget.initialSeconds) {
      _remainingSeconds = widget.initialSeconds;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static String _formatDuration(int totalSeconds) {
    final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.labelBuilder(_formatDuration(_remainingSeconds)),
      style: widget.style,
    );
  }
}
