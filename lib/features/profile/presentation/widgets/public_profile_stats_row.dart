import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../data/datasources/profile_remote_datasource.dart';

class PublicProfileStatsRow extends StatelessWidget {
  const PublicProfileStatsRow({
    super.key,
    required this.profile,
    this.useWebStyle = true,
  });

  final PublicUserProfile profile;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accent = useWebStyle ? WebColors.accent : WpggBrand.primary;
    final surface =
        useWebStyle ? WebColors.surfaceElevated : WpggBrand.cardSurface;
    final border = useWebStyle
        ? WebColors.borderSubtle
        : WpggBrand.textMuted.withValues(alpha: 0.25);
    final labelColor = useWebStyle ? WebColors.textMuted : WpggBrand.textMuted;
    final valueColor = useWebStyle ? WebColors.textPrimary : WpggBrand.white;

    final stats = <({String label, String value})>[
      if (profile.leaderboardRank > 0)
        (
          label: l10n.profileLeaderboardRankLabel,
          value: '#${profile.leaderboardRank}',
        ),
      (
        label: l10n.profileCompletedMissionsLabel,
        value: '${profile.completedMissionsCount}',
      ),
      if (profile.gapToAbove != null && profile.gapToAbove! > 0)
        (
          label: l10n.profileGapToAboveLabel,
          value: l10n.leaderboardGapToRank(
            profile.gapToAbove!,
            profile.leaderboardRank - 1,
          ),
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        final cards = stats
            .map(
              (stat) => _StatCard(
                label: stat.label,
                value: stat.value,
                surface: surface,
                border: border,
                labelColor: labelColor,
                valueColor: valueColor,
                accent: accent,
                fullWidth: compact,
              ),
            )
            .toList();

        if (compact) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                cards[i],
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(child: cards[i]),
            ],
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.surface,
    required this.border,
    required this.labelColor,
    required this.valueColor,
    required this.accent,
    required this.fullWidth,
  });

  final String label;
  final String value;
  final Color surface;
  final Color border;
  final Color labelColor;
  final Color valueColor;
  final Color accent;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(
        horizontal: fullWidth ? 14 : 12,
        vertical: fullWidth ? 12 : 10,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: labelColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: valueColor,
              fontSize: fullWidth ? 13 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
