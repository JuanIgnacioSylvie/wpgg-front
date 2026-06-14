import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/utils/riot_region_label.dart';
import '../../domain/leaderboard_helpers.dart';

class LeaderboardControls extends StatelessWidget {
  const LeaderboardControls({
    super.key,
    required this.regions,
    required this.selectedRegion,
    required this.onRegionChanged,
    required this.listMode,
    required this.onListModeChanged,
    this.useWebStyle = true,
  });

  final List<String> regions;
  final String? selectedRegion;
  final ValueChanged<String?> onRegionChanged;
  final LeaderboardListMode listMode;
  final ValueChanged<LeaderboardListMode> onListModeChanged;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _ModeChip(
              label: l10n.leaderboardFullList,
              selected: listMode == LeaderboardListMode.full,
              onTap: () => onListModeChanged(LeaderboardListMode.full),
              useWebStyle: useWebStyle,
            ),
            _ModeChip(
              label: l10n.leaderboardNearYou,
              selected: listMode == LeaderboardListMode.nearMe,
              onTap: () => onListModeChanged(LeaderboardListMode.nearMe),
              useWebStyle: useWebStyle,
            ),
          ],
        ),
        if (regions.isNotEmpty) ...[
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _RegionChip(
                  label: l10n.leaderboardAllRegions,
                  selected: selectedRegion == null,
                  onTap: () => onRegionChanged(null),
                  useWebStyle: useWebStyle,
                ),
                for (final region in regions) ...[
                  const SizedBox(width: 6),
                  _RegionChip(
                    label: formatRiotServerLabel(region),
                    selected: selectedRegion == region,
                    onTap: () => onRegionChanged(region),
                    useWebStyle: useWebStyle,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.useWebStyle,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final accent = useWebStyle ? WebColors.accent : WpggBrand.primary;
    final surface = useWebStyle ? WebColors.surface : WpggBrand.cardSurface;
    final border = selected
        ? accent
        : (useWebStyle ? WebColors.borderSubtle : WpggBrand.textMuted.withValues(alpha: 0.3));
    final textColor = selected
        ? (useWebStyle ? WebColors.textPrimary : WpggBrand.white)
        : (useWebStyle ? WebColors.textSecondary : WpggBrand.textMuted);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? accent.withValues(alpha: 0.14) : surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _RegionChip extends StatelessWidget {
  const _RegionChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.useWebStyle,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final surface = useWebStyle
        ? (selected ? WebColors.surfaceElevated : WebColors.surface)
        : WpggBrand.cardSurface;
    final border = useWebStyle
        ? (selected ? WebColors.border : WebColors.borderSubtle)
        : WpggBrand.textMuted.withValues(alpha: 0.25);
    final textColor = selected
        ? (useWebStyle ? WebColors.textPrimary : WpggBrand.white)
        : (useWebStyle ? WebColors.textMuted : WpggBrand.textMuted);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
