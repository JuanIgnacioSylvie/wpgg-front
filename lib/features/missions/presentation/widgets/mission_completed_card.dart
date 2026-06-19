import 'package:flutter/material.dart';

import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_progress_detail.dart';
import 'mission_progress_ring.dart';
import 'mission_shared_widgets.dart';
import 'mission_ui_helpers.dart';

class MissionCompletedCard extends StatelessWidget {
  const MissionCompletedCard({
    super.key,
    required this.mission,
    this.onTap,
    this.onClaim,
    this.claimInProgress = false,
  });

  final MissionCardEntity mission;
  final VoidCallback? onTap;
  final VoidCallback? onClaim;
  final bool claimInProgress;

  @override
  Widget build(BuildContext context) {
    final color = missionAccentColor(mission);
    final l10n = context.l10n;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: missionCardDecoration(mission),
        child: Row(
          children: [
            MissionLeadingIcon(mission: mission),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.localizedTitle(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  if (mission.hasAssignedChampion) ...[
                    const SizedBox(height: 4),
                    MissionAssignedChampionLabel(
                      mission: mission,
                      accentColor: color,
                      fontSize: 12,
                    ),
                  ],
                  const SizedBox(height: 4),
                  MissionProgressDetail(
                    mission: mission,
                    fontSize: 12,
                    accentColor: color,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusLabel(mission.status, l10n),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (onClaim != null) ...[
                    const SizedBox(height: 10),
                    WpggPrimaryButton(
                      label: l10n.claimRewardAmount(mission.rewardWpgg),
                      onPressed: claimInProgress ? null : onClaim,
                      isLoading: claimInProgress,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            MissionProgressRing(
              percent: mission.progressPercent,
              color: color,
              size: 52,
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}
