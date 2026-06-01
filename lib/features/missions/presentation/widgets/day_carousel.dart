import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: canTap ? () => onDateSelected(d) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 72,
                decoration: BoxDecoration(
                  color: isSelected
                      ? WpggBrand.primary
                      : WpggBrand.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM').format(d),
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? WpggBrand.white : Colors.black54,
                      ),
                    ),
                    Text(
                      DateFormat('d').format(d),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? WpggBrand.white : Colors.black87,
                      ),
                    ),
                    Text(
                      DateFormat('EEE').format(d),
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? WpggBrand.white : Colors.black54,
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
