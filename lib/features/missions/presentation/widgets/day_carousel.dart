import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/utils/mission_day.dart';

class DayCarousel extends StatelessWidget {
  const DayCarousel({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.lockToToday = false,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool lockToToday;

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final today = MissionDay.todayUtc();
    final days = List.generate(
      5,
      (i) => today.add(Duration(days: i - 2)),
    );

    return SizedBox(
      height: 88,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: days.length,
        itemBuilder: (_, i) {
          final d = days[i];
          final isSelected = MissionDay.isSameMissionDay(d, selectedDate);
          final isToday = MissionDay.isSameMissionDay(d, today);
          final canTap = !lockToToday || isToday;
          final bgColor =
              isSelected ? WpggBrand.primary : WpggBrand.cardSurface;
          final textColor =
              isSelected ? WpggBrand.white : WpggBrand.cardTextDark;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: canTap ? () => onDateSelected(d) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 72,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _capitalize(DateFormat('MMM', locale).format(d)),
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        fontSize: 11,
                        color: textColor,
                      ),
                    ),
                    Text(
                      DateFormat('d').format(d),
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    Text(
                      _capitalize(DateFormat('EEE', locale).format(d)),
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        fontSize: 11,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
