import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_progress_detail.dart';
import 'mission_ui_helpers.dart';

class WebMissionWelcomeCard extends StatelessWidget {
  const WebMissionWelcomeCard({
    super.key,
    required this.mission,
    this.onTap,
  });

  final MissionCardEntity mission;
  final VoidCallback? onTap;

  static const _accent = WpggBrand.welcomeAccent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subtitle = mission.localizedSubtitle(context);
    final color = missionAccentColor(mission);

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
      width: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            WpggBrand.welcomeAccentSoft.withValues(alpha: 0.35),
            WebColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.redeem, size: 14, color: _accent),
                    const SizedBox(width: 4),
                    Text(
                      l10n.welcomeMissionBadge,
                      style: const TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        color: _accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _RewardChip(amount: mission.rewardWpgg),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            mission.localizedTitle(context),
            style: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: WebColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: 1.35,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WebColors.textSecondary,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 16),
          MissionProgressDetail(
            mission: mission,
            useWebStyle: true,
            showBars: true,
            accentColor: color,
          ),
        ],
      ),
    ),
    ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  const _RewardChip({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/wpgg-coin_24x24.png',
          width: 18,
          height: 18,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.paid,
            size: 16,
            color: WebMissionWelcomeCard._accent,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$amount',
          style: const TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: WebMissionWelcomeCard._accent,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
