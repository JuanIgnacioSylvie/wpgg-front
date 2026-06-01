/// Global mission calendar (matches backend `WPGG_MISSION_TIMEZONE`).
abstract final class MissionDay {
  static const String timezone = 'UTC';
  static const String timezoneLabel = 'UTC';

  /// Start of today's mission day in UTC.
  static DateTime todayUtc() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day);
  }

  static String toApiDate(DateTime utcDay) {
    final y = utcDay.year.toString().padLeft(4, '0');
    final m = utcDay.month.toString().padLeft(2, '0');
    final d = utcDay.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static DateTime fromApiDate(String isoDate) {
    final parts = isoDate.split('-');
    return DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  static bool isSameMissionDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
