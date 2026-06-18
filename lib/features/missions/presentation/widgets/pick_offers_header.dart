import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../bloc/missions_bloc.dart';
import 'mission_card_countdown.dart';

class PickOffersHeader extends StatelessWidget {
  const PickOffersHeader({
    super.key,
    required this.pick,
    this.useWebStyle = true,
  });

  final MissionsPickData pick;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mutedColor =
        useWebStyle ? WebColors.textMuted : Theme.of(context).hintColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.selectedMissionsCount(
              pick.activeCount,
              pick.maxActive,
              pick.maxHard,
            ),
            style: TextStyle(
              fontFamily: useWebStyle ? AppFonts.lexendDeca : null,
              color: mutedColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.missionOffersInfo,
            style: TextStyle(
              fontFamily: useWebStyle ? AppFonts.lexendDeca : null,
              color: mutedColor,
              fontSize: 12,
            ),
          ),
          if (pick.offersRefreshAt != null) ...[
            const SizedBox(height: 4),
            MissionCardCountdown(
              endsAt: pick.offersRefreshAt,
              fontSize: 12,
              useWebStyle: useWebStyle,
              accentColor: useWebStyle ? WebColors.accent : null,
              labelBuilder: l10n.missionOffersRefreshIn,
            ),
          ],
        ],
      ),
    );
  }
}
