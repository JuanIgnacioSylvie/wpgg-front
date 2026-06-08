import 'package:flutter/material.dart';

import '../../constants/app_fonts.dart';
import '../../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../../../features/riot/domain/entities/summoner_entity.dart';
import '../wpgg_profile_avatar.dart';
import 'web_colors.dart';

class WebTopBar extends StatelessWidget {
  const WebTopBar({
    super.key,
    this.summoner,
    this.ddragon,
    this.sectionTitle = 'Dashboard',
    this.showAddButton = true,
    required this.onAddTap,
  });

  final SummonerEntity? summoner;
  final DDragonProvider? ddragon;
  final String sectionTitle;
  final bool showAddButton;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: WebColors.topBar,
        border: Border(
          bottom: BorderSide(color: WebColors.borderSubtle),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset(
            'assets/images/wpgg_logo.png',
            height: 22,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          const Text(
            '/',
            style: TextStyle(color: WebColors.textMuted, fontSize: 14),
          ),
          const SizedBox(width: 12),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
          const Spacer(),
          if (showAddButton) ...[
            _TopBarAddButton(onTap: onAddTap),
            const SizedBox(width: 12),
          ],
          if (summoner != null && ddragon != null)
            WpggProfileAvatar(
              summoner: summoner!,
              ddragon: ddragon!,
              size: 28,
            ),
        ],
      ),
    );
  }
}

class _TopBarAddButton extends StatefulWidget {
  const _TopBarAddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_TopBarAddButton> createState() => _TopBarAddButtonState();
}

class _TopBarAddButtonState extends State<_TopBarAddButton> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? WebColors.accentHover : WebColors.accent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                'Agregar',
                style: TextStyle(
                  color: Colors.white,
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

String webSectionTitleForLocation(String location) {
  if (location.startsWith('/missions/by-day')) {
    return 'Misiones por día';
  }
  if (location.startsWith('/finance')) {
    return 'Finanzas';
  }
  if (location.startsWith('/profile')) {
    return 'Perfil';
  }
  return 'Dashboard';
}
