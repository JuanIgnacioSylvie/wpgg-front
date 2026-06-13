import 'package:flutter/material.dart';

import '../../constants/app_fonts.dart';
import '../../../l10n/app_localizations.dart';
import '../../l10n/l10n_extension.dart';
import '../../../features/riot/domain/entities/summoner_entity.dart';
import '../widgets/mission_day_countdown.dart';
import '../widgets/wpgg_summoner_identity_labels.dart';
import 'web_colors.dart';
import 'web_motion.dart';

class WebTopBar extends StatelessWidget {
  const WebTopBar({
    super.key,
    required this.sectionTitle,
    this.dashboardSummoner,
    this.showAddButton = true,
    this.addButtonEnabled = true,
    this.showDayCountdown = false,
    this.dayEndsInSeconds,
    required this.onAddTap,
  });

  final String sectionTitle;
  final SummonerEntity? dashboardSummoner;
  final bool showAddButton;
  final bool addButtonEnabled;
  final bool showDayCountdown;
  final int? dayEndsInSeconds;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: WebColors.shellHeaderHeight,
      decoration: const BoxDecoration(
        color: WebColors.topBar,
        border: Border(
          bottom: BorderSide(color: WebColors.borderSubtle),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'WPGG',
            style: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: WebColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: WebMotion.resolve(context, WebMotion.normal),
            switchInCurve: WebMotion.curve,
            switchOutCurve: WebMotion.curve,
            transitionBuilder: (child, animation) {
              final curved =
                  CurvedAnimation(parent: animation, curve: WebMotion.curve);
              return FadeTransition(
                opacity: curved,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(curved),
                  child: child,
                ),
              );
            },
            child: dashboardSummoner != null
                ? WpggSummonerIdentityLabels.fromSummoner(
                    key: ValueKey<String>(dashboardSummoner!.riotId),
                    dashboardSummoner!,
                    layout: WpggSummonerIdentityLayout.horizontalBadges,
                    showTagAndServer: true,
                  )
                : Container(
                    key: ValueKey<String>(sectionTitle),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: WebColors.surface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: WebColors.border),
                    ),
                    child: Text(
                      sectionTitle,
                      style: const TextStyle(
                        color: WebColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
          ),
          const Spacer(),
          if (showDayCountdown && dayEndsInSeconds != null) ...[
            MissionDayCountdown(
              initialSeconds: dayEndsInSeconds!,
              labelBuilder: l10n.dayEndsIn,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WebColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
          ],
          if (showAddButton) ...[
            _TopBarAddButton(
              onTap: onAddTap,
              enabled: addButtonEnabled,
            ),
            const SizedBox(width: 12),
          ],
          Image.asset(
            'assets/images/wpgg-coin_200x200.png',
            width: 28,
            height: 28,
            filterQuality: FilterQuality.high,
          ),
        ],
      ),
    );
  }
}

class _TopBarAddButton extends StatefulWidget {
  const _TopBarAddButton({
    required this.onTap,
    required this.enabled,
  });

  final VoidCallback onTap;
  final bool enabled;

  @override
  State<_TopBarAddButton> createState() => _TopBarAddButtonState();
}

class _TopBarAddButtonState extends State<_TopBarAddButton> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = !widget.enabled
        ? WebColors.surface
        : _hovered
            ? WebColors.accentHover
            : WebColors.accent;
    final fgColor =
        widget.enabled ? Colors.white : WebColors.textMuted;

    return MouseRegion(
      onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
            border: widget.enabled
                ? null
                : Border.all(color: WebColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: fgColor, size: 16),
              const SizedBox(width: 4),
              Text(
                context.l10n.addMissionButton,
                style: TextStyle(
                  color: fgColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String webSectionTitleForLocation(AppLocalizations l10n, String location) {
  if (location.startsWith('/missions/by-day')) {
    return l10n.missionsByDays;
  }
  if (location.startsWith('/store')) {
    return l10n.storeTitle;
  }
  if (location.startsWith('/leaderboard')) {
    return l10n.leaderboardTitle;
  }
  if (location.startsWith('/finance')) {
    return l10n.financeTitle;
  }
  return l10n.profile;
}
