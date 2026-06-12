import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/wpgg_brand.dart';

class WpggBottomNav extends StatelessWidget {
  const WpggBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onFabTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onFabTap;

  static const _fabSize = 54.0;
  static const _fabLogoSize = 28.0;
  static const _barHeight = 64.0;
  static const _navRed = WpggBrand.navSelected;
  static const _navInactive = Color(0xFF6B7280);

  static const _items = [
    _NavItemData(
      navIndex: 0,
      outline: 'assets/icons/home.svg',
      filled: 'assets/icons/home_filled.svg',
    ),
    _NavItemData(
      navIndex: 1,
      outline: 'assets/icons/calendar.svg',
      filled: 'assets/icons/calendar_filled.svg',
    ),
    _NavItemData(
      navIndex: 3,
      materialOutline: Icons.emoji_events_outlined,
      materialFilled: Icons.emoji_events,
    ),
    _NavItemData(
      navIndex: 5,
      materialOutline: Icons.settings_outlined,
      materialFilled: Icons.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: _barHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: WpggBrand.navBar,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _items.length; i++) ...[
                        Expanded(
                          child: _NavItem(
                            item: _items[i],
                            selected: currentIndex == _items[i].navIndex,
                            onTap: () => onTap(_items[i].navIndex),
                          ),
                        ),
                        if (i == 1) const SizedBox(width: _fabSize),
                      ],
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -22,
                child: GestureDetector(
                  onTap: onFabTap,
                  child: Container(
                    width: _fabSize,
                    height: _fabSize,
                    decoration: BoxDecoration(
                      color: _navRed,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _navRed.withValues(alpha: 0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/logo_w.png',
                        width: _fabLogoSize,
                        height: _fabLogoSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.navIndex,
    this.outline,
    this.filled,
    this.materialOutline,
    this.materialFilled,
  });

  final int navIndex;
  final String? outline;
  final String? filled;
  final IconData? materialOutline;
  final IconData? materialFilled;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItemData item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? WpggBottomNav._navRed : WpggBottomNav._navInactive;

    Widget iconWidget;
    if (item.outline != null) {
      iconWidget = SvgPicture.asset(
        selected ? item.filled! : item.outline!,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      iconWidget = Icon(
        selected ? item.materialFilled : item.materialOutline,
        size: 28,
        color: color,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: WpggBottomNav._barHeight,
          child: Center(child: iconWidget),
        ),
      ),
    );
  }
}

int wpggNavIndexForLocation(String location) {
  if (location.startsWith('/missions/by-day')) {
    return 1;
  }
  if (location.startsWith('/store')) {
    return 2;
  }
  if (location.startsWith('/leaderboard')) {
    return 3;
  }
  if (location.startsWith('/finance')) {
    return 4;
  }
  if (location.startsWith('/settings')) {
    return 5;
  }
  return 0;
}
