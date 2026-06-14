import '../../profile/data/datasources/profile_remote_datasource.dart';

enum LeaderboardListMode { full, nearMe }

class LeaderboardViewerSnapshot {
  const LeaderboardViewerSnapshot({
    this.userId,
    this.balanceWpgg = 0,
  });

  final String? userId;
  final int balanceWpgg;

  bool get hasIdentity => userId != null && userId!.isNotEmpty;
}

class LeaderboardViewerRank {
  const LeaderboardViewerRank({
    required this.rank,
    required this.inList,
    this.entry,
    this.gapToAbove,
    this.gapToLeader,
    this.totalPlayers = 0,
  });

  final int rank;
  final bool inList;
  final LeaderboardEntry? entry;
  final int? gapToAbove;
  final int? gapToLeader;
  final int totalPlayers;
}

LeaderboardViewerRank leaderboardViewerRankFromPayload(
  LeaderboardViewerPayload payload, {
  LeaderboardEntry? entry,
}) {
  return LeaderboardViewerRank(
    rank: payload.rank,
    inList: payload.inTop,
    entry: entry,
    gapToAbove: payload.gapToAbove,
    gapToLeader: payload.gapToLeader,
    totalPlayers: payload.totalPlayers,
  );
}

List<String> leaderboardDistinctRegions(List<LeaderboardEntry> entries) {
  final regions = entries
      .map((e) => e.region.trim().toUpperCase())
      .where((r) => r.isNotEmpty)
      .toSet()
      .toList()
    ..sort();
  return regions;
}

List<LeaderboardEntry> leaderboardFilterByRegion(
  List<LeaderboardEntry> entries,
  String? region,
) {
  if (region == null || region.isEmpty) return entries;
  final code = region.trim().toUpperCase();
  return entries.where((e) => e.region.trim().toUpperCase() == code).toList();
}

LeaderboardEntry? leaderboardFindByUserId(
  List<LeaderboardEntry> entries,
  String? userId,
) {
  if (userId == null || userId.isEmpty) return null;
  for (final entry in entries) {
    if (entry.userId == userId) return entry;
  }
  return null;
}

List<LeaderboardEntry> leaderboardSliceNearViewer({
  required List<LeaderboardEntry> entries,
  required LeaderboardViewerRank viewerRank,
  int radius = 3,
}) {
  if (entries.isEmpty) return const [];

  final center = viewerRank.inList
      ? viewerRank.rank
      : viewerRank.rank.clamp(1, entries.length + 1);

  final minRank = (center - radius).clamp(1, entries.length);
  final maxRank = (center + radius).clamp(1, entries.length);

  return entries
      .where((e) => e.rank >= minRank && e.rank <= maxRank)
      .toList(growable: false);
}

({List<LeaderboardEntry> podium, List<LeaderboardEntry> rest})
    leaderboardSplitPodium(List<LeaderboardEntry> entries) {
  final podium = entries.where((e) => e.rank <= 3).toList(growable: false);
  final rest = entries.where((e) => e.rank > 3).toList(growable: false);
  return (podium: podium, rest: rest);
}

int? leaderboardGapToRankAbove(
  LeaderboardEntry entry,
  List<LeaderboardEntry> entries,
) {
  if (entry.rank <= 1) return null;
  final above = entries.cast<LeaderboardEntry?>().firstWhere(
        (e) => e!.rank == entry.rank - 1,
        orElse: () => null,
      );
  if (above == null) return null;
  return (above.balanceWpgg - entry.balanceWpgg).clamp(0, 1 << 30);
}

int viewerBaselineBalance({
  required List<LeaderboardEntry> entries,
  required LeaderboardViewerSnapshot viewer,
}) {
  final listed = leaderboardFindByUserId(entries, viewer.userId);
  if (listed != null) return listed.balanceWpgg;
  return viewer.balanceWpgg;
}

int leaderboardCompareToViewer({
  required LeaderboardEntry entry,
  required List<LeaderboardEntry> entries,
  required LeaderboardViewerSnapshot viewer,
}) {
  final baseline = viewerBaselineBalance(entries: entries, viewer: viewer);
  return entry.balanceWpgg - baseline;
}

String formatLeaderboardUsd(double usd) {
  if (usd <= 0) return '—';
  if (usd >= 1) return '\$${usd.toStringAsFixed(2)}';
  if (usd >= 0.01) return '\$${usd.toStringAsFixed(4)}';
  return '\$${usd.toStringAsFixed(6)}';
}
