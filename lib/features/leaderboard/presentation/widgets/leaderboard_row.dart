import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../../../core/presentation/widgets/wpgg_summoner_identity_labels.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../profile/data/datasources/profile_remote_datasource.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../domain/leaderboard_helpers.dart';
import 'leaderboard_layout.dart';
import 'leaderboard_podium.dart' show leaderboardRankAccentOrNull;

class LeaderboardRow extends StatefulWidget {
  const LeaderboardRow({
    super.key,
    required this.entry,
    required this.summoner,
    required this.ddragon,
    required this.onTap,
    this.useWebStyle = false,
    this.gapToAbove,
    this.rankDelta,
    this.priceUsd,
    this.viewer,
    this.allEntries = const [],
    this.isViewer = false,
  });

  final LeaderboardEntry entry;
  final SummonerEntity summoner;
  final DDragonProvider? ddragon;
  final VoidCallback onTap;
  final bool useWebStyle;
  final int? gapToAbove;
  final int? rankDelta;
  final double? priceUsd;
  final LeaderboardViewerSnapshot? viewer;
  final List<LeaderboardEntry> allEntries;
  final bool isViewer;

  @override
  State<LeaderboardRow> createState() => _LeaderboardRowState();
}

class _LeaderboardRowState extends State<LeaderboardRow> {
  var _hovered = false;

  BoxDecoration _decoration() {
    final rankAccent = leaderboardRankAccentOrNull(widget.entry.rank);
    final radius = BorderRadius.circular(widget.useWebStyle ? 12 : 16);
    final highlightViewer = widget.isViewer;

    if (widget.useWebStyle) {
      return BoxDecoration(
        color: highlightViewer
            ? WebColors.accent.withValues(alpha: _hovered ? 0.1 : 0.06)
            : (_hovered ? WebColors.surfaceElevated : WebColors.surface),
        borderRadius: radius,
        border: Border.all(
          color: highlightViewer
              ? WebColors.accent.withValues(alpha: 0.45)
              : rankAccent != null
                  ? rankAccent.withValues(alpha: _hovered ? 0.5 : 0.32)
                  : (_hovered ? WebColors.border : WebColors.borderSubtle),
        ),
      );
    }

    return BoxDecoration(
      color: WpggBrand.cardSurface,
      borderRadius: radius,
      border: rankAccent != null
          ? Border.all(color: rankAccent.withValues(alpha: 0.35))
          : null,
    );
  }

  Widget _rankBadge(Color mutedColor) {
    final rankAccent = leaderboardRankAccentOrNull(widget.entry.rank);
    final rank = widget.entry.rank;
    final delta = widget.rankDelta;

    Widget badge;
    if (widget.entry.rank <= 3 && rankAccent != null) {
      badge = Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: rankAccent.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: rankAccent.withValues(alpha: 0.45)),
        ),
        child: Text(
          '$rank',
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: rankAccent,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      );
    } else {
      badge = SizedBox(
        width: 32,
        child: Text(
          '#$rank',
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: mutedColor,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      );
    }

    if (delta == null || delta == 0 || !widget.useWebStyle) return badge;

    final deltaColor = delta > 0 ? const Color(0xFF22C55E) : WebColors.accent;
    final deltaLabel = delta > 0
        ? context.l10n.leaderboardRankDeltaUp(delta)
        : context.l10n.leaderboardRankDeltaDown(delta.abs());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        const SizedBox(height: 2),
        Text(
          deltaLabel,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: deltaColor,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget? _middleStats(Color mutedColor, {required bool narrow}) {
    if (narrow) return null;

    final parts = <Widget>[];

    if (widget.gapToAbove != null && widget.gapToAbove! > 0) {
      parts.add(
        Text(
          context.l10n.leaderboardGapToRank(
            widget.gapToAbove!,
            widget.entry.rank - 1,
          ),
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: mutedColor,
            fontSize: 11,
          ),
        ),
      );
    }

    if (widget.viewer != null &&
        widget.viewer!.hasIdentity &&
        !widget.isViewer) {
      final diff = leaderboardCompareToViewer(
        entry: widget.entry,
        entries: widget.allEntries,
        viewer: widget.viewer!,
      );
      if (diff != 0) {
        parts.add(
          Text(
            context.l10n.leaderboardVsYou(diff),
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: diff > 0
                  ? const Color(0xFF22C55E)
                  : WebColors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    }

    if (parts.isEmpty) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < parts.length; i++) ...[
          if (i > 0) const SizedBox(height: 2),
          parts[i],
        ],
      ],
    );
  }

  Widget _balanceColumn({required Color textColor, required Color mutedColor}) {
    final balanceStyle = TextStyle(
      fontFamily: AppFonts.lexendDeca,
      color: textColor,
      fontWeight: FontWeight.w700,
      fontSize: widget.useWebStyle ? 14 : 15,
    );

    final balanceText = widget.useWebStyle
        ? WebAnimatedNumber(
            value: widget.entry.balanceWpgg,
            style: balanceStyle,
          )
        : Text(
            '${widget.entry.balanceWpgg}',
            style: balanceStyle,
          );

    final usd = widget.priceUsd == null
        ? null
        : widget.entry.balanceWpgg * widget.priceUsd!;

    if (widget.useWebStyle) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: WebColors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: WebColors.borderSubtle),
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
                balanceText,
              ],
            ),
          ),
          if (usd != null) ...[
            const SizedBox(height: 4),
            Text(
              context.l10n.balanceUsdEquivalent(formatLeaderboardUsd(usd)),
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: mutedColor,
                fontSize: 10,
              ),
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/wpgg-coin_24x24.png',
          width: 18,
          height: 18,
        ),
        const SizedBox(width: 6),
        balanceText,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        widget.useWebStyle ? WebColors.textPrimary : WpggBrand.cardTextDark;
    final mutedColor =
        widget.useWebStyle ? WebColors.textMuted : WpggBrand.textMuted;
    final avatarSize = widget.entry.rank <= 3 ? 44.0 : 40.0;
    final duration = WebMotion.resolve(context, WebMotion.fast);
    final narrow = leaderboardIsNarrowRow(context);
    final middle = _middleStats(mutedColor, narrow: narrow);

    final row = AnimatedContainer(
      duration: duration,
      curve: WebMotion.curve,
      decoration: _decoration(),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.useWebStyle ? 12 : 16),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.useWebStyle ? 12 : 16),
          hoverColor: widget.useWebStyle
              ? WebColors.sidebarHover.withValues(alpha: 0.35)
              : null,
          splashColor: widget.useWebStyle
              ? WebColors.accent.withValues(alpha: 0.08)
              : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.useWebStyle ? 16 : 16,
              vertical: widget.useWebStyle ? 14 : 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rankBadge(mutedColor),
                SizedBox(width: widget.useWebStyle ? 14 : 12),
                WpggProfileAvatar(
                  summoner: widget.summoner,
                  ddragon: widget.ddragon,
                  size: avatarSize,
                  enableHero: false,
                ),
                SizedBox(width: widget.useWebStyle ? 14 : 12),
                Expanded(
                  child: WpggSummonerIdentityLabels.fromSummoner(
                    widget.summoner,
                    useWebStyle: widget.useWebStyle,
                    showTagAndServer: true,
                    nameStyle: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: widget.useWebStyle ? 14 : 15,
                    ),
                  ),
                ),
                if (middle != null) ...[
                  const SizedBox(width: 12),
                  middle,
                  const SizedBox(width: 12),
                ] else
                  const SizedBox(width: 12),
                _balanceColumn(
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!widget.useWebStyle) {
      return row;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: row,
    );
  }
}
