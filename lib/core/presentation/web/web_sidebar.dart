import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/wpgg_brand.dart';
import 'web_colors.dart';

class WebSidebar extends StatelessWidget {
  const WebSidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onProfileTap,
    this.profileSelected = false,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onProfileTap;
  final bool profileSelected;

  static const _items = [
    _NavIconPair(
      outline: 'assets/icons/home.svg',
      filled: 'assets/icons/home_filled.svg',
      tooltip: 'Dashboard',
    ),
    _NavIconPair(
      outline: 'assets/icons/calendar.svg',
      filled: 'assets/icons/calendar_filled.svg',
      tooltip: 'Misiones por día',
    ),
    _NavIconPair(
      outline: 'assets/icons/chart_bar.svg',
      filled: 'assets/icons/chart_bar_filled.svg',
      tooltip: 'Finanzas',
    ),
  ];

  static const _branchIndices = [0, 1, 2];

  static const _profileIcon = _NavIconPair(
    outline: 'assets/icons/profile.svg',
    filled: 'assets/icons/profile_filled.svg',
    tooltip: 'Perfil',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      decoration: const BoxDecoration(
        color: WebColors.topBar,
        border: Border(
          right: BorderSide(color: WebColors.borderSubtle),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: WebColors.shellHeaderHeight,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: WebColors.borderSubtle),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/wpgg-coin_200x200.png',
                  width: 28,
                  height: 28,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _items.length; i++)
            _SidebarItem(
              icon: _items[i],
              selected: currentIndex == _branchIndices[i],
              onTap: () => onTap(_branchIndices[i]),
            ),
          _SidebarItem(
            icon: _profileIcon,
            selected: profileSelected,
            onTap: onProfileTap,
          ),
          const Spacer(),
          const Divider(height: 1, color: WebColors.borderSubtle),
          const SizedBox(height: 8),
          _SidebarItem(
            icon: const _NavIconPair(
              outline: 'assets/icons/notification.svg',
              filled: 'assets/icons/notification.svg',
              tooltip: 'Notificaciones',
            ),
            selected: false,
            onTap: () {},
            enabled: false,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.icon,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final _NavIconPair icon;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = !widget.enabled
        ? WebColors.textMuted.withValues(alpha: 0.4)
        : widget.selected
            ? WpggBrand.navSelected
            : _hovered
                ? WebColors.textPrimary
                : WebColors.textMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Tooltip(
          message: widget.icon.tooltip,
          child: GestureDetector(
            onTap: widget.enabled ? widget.onTap : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.selected || _hovered
                    ? WebColors.sidebarHover
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: widget.selected
                    ? Border.all(color: WebColors.border)
                    : null,
              ),
              child: Center(
                child: SvgPicture.asset(
                  widget.selected ? widget.icon.filled : widget.icon.outline,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIconPair {
  const _NavIconPair({
    required this.outline,
    required this.filled,
    required this.tooltip,
  });

  final String outline;
  final String filled;
  final String tooltip;
}

int webSidebarIndexForLocation(String location) {
  if (location.startsWith('/missions/by-day')) {
    return 1;
  }
  if (location.startsWith('/finance')) {
    return 2;
  }
  return 0;
}
