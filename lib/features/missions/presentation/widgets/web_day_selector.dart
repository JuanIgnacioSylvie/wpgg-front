import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/utils/mission_day.dart';

class WebDaySelector extends StatelessWidget {
  const WebDaySelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final today = MissionDay.todayUtc();
    final days = List.generate(
      7,
      (i) => today.add(Duration(days: i - 3)),
    );

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final d = days[i];
          final isSelected = MissionDay.isSameMissionDay(d, selectedDate);
          final isToday = MissionDay.isSameMissionDay(d, today);

          return _DayChip(
            month: _capitalize(DateFormat('MMM', locale).format(d)),
            day: DateFormat('d').format(d),
            weekday: _capitalize(DateFormat('EEE', locale).format(d)),
            isSelected: isSelected,
            isToday: isToday,
            onTap: () => onDateSelected(d),
          );
        },
      ),
    );
  }
}

class _DayChip extends StatefulWidget {
  const _DayChip({
    required this.month,
    required this.day,
    required this.weekday,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final String month;
  final String day;
  final String weekday;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  State<_DayChip> createState() => _DayChipState();
}

class _DayChipState extends State<_DayChip> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isSelected
        ? WebColors.accent
        : (_hovered ? WebColors.border : WebColors.borderSubtle);
    final bg = widget.isSelected
        ? WebColors.surfaceElevated
        : (_hovered ? WebColors.surfaceElevated : WebColors.surface);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: widget.isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.month,
                style: TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  fontSize: 10,
                  color: widget.isSelected
                      ? WebColors.textPrimary
                      : WebColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.day,
                style: TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected
                      ? WebColors.textPrimary
                      : WebColors.textSecondary,
                ),
              ),
              Text(
                widget.isToday ? '•' : widget.weekday,
                style: TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  fontSize: widget.isToday ? 14 : 10,
                  fontWeight:
                      widget.isToday ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isToday
                      ? WebColors.accent
                      : (widget.isSelected
                          ? WebColors.textSecondary
                          : WebColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
