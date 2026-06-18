import 'package:flutter/material.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_shared_widgets.dart';
import 'mission_ui_helpers.dart';

class MissionPickCard extends StatelessWidget {
  const MissionPickCard({
    super.key,
    required this.mission,
    required this.accepted,
    required this.canAccept,
    required this.onAccept,
    required this.onReroll,
  });

  final MissionCardEntity mission;
  final bool accepted;
  final bool canAccept;
  final VoidCallback onAccept;
  final VoidCallback onReroll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: missionCardDecoration(mission),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MissionLeadingIcon(
            mission: mission,
            size: 48,
            borderRadius: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.localizedTitle(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      difficultyLabel(mission.difficulty, l10n),
                      style: TextStyle(
                        fontSize: 12,
                        color: difficultyColor(mission.difficulty),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    MissionRewardRow(
                      amount: mission.rewardWpgg,
                      color: difficultyColor(mission.difficulty),
                      fontSize: 12,
                      coinSize: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: ElevatedButton(
                  onPressed: accepted || !canAccept ? null : onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WpggBrand.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(
                    accepted ? Icons.check : Icons.check,
                    color: WpggBrand.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: accepted ? null : onReroll,
                icon: const Icon(Icons.refresh, color: Colors.black87),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black12,
                  minimumSize: const Size(40, 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
