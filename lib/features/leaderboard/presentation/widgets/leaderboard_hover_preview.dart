import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../profile/data/datasources/profile_remote_datasource.dart';

class LeaderboardHoverPreview extends StatelessWidget {
  const LeaderboardHoverPreview({
    super.key,
    required this.entry,
    required this.visible,
  });

  final LeaderboardEntry entry;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;
    final title = entry.localizedActiveMissionTitle(languageCode);
    final progress = entry.activeMissionProgressPercent;

    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 120),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: WebColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: WebColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatPill(
                  label: l10n.leaderboardMissionsCount(
                    entry.completedMissionsCount,
                  ),
                ),
                if (entry.hasActiveMission) ...[
                  const SizedBox(width: 8),
                  _StatPill(label: l10n.inProgress),
                ],
              ],
            ),
            if (entry.hasActiveMission && title.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  color: WebColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (progress.clamp(0, 100)) / 100,
                    minHeight: 5,
                    backgroundColor: WebColors.borderSubtle,
                    color: WebColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.leaderboardActiveProgress(progress),
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: WebColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ] else if (entry.completedMissionsCount == 0) ...[
              const SizedBox(height: 6),
              Text(
                l10n.noActiveMissions,
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
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: WebColors.borderSubtle),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: AppFonts.lexendDeca,
          color: WebColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
