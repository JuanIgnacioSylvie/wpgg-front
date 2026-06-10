import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';

class WebFilterChips extends StatefulWidget {
  const WebFilterChips({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<WebFilterChips> createState() => _WebFilterChipsState();
}

class _WebFilterChipsState extends State<WebFilterChips> {
  final _chipKeys = <GlobalKey>[];
  var _indicatorLeft = 0.0;
  var _indicatorWidth = 0.0;
  var _indicatorHeight = 36.0;

  @override
  void initState() {
    super.initState();
    _chipKeys.addAll(List.generate(widget.labels.length, (_) => GlobalKey()));
    SchedulerBinding.instance.addPostFrameCallback((_) => _updateIndicator());
  }

  @override
  void didUpdateWidget(WebFilterChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.labels.length != widget.labels.length) {
      _chipKeys
        ..clear()
        ..addAll(List.generate(widget.labels.length, (_) => GlobalKey()));
    }
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.labels.length != widget.labels.length) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _updateIndicator());
    }
  }

  void _updateIndicator() {
    if (!mounted) return;
    final index = widget.selectedIndex.clamp(0, _chipKeys.length - 1);
    final key = _chipKeys[index];
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final stackBox = context.findRenderObject() as RenderBox?;
    if (box == null || stackBox == null || !box.hasSize) return;

    final offset = box.localToGlobal(Offset.zero, ancestor: stackBox);
    setState(() {
      _indicatorLeft = offset.dx;
      _indicatorWidth = box.size.width;
      _indicatorHeight = box.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, _) {
        SchedulerBinding.instance.addPostFrameCallback((_) => _updateIndicator());
        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: WebMotion.resolve(context, WebMotion.normal),
              curve: WebMotion.curve,
              left: _indicatorLeft,
              top: 0,
              width: _indicatorWidth,
              height: _indicatorHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: WebColors.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: WebColors.accent.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.labels.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(right: i < widget.labels.length - 1 ? 8 : 0),
                  child: _FilterChip(
                    key: _chipKeys[i],
                    label: widget.labels[i],
                    selected: i == widget.selectedIndex,
                    onTap: () => widget.onSelected(i),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatefulWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final textColor =
        widget.selected ? WebColors.textPrimary : WebColors.textSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: WebMotion.resolve(context, WebMotion.fast),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered && !widget.selected
                ? WebColors.surfaceElevated.withValues(alpha: 0.6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedDefaultTextStyle(
            duration: WebMotion.resolve(context, WebMotion.fast),
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 13,
              fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
              color: textColor,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
