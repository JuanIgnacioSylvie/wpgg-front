import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import 'mission_shared_widgets.dart';

/// Mission title on the primary card (top-right). Underlines "day"/"día" and
/// toggles the Ends in tooltip when that word is tapped.
class MissionPrimaryDescription extends StatefulWidget {
  const MissionPrimaryDescription({
    super.key,
    required this.title,
    required this.accent,
    required this.endsInLabel,
    this.endsInSeconds,
  });

  final String title;
  final Color accent;
  final String Function(String formattedDuration) endsInLabel;
  final int? endsInSeconds;

  @override
  State<MissionPrimaryDescription> createState() =>
      _MissionPrimaryDescriptionState();
}

class _MissionPrimaryDescriptionState extends State<MissionPrimaryDescription> {
  bool _showEndsIn = false;
  TapGestureRecognizer? _dayTap;

  @override
  void dispose() {
    _dayTap?.dispose();
    super.dispose();
  }

  TextStyle get _titleStyle => const TextStyle(
        fontFamily: AppFonts.lexendDeca,
        color: WpggBrand.primary,
        fontWeight: FontWeight.w600,
        fontSize: 19,
        height: 1.35,
      );

  ({int start, int length})? _dayMatch(String title) {
    const keywords = ['día', 'dia', 'day'];
    final lower = title.toLowerCase();
    for (final kw in keywords) {
      final i = lower.indexOf(kw);
      if (i >= 0) {
        return (start: i, length: kw.length);
      }
    }
    return null;
  }

  void _onDayTap() {
    final hasTimer =
        widget.endsInSeconds != null && widget.endsInSeconds! > 0;
    if (!hasTimer) return;
    setState(() => _showEndsIn = !_showEndsIn);
  }

  @override
  Widget build(BuildContext context) {
    final base = _titleStyle;
    final match = _dayMatch(widget.title);
    final showTimer =
        widget.endsInSeconds != null && widget.endsInSeconds! > 0;

    InlineSpan textSpan;
    if (match == null) {
      textSpan = TextSpan(text: widget.title, style: base);
    } else {
      final start = match.start;
      final len = match.length;
      _dayTap?.dispose();
      _dayTap = TapGestureRecognizer()..onTap = _onDayTap;
      textSpan = TextSpan(
        children: [
          TextSpan(text: widget.title.substring(0, start), style: base),
          TextSpan(
            text: widget.title.substring(start, start + len),
            style: base.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: widget.accent,
              color: widget.accent,
            ),
            recognizer: showTimer ? _dayTap : null,
          ),
          TextSpan(
            text: widget.title.substring(start + len),
            style: base,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(text: textSpan),
        if (_showEndsIn && showTimer) ...[
          const SizedBox(height: 8),
          MissionEndsInTooltip(
            label: widget.endsInLabel(
              _formatDuration(Duration(seconds: widget.endsInSeconds!)),
            ),
          ),
        ],
      ],
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
