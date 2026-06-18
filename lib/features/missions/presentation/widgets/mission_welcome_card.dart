import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/widgets/wpgg_card_elevation.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_progress_detail.dart';
import 'mission_progress_ring.dart';
import 'mission_shared_widgets.dart';
class MissionWelcomeCard extends StatelessWidget {
  const MissionWelcomeCard({
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: WpggCardElevation.enhance(
        BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              WpggBrand.welcomeAccentSoft,
              WpggBrand.cardSurface,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _accent.withValues(alpha: 0.55), width: 1.5),
        ),
        accentColor: _accent,
        useConvexGradient: false,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 112, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WelcomeBadge(label: l10n.welcomeMissionBadge),
                    const SizedBox(height: 12),
                    MissionProgressRing(
                      percent: mission.progressPercent,
                      color: _accent,
                      size: 104,
                      strokeWidth: 4,
                    ),
                    const SizedBox(height: 8),
                    MissionProgressDetail(
                      mission: mission,
                      accentColor: _accent,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    MissionRewardRow(
                      amount: mission.rewardWpgg,
                      color: _accent,
                      coinSize: 24,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.localizedTitle(context),
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: WpggBrand.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          height: 1.35,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: AppFonts.lexendDeca,
                            color: WpggBrand.cardTextDark.withValues(alpha: 0.72),
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -8,
            bottom: -20,
            child: Image.asset(
              'assets/images/wpgg-coin_200x200.png',
              width: 96,
              height: 96,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.redeem,
                size: 72,
                color: _accent.withValues(alpha: 0.45),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _WelcomeBadge extends StatelessWidget {
  const _WelcomeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: WpggBrand.welcomeAccent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: WpggBrand.welcomeAccent.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.redeem,
            size: 14,
            color: WpggBrand.welcomeAccent,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: WpggBrand.welcomeAccent,
              fontWeight: FontWeight.w800,
              fontSize: 8,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
