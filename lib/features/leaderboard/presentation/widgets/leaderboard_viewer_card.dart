import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/widgets/wpgg_summoner_identity_labels.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../profile/data/datasources/profile_remote_datasource.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../domain/leaderboard_helpers.dart';
import 'leaderboard_layout.dart';
import 'leaderboard_podium.dart' show leaderboardRankAccent;

class LeaderboardViewerCard extends StatelessWidget {
  const LeaderboardViewerCard({
    super.key,
    required this.viewerRank,
    required this.viewer,
    required this.allEntries,
    required this.ddragon,
    required this.priceUsd,
    this.useWebStyle = true,
  });

  final LeaderboardViewerRank viewerRank;
  final LeaderboardViewerSnapshot viewer;
  final List<LeaderboardEntry> allEntries;
  final DDragonProvider? ddragon;
  final double? priceUsd;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    if (!viewer.hasIdentity || viewerRank.rank <= 0) {
      return const SizedBox.shrink();
    }

    final entry = viewerRank.entry;
    final balance = entry?.balanceWpgg ?? viewer.balanceWpgg;
    final summoner = entry != null
        ? SummonerEntity(
            gameName: entry.gameName,
            tagLine: entry.tagLine,
            region: entry.region,
            profileIconId: entry.profileIconId,
            puuid: '',
            summonerLevel: 0,
          )
        : null;

    final gapToAbove = viewerRank.gapToAbove;
    final gapToLeader = viewerRank.gapToLeader;
    final usd = priceUsd == null ? null : balance * priceUsd!;
    final compact = leaderboardIsCompact(context);

    final accent = useWebStyle ? WebColors.accent : WpggBrand.primary;
    final surface =
        useWebStyle ? WebColors.surfaceElevated : WpggBrand.cardSurface;
    final border = accent.withValues(alpha: 0.35);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(
                  summoner: summoner,
                  useWebStyle: useWebStyle,
                  viewerRank: viewerRank,
                  gapToAbove: gapToAbove,
                  gapToLeader: gapToLeader,
                ),
                const SizedBox(height: 14),
                _BalanceSide(
                  balance: balance,
                  usd: usd,
                  viewerRank: viewerRank,
                  useWebStyle: useWebStyle,
                  alignEnd: false,
                ),
              ],
            )
          : Row(
              children: [
                if (summoner != null) ...[
                  WpggProfileAvatar(
                    summoner: summoner,
                    ddragon: ddragon,
                    size: 44,
                    enableHero: false,
                  ),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: _Header(
                    summoner: summoner,
                    useWebStyle: useWebStyle,
                    viewerRank: viewerRank,
                    gapToAbove: gapToAbove,
                    gapToLeader: gapToLeader,
                  ),
                ),
                _BalanceSide(
                  balance: balance,
                  usd: usd,
                  viewerRank: viewerRank,
                  useWebStyle: useWebStyle,
                  alignEnd: true,
                ),
              ],
            ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.summoner,
    required this.useWebStyle,
    required this.viewerRank,
    required this.gapToAbove,
    required this.gapToLeader,
  });

  final SummonerEntity? summoner;
  final bool useWebStyle;
  final LeaderboardViewerRank viewerRank;
  final int? gapToAbove;
  final int? gapToLeader;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final muted = useWebStyle ? WebColors.textMuted : WpggBrand.textMuted;
    final secondary =
        useWebStyle ? WebColors.textSecondary : WpggBrand.textMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.leaderboardYourPosition,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: muted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        if (summoner != null)
          WpggSummonerIdentityLabels.fromSummoner(
            summoner!,
            useWebStyle: useWebStyle,
            showTagAndServer: true,
          ),
        const SizedBox(height: 6),
        Text(
          viewerRank.inList
              ? l10n.leaderboardRankOf(
                  viewerRank.rank,
                  viewerRank.totalPlayers > 0
                      ? viewerRank.totalPlayers
                      : viewerRank.rank,
                )
              : l10n.leaderboardOutsideTop(
                  viewerRank.totalPlayers > 0 ? viewerRank.totalPlayers : 50,
                ),
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: secondary,
            fontSize: 12,
          ),
        ),
        if (gapToAbove != null && gapToAbove! > 0) ...[
          const SizedBox(height: 2),
          Text(
            l10n.leaderboardGapToRank(gapToAbove!, viewerRank.rank - 1),
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: muted,
              fontSize: 11,
            ),
          ),
        ] else if (!viewerRank.inList && gapToLeader != null && gapToLeader! > 0) ...[
          const SizedBox(height: 2),
          Text(
            l10n.leaderboardGapFromLeader(gapToLeader!),
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: muted,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}

class _BalanceSide extends StatelessWidget {
  const _BalanceSide({
    required this.balance,
    required this.usd,
    required this.viewerRank,
    required this.useWebStyle,
    required this.alignEnd,
  });

  final int balance;
  final double? usd;
  final LeaderboardViewerRank viewerRank;
  final bool useWebStyle;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chipBg =
        useWebStyle ? WebColors.surface : WpggBrand.cardSurface;
    final chipBorder = useWebStyle
        ? WebColors.borderSubtle
        : WpggBrand.textMuted.withValues(alpha: 0.25);
    final textColor =
        useWebStyle ? WebColors.textPrimary : WpggBrand.cardTextDark;
    final muted = useWebStyle ? WebColors.textMuted : WpggBrand.textMuted;

    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: chipBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/wpgg-coin_24x24.png',
                width: 16,
                height: 16,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(width: 6),
              useWebStyle
                  ? WebAnimatedNumber(
                      value: balance,
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        color: textColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    )
                  : Text(
                      '$balance',
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        color: textColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
            ],
          ),
        ),
        if (usd != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.balanceUsdEquivalent(formatLeaderboardUsd(usd!)),
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: muted,
              fontSize: 11,
            ),
          ),
        ],
        if (viewerRank.inList) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: leaderboardRankAccent(viewerRank.rank)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: leaderboardRankAccent(viewerRank.rank)
                    .withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              '#${viewerRank.rank}',
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: leaderboardRankAccent(viewerRank.rank),
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
