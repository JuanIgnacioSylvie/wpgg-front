import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/presentation/web/web_colors.dart';

class WebFilterChips extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(labels.length, (i) {
        return _FilterChip(
          label: labels[i],
          selected: i == selectedIndex,
          onTap: () => onSelected(i),
        );
      }),
    );
  }
}

class _FilterChip extends StatefulWidget {
  const _FilterChip({
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
    final bg = widget.selected
        ? WebColors.accent.withValues(alpha: 0.14)
        : (_hovered ? WebColors.surfaceElevated : WebColors.surface);
    final border = widget.selected
        ? WebColors.accent.withValues(alpha: 0.6)
        : (_hovered ? WebColors.border : WebColors.borderSubtle);
    final textColor =
        widget.selected ? WebColors.textPrimary : WebColors.textSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 13,
              fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
