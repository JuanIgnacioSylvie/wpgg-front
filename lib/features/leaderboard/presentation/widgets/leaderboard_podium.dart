import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../../../core/presentation/widgets/wpgg_card_elevation.dart';
import '../../../../core/presentation/widgets/wpgg_summoner_identity_labels.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../profile/data/datasources/profile_remote_datasource.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../domain/leaderboard_helpers.dart';

Color? leaderboardRankAccentOrNull(int rank) {
  switch (rank) {
    case 1:
      return const Color(0xFFEAB308);
    case 2:
      return const Color(0xFF94A3B8);
    case 3:
      return const Color(0xFFD97706);
    default:
      return null;
  }
}

Color leaderboardRankAccent(int rank) {
  return leaderboardRankAccentOrNull(rank) ?? WebColors.textMuted;
}

class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({
    super.key,
    required this.entries,
    required this.ddragon,
    required this.priceUsd,
    required this.onTap,
    this.useWebStyle = true,
  });

  final List<LeaderboardEntry> entries;
  final DDragonProvider? ddragon;
  final double? priceUsd;
  final ValueChanged<LeaderboardEntry> onTap;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final ordered = <LeaderboardEntry?>[
      _entryForRank(entries, 2),
      _entryForRank(entries, 1),
      _entryForRank(entries, 3),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        if (compact) {
          return Column(
            children: [
              for (final entry in entries.where((e) => e.rank <= 3)) ...[
                _PodiumCard(
                  entry: entry,
                  ddragon: ddragon,
                  priceUsd: priceUsd,
                  onTap: () => onTap(entry),
                  useWebStyle: useWebStyle,
                  elevated: entry.rank == 1,
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < ordered.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: ordered[i] == null
                    ? const SizedBox.shrink()
                    : _PodiumCard(
                        entry: ordered[i]!,
                        ddragon: ddragon,
                        priceUsd: priceUsd,
                        onTap: () => onTap(ordered[i]!),
                        useWebStyle: useWebStyle,
                        elevated: ordered[i]!.rank == 1,
                      ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _PodiumCard extends StatefulWidget {
  const _PodiumCard({
    required this.entry,
    required this.ddragon,
    required this.priceUsd,
    required this.onTap,
    required this.useWebStyle,
    required this.elevated,
  });

  final LeaderboardEntry entry;
  final DDragonProvider? ddragon;
  final double? priceUsd;
  final VoidCallback onTap;
  final bool useWebStyle;
  final bool elevated;

  @override
  State<_PodiumCard> createState() => _PodiumCardState();
}

class _PodiumCardState extends State<_PodiumCard> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = leaderboardRankAccent(widget.entry.rank);
    final summoner = SummonerEntity(
      gameName: widget.entry.gameName,
      tagLine: widget.entry.tagLine,
      region: widget.entry.region,
      profileIconId: widget.entry.profileIconId,
      puuid: '',
      summonerLevel: 0,
    );
    final usd = widget.priceUsd == null
        ? null
        : widget.entry.balanceWpgg * widget.priceUsd!;
    final duration = WebMotion.resolve(context, WebMotion.fast);

    final surface = _hovered ? WebColors.surfaceElevated : WebColors.surface;

    final card = AnimatedContainer(
      duration: duration,
      curve: WebMotion.curve,
      padding: EdgeInsets.fromLTRB(16, widget.elevated ? 22 : 16, 16, 16),
      decoration: widget.useWebStyle
          ? WpggCardElevation.enhance(
              BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: accent.withValues(alpha: _hovered ? 0.45 : 0.3),
                ),
              ),
              variant: WpggCardElevationVariant.dark,
              hovered: _hovered,
              accentColor: accent,
              baseColor: surface,
            )
          : WpggCardElevation.enhance(
              BoxDecoration(
                color: WpggBrand.cardSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: accent.withValues(alpha: _hovered ? 0.45 : 0.3),
                ),
              ),
              hovered: _hovered,
              accentColor: accent,
              baseColor: WpggBrand.cardSurface,
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(14),
          hoverColor: WebColors.sidebarHover.withValues(alpha: 0.3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accent.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '${widget.entry.rank}',
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              WpggProfileAvatar(
                summoner: summoner,
                ddragon: widget.ddragon,
                size: widget.elevated ? 64 : 52,
                enableHero: false,
              ),
              const SizedBox(height: 10),
              WpggSummonerIdentityLabels.fromSummoner(
                summoner,
                useWebStyle: widget.useWebStyle,
                showTagAndServer: true,
                crossAxisAlignment: CrossAxisAlignment.center,
                nameStyle: TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  color: WebColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: widget.elevated ? 15 : 13,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/wpgg-coin_24x24.png',
                    width: 18,
                    height: 18,
                    filterQuality: FilterQuality.high,
                  ),
                  const SizedBox(width: 6),
                  WebAnimatedNumber(
                    value: widget.entry.balanceWpgg,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WebColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              if (usd != null) ...[
                const SizedBox(height: 4),
                Text(
                  context.l10n.balanceUsdEquivalent(
                    formatLeaderboardUsd(usd),
                  ),
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: WebColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!widget.useWebStyle) return card;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: card,
    );
  }
}

LeaderboardEntry? _entryForRank(List<LeaderboardEntry> entries, int rank) {
  for (final entry in entries) {
    if (entry.rank == rank) return entry;
  }
  return null;
}
