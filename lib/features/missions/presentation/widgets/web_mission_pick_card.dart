import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/extensions/mission_card_l10n.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../domain/entities/mission_card_entity.dart';
import 'mission_shared_widgets.dart';
import 'mission_ui_helpers.dart';

class WebMissionPickCard extends StatefulWidget {
  const WebMissionPickCard({
    super.key,
    required this.mission,
    required this.accepted,
    required this.onAccept,
    required this.onReroll,
  });

  final MissionCardEntity mission;
  final bool accepted;
  final VoidCallback onAccept;
  final VoidCallback onReroll;

  @override
  State<WebMissionPickCard> createState() => _WebMissionPickCardState();
}

class _WebMissionPickCardState extends State<WebMissionPickCard> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mission = widget.mission;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: WebMotion.resolve(context, WebMotion.fast),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _hovered ? WebColors.surfaceElevated : WebColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.accepted
                ? WebColors.online.withValues(alpha: 0.4)
                : (_hovered ? WebColors.border : WebColors.borderSubtle),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MissionLeadingIcon(
              mission: mission,
              size: 44,
              borderRadius: 10,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.localizedTitle(context),
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: WebColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    difficultyLabel(mission.difficulty, l10n),
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 12,
                      color: WebColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                _ActionButton(
                  icon: Icons.check_rounded,
                  tooltip: l10n.transactionSuccessAcceptMission,
                  filled: true,
                  enabled: !widget.accepted,
                  onTap: widget.onAccept,
                ),
                const SizedBox(height: 8),
                _ActionButton(
                  icon: Icons.refresh_rounded,
                  tooltip: l10n.reroll,
                  filled: false,
                  enabled: !widget.accepted,
                  onTap: widget.onReroll,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.filled,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool filled;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.filled
        ? (widget.enabled
            ? (_hovered ? WebColors.accentHover : WebColors.accent)
            : WebColors.accent.withValues(alpha: 0.35))
        : (_hovered && widget.enabled
            ? WebColors.surfaceElevated
            : Colors.transparent);
    final borderColor = widget.filled
        ? Colors.transparent
        : (widget.enabled ? WebColors.border : WebColors.borderSubtle);
    final iconColor = widget.filled
        ? WebColors.textPrimary
        : (widget.enabled ? WebColors.textSecondary : WebColors.textMuted);

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
        child: GestureDetector(
          onTap: widget.enabled ? widget.onTap : null,
          child: AnimatedContainer(
          duration: WebMotion.resolve(context, WebMotion.fast),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
            child: Icon(widget.icon, color: iconColor, size: 20),
          ),
        ),
      ),
    );
  }
}
