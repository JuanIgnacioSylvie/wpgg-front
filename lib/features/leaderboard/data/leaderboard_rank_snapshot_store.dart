import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists last-seen leaderboard ranks locally to show rank deltas on revisit.
class LeaderboardRankSnapshotStore {
  LeaderboardRankSnapshotStore(this._prefs);

  static const _storageKey = 'leaderboard_rank_snapshot_v1';

  final SharedPreferences _prefs;

  static Future<LeaderboardRankSnapshotStore> create() async {
    return LeaderboardRankSnapshotStore(await SharedPreferences.getInstance());
  }

  Map<String, int> load() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      return decoded.map(
        (key, value) => MapEntry(
          key.toString(),
          value is num ? value.toInt() : int.tryParse('$value') ?? 0,
        ),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> save(Map<String, int> ranks) async {
    await _prefs.setString(_storageKey, jsonEncode(ranks));
  }

  Map<String, int> computeDeltas({
    required Map<String, int> previous,
    required List<({String userId, int rank})> current,
  }) {
    final deltas = <String, int>{};
    for (final row in current) {
      final prev = previous[row.userId];
      if (prev == null) continue;
      deltas[row.userId] = prev - row.rank;
    }
    return deltas;
  }
}
