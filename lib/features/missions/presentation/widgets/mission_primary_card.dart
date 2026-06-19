import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_card_countdown.dart';
import 'mission_primary_description.dart';
import 'mission_progress_detail.dart';
import 'mission_progress_ring.dart';
import 'mission_shared_widgets.dart';
import 'mission_ui_helpers.dart';

class MissionPrimaryCard extends StatelessWidget {
  const MissionPrimaryCard({
    super.key,
    required this.mission,
    this.onCancel,
    this.onTap,
  });

  final MissionCardEntity mission;
  final VoidCallback? onCancel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = difficultyColor(mission.difficulty);

    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: missionCardDecoration(
        mission,
        surfaceColor: WpggBrand.cardSurface,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (onCancel != null)
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.close, size: 20),
                color: Colors.black54,
                tooltip: context.l10n.deleteMission,
                visualDensity: VisualDensity.compact,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 120, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MissionDifficultyHeader(
                      difficulty: mission.difficulty,
                      iconSize: 12,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      underlined: true,
                    ),
                    const SizedBox(height: 12),
                    MissionProgressRing(
                      percent: mission.progressPercent,
                      color: color,
                      size: 104,
                      strokeWidth: 4,
                    ),
                    const SizedBox(height: 8),
                    MissionProgressDetail(
                      mission: mission,
                      accentColor: color,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    MissionRewardRow(
                      amount: mission.rewardWpgg,
                      color: color,
                      coinSize: 24,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MissionPrimaryDescription(
                        title: mission.localizedTitle(context),
                        accent: color,
                      ),
                      if (mission.hasAssignedChampion) ...[
                        const SizedBox(height: 8),
                        MissionAssignedChampionLabel(
                          mission: mission,
                          accentColor: color,
                          fontSize: 12,
                        ),
                      ],
                      if (mission.endsAt != null) ...[
                        const SizedBox(height: 10),
                        MissionCardCountdown(
                          endsAt: mission.endsAt,
                          accentColor: color,
                          fontSize: 12,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -12,
            bottom: -28,
            child: Image.asset(
              'assets/images/sion_asset.png',
              width: 140,
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.person,
                size: 120,
                color: color.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
