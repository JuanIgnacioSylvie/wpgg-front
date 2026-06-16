/// Helpers for per-mission rolling countdowns (`endsAt` from API).
abstract final class MissionTimerUtils {
  static int? endsInSeconds(DateTime? endsAt) {
    if (endsAt == null) return null;
    final seconds =
        endsAt.toUtc().difference(DateTime.now().toUtc()).inSeconds;
    return seconds > 0 ? seconds : 0;
  }
}
