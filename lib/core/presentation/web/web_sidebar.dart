import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_fonts.dart';
import '../../constants/wpgg_brand.dart';
import '../../l10n/l10n_extension.dart';
import 'web_colors.dart';

class WebSidebar extends StatelessWidget {
  const WebSidebar({
    super.key,
    required this.expanded,
    required this.onToggleExpanded,
    required this.currentIndex,
    required this.onTap,
    required this.onProfileTap,
    this.profileSelected = false,
    this.balance,
    required this.onLogout,
  });

  final bool expanded;
  final VoidCallback onToggleExpanded;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onProfileTap;
  final bool profileSelected;
  final int? balance;
  final VoidCallback onLogout;

  static const _items = [
    _NavItem(
      outline: 'assets/icons/home.svg',
      filled: 'assets/icons/home_filled.svg',
      label: 'Dashboard',
    ),
    _NavItem(
      outline: 'assets/icons/calendar.svg',
      filled: 'assets/icons/calendar_filled.svg',
      label: 'Misiones por día',
    ),
    _NavItem(
      outline: 'assets/icons/chart_bar.svg',
      filled: 'assets/icons/chart_bar_filled.svg',
      label: 'Finanzas',
    ),
  ];

  static const _branchIndices = [0, 1, 2];

  static const _profileItem = _NavItem(
    outline: 'assets/icons/profile.svg',
    filled: 'assets/icons/profile_filled.svg',
    label: 'Perfil',
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: expanded ? WebColors.sidebarExpandedWidth : WebColors.sidebarCollapsedWidth,
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
              child: _SidebarToggle(
                expanded: expanded,
                onTap: onToggleExpanded,
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _items.length; i++)
            _SidebarNavRow(
              item: _items[i],
              expanded: expanded,
              selected: currentIndex == _branchIndices[i],
              onTap: () => onTap(_branchIndices[i]),
            ),
          _SidebarNavRow(
            item: _profileItem,
            expanded: expanded,
            selected: profileSelected,
            onTap: onProfileTap,
          ),
          const Spacer(),
          if (expanded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _SidebarBalance(balance: balance),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _SidebarLogoutButton(
                label: context.l10n.logOut,
                onTap: onLogout,
              ),
            ),
            const SizedBox(height: 12),
          ],
          const Divider(height: 1, color: WebColors.borderSubtle),
          const SizedBox(height: 8),
          _SidebarNavRow(
            item: const _NavItem(
              outline: 'assets/icons/notification.svg',
              filled: 'assets/icons/notification.svg',
              label: 'Notificaciones',
            ),
            expanded: expanded,
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

class _SidebarToggle extends StatefulWidget {
  const _SidebarToggle({
    required this.expanded,
    required this.onTap,
  });

  final bool expanded;
  final VoidCallback onTap;

  @override
  State<_SidebarToggle> createState() => _SidebarToggleState();
}

class _SidebarToggleState extends State<_SidebarToggle> {
  var _hovered = false;

  Widget _toggleIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _hovered ? WebColors.sidebarHover : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        widget.expanded
            ? Icons.keyboard_double_arrow_left
            : Icons.keyboard_double_arrow_right,
        color: WebColors.textSecondary,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          child: widget.expanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      _toggleIcon(),
                      const SizedBox(width: 8),
                      const Text(
                        'WPGG',
                        style: TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: WebColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: _toggleIcon()),
        ),
      ),
    );
  }
}

class _SidebarNavRow extends StatefulWidget {
  const _SidebarNavRow({
    required this.item,
    required this.expanded,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final _NavItem item;
  final bool expanded;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<_SidebarNavRow> createState() => _SidebarNavRowState();
}

class _SidebarNavRowState extends State<_SidebarNavRow> {
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
      padding: EdgeInsets.symmetric(
        horizontal: widget.expanded ? 8 : 0,
        vertical: 2,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Tooltip(
          message: widget.expanded ? '' : widget.item.label,
          child: GestureDetector(
            onTap: widget.enabled ? widget.onTap : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
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
              child: widget.expanded
                  ? Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Center(child: _icon(color)),
                        ),
                        Expanded(
                          child: Text(
                            widget.item.label,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppFonts.lexendDeca,
                              fontSize: 13,
                              fontWeight: widget.selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: widget.selected
                                  ? WebColors.textPrimary
                                  : WebColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(child: _icon(color)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon(Color color) {
    return SvgPicture.asset(
      widget.selected ? widget.item.filled : widget.item.outline,
      width: 22,
      height: 22,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class _SidebarBalance extends StatelessWidget {
  const _SidebarBalance({this.balance});

  final int? balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WebColors.border),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/wpgg-coin_24x24.png',
            width: 20,
            height: 20,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo',
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: WebColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                Text(
                  balance != null ? '$balance WPGG' : '—',
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: WebColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarLogoutButton extends StatefulWidget {
  const _SidebarLogoutButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<_SidebarLogoutButton> createState() => _SidebarLogoutButtonState();
}

class _SidebarLogoutButtonState extends State<_SidebarLogoutButton> {
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? WebColors.sidebarHover : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: WebColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, size: 16, color: WebColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  color: WebColors.textSecondary,
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

class _NavItem {
  const _NavItem({
    required this.outline,
    required this.filled,
    required this.label,
  });

  final String outline;
  final String filled;
  final String label;
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
