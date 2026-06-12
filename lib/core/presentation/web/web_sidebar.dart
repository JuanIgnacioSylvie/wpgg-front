import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_fonts.dart';
import '../../constants/wpgg_brand.dart';
import '../../../l10n/app_localizations.dart';
import '../../l10n/l10n_extension.dart';
import '../../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../../../features/riot/domain/entities/summoner_entity.dart';
import '../wpgg_profile_avatar.dart';
import 'web_animations.dart';
import 'web_colors.dart';
import 'web_motion.dart';

class WebSidebar extends StatelessWidget {
  const WebSidebar({
    super.key,
    required this.expanded,
    required this.onToggleExpanded,
    required this.currentIndex,
    required this.onTap,
    required this.onSettingsTap,
    this.settingsSelected = false,
    this.onHeaderTap,
    this.summoner,
    this.ddragon,
    this.balance,
    this.onNotificationsTap,
    this.notificationsBellKey,
    this.unreadCount = 0,
    this.notificationsPanelOpen = false,
    this.showLeaderboard = true,
  });

  final bool expanded;
  final VoidCallback onToggleExpanded;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onSettingsTap;
  final bool settingsSelected;
  final VoidCallback? onHeaderTap;
  final SummonerEntity? summoner;
  final DDragonProvider? ddragon;
  final int? balance;
  final VoidCallback? onNotificationsTap;
  final GlobalKey? notificationsBellKey;
  final int unreadCount;
  final bool notificationsPanelOpen;
  final bool showLeaderboard;

  static List<int> _branchIndices({required bool showLeaderboard}) =>
      showLeaderboard ? [0, 1, 2, 3, 4] : [0, 1, 2, 4];

  static List<_NavItem> _items(
    AppLocalizations l10n, {
    required bool showLeaderboard,
  }) =>
      [
        _NavItem(
          outline: 'assets/icons/home.svg',
          filled: 'assets/icons/home_filled.svg',
          label: l10n.profile,
        ),
        _NavItem(
          outline: 'assets/icons/calendar.svg',
          filled: 'assets/icons/calendar_filled.svg',
          label: l10n.missionsByDays,
        ),
        _NavItem(
          icon: Icons.storefront_outlined,
          selectedIcon: Icons.storefront,
          label: l10n.storeTitle,
        ),
        if (showLeaderboard)
          _NavItem(
            icon: Icons.emoji_events_outlined,
            selectedIcon: Icons.emoji_events,
            label: l10n.leaderboardTitle,
          ),
        _NavItem(
          outline: 'assets/icons/chart_bar.svg',
          filled: 'assets/icons/chart_bar_filled.svg',
          label: l10n.financeTitle,
        ),
      ];

  static int _selectedRowIndex({
    required int currentIndex,
    required bool settingsSelected,
    required bool showLeaderboard,
  }) {
    if (settingsSelected) {
      return showLeaderboard ? 5 : 4;
    }
    if (showLeaderboard) {
      return switch (currentIndex) {
        1 => 1,
        2 => 2,
        3 => 3,
        4 => 4,
        _ => 0,
      };
    }
    return switch (currentIndex) {
      1 => 1,
      2 => 2,
      4 => 3,
      _ => 0,
    };
  }

  static _NavItem _settingsItem(AppLocalizations l10n) => _NavItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: l10n.settingsTitle,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = _items(l10n, showLeaderboard: showLeaderboard);
    final settingsItem = _settingsItem(l10n);
    final branchIndices = _branchIndices(showLeaderboard: showLeaderboard);
    return AnimatedContainer(
      duration: WebMotion.resolve(context, WebMotion.normal),
      curve: WebMotion.curve,
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
              child: _SidebarProfileHeader(
                expanded: expanded,
                summoner: summoner,
                ddragon: ddragon,
                onTap: onHeaderTap ?? onSettingsTap,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _SidebarNavSection(
            expanded: expanded,
            selectedRowIndex: _selectedRowIndex(
              currentIndex: currentIndex,
              settingsSelected: settingsSelected,
              showLeaderboard: showLeaderboard,
            ),
            items: items,
            settingsItem: settingsItem,
            branchIndices: branchIndices,
            settingsSelected: settingsSelected,
            onBranchTap: onTap,
            onSettingsTap: onSettingsTap,
          ),
          const Spacer(),
          AnimatedSize(
            duration: WebMotion.resolve(context, WebMotion.normal),
            curve: WebMotion.curve,
            alignment: Alignment.topCenter,
            child: expanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _SidebarBalance(balance: balance),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 12),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          _SidebarToggleRow(
            expanded: expanded,
            onTap: onToggleExpanded,
          ),
          const Divider(height: 1, color: WebColors.borderSubtle),
          const SizedBox(height: 8),
          _SidebarNavRow(
            item: _NavItem(
              outline: 'assets/icons/notification.svg',
              filled: 'assets/icons/notification.svg',
              label: l10n.navNotifications,
            ),
            expanded: expanded,
            selected: notificationsPanelOpen,
            onTap: onNotificationsTap ?? () {},
            enabled: onNotificationsTap != null,
            bellKey: notificationsBellKey,
            badgeCount: unreadCount,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SidebarProfileHeader extends StatefulWidget {
  const _SidebarProfileHeader({
    required this.expanded,
    required this.summoner,
    required this.ddragon,
    required this.onTap,
  });

  final bool expanded;
  final SummonerEntity? summoner;
  final DDragonProvider? ddragon;
  final VoidCallback onTap;

  @override
  State<_SidebarProfileHeader> createState() => _SidebarProfileHeaderState();
}

class _SidebarProfileHeaderState extends State<_SidebarProfileHeader> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    const avatarSize = 32.0;

    final avatar = widget.summoner != null
        ? WpggProfileAvatar(
            summoner: widget.summoner!,
            ddragon: widget.ddragon,
            size: avatarSize,
            enableHero: false,
          )
        : SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: WpggBrand.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: WpggBrand.white, size: 18),
            ),
          );

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
                      avatar,
                      if (widget.summoner != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: AnimatedOpacity(
                            opacity: widget.expanded ? 1 : 0,
                            duration:
                                WebMotion.resolve(context, WebMotion.normal),
                            curve: WebMotion.curve,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.summoner!.gameName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppFonts.lexendDeca,
                                    color: _hovered
                                        ? WebColors.textPrimary
                                        : WebColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '#${widget.summoner!.tagLine}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: AppFonts.lexendDeca,
                                    color: WebColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : Center(child: avatar),
        ),
      ),
    );
  }
}

class _SidebarNavSection extends StatelessWidget {
  const _SidebarNavSection({
    required this.expanded,
    required this.selectedRowIndex,
    required this.items,
    required this.settingsItem,
    required this.branchIndices,
    required this.settingsSelected,
    required this.onBranchTap,
    required this.onSettingsTap,
  });

  static const _rowStride = 44.0;

  final bool expanded;
  final int selectedRowIndex;
  final List<_NavItem> items;
  final _NavItem settingsItem;
  final List<int> branchIndices;
  final bool settingsSelected;
  final ValueChanged<int> onBranchTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: expanded ? 8 : 0),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: WebMotion.resolve(context, WebMotion.normal),
            curve: WebMotion.curve,
            top: selectedRowIndex * _rowStride + 2,
            left: 0,
            right: 0,
            height: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: WebColors.sidebarHover,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: WebColors.border),
              ),
            ),
          ),
          Column(
            children: [
              for (var i = 0; i < items.length; i++)
                _SidebarNavRow(
                  item: items[i],
                  expanded: expanded,
                  selected: !settingsSelected &&
                      selectedRowIndex == i,
                  onTap: () => onBranchTap(branchIndices[i]),
                ),
              _SidebarNavRow(
                item: settingsItem,
                expanded: expanded,
                selected: settingsSelected,
                onTap: onSettingsTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarToggleRow extends StatefulWidget {
  const _SidebarToggleRow({
    required this.expanded,
    required this.onTap,
  });

  final bool expanded;
  final VoidCallback onTap;

  @override
  State<_SidebarToggleRow> createState() => _SidebarToggleRowState();
}

class _SidebarToggleRowState extends State<_SidebarToggleRow> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      widget.expanded
          ? Icons.keyboard_double_arrow_left
          : Icons.keyboard_double_arrow_right,
      color: WebColors.textSecondary,
      size: 20,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.expanded ? 8 : 0,
        vertical: 2,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Tooltip(
          message: widget.expanded ? '' : context.l10n.sidebarExpandMenu,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 40,
              decoration: BoxDecoration(
                color: _hovered ? WebColors.sidebarHover : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.expanded
                  ? Row(
                      children: [
                        SizedBox(width: 40, child: Center(child: icon)),
                        Expanded(
                          child: AnimatedOpacity(
                            opacity: widget.expanded ? 1 : 0,
                            duration:
                                WebMotion.resolve(context, WebMotion.normal),
                            curve: WebMotion.curve,
                            child: Text(
                              context.l10n.sidebarCollapse,
                              style: TextStyle(
                                fontFamily: AppFonts.lexendDeca,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: WebColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(child: icon),
            ),
          ),
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
    this.bellKey,
    this.badgeCount = 0,
  });

  final _NavItem item;
  final bool expanded;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;
  final GlobalKey? bellKey;
  final int badgeCount;

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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Tooltip(
          message: widget.expanded ? '' : widget.item.label,
          child: GestureDetector(
            onTap: widget.enabled ? widget.onTap : null,
            child: AnimatedContainer(
              duration: WebMotion.resolve(context, WebMotion.fast),
              height: 40,
              decoration: BoxDecoration(
                color: _hovered && !widget.selected
                    ? WebColors.sidebarHover.withValues(alpha: 0.5)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.expanded
                  ? Row(
                      children: [
                        SizedBox(
                          key: widget.bellKey,
                          width: 40,
                          child: Center(child: _iconWithBadge(color)),
                        ),
                        Expanded(
                          child: AnimatedOpacity(
                            opacity: widget.expanded ? 1 : 0,
                            duration:
                                WebMotion.resolve(context, WebMotion.normal),
                            curve: WebMotion.curve,
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
                        ),
                      ],
                    )
                  : Center(
                      key: widget.bellKey,
                      child: _iconWithBadge(color),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconWithBadge(Color color) {
    final icon = _icon(color);
    if (widget.badgeCount <= 0) return icon;

    final label = widget.badgeCount > 9 ? '9+' : '${widget.badgeCount}';
    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          right: -4,
          top: -4,
          child: Container(
            constraints: const BoxConstraints(minWidth: 16),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: WebColors.accent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: WebColors.topBar, width: 1.5),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _icon(Color color) {
    final item = widget.item;
    if (item.icon != null) {
      return Icon(
        widget.selected ? (item.selectedIcon ?? item.icon) : item.icon,
        size: 22,
        color: color,
      );
    }
    return SvgPicture.asset(
      widget.selected ? item.filled! : item.outline!,
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
                Text(
                  context.l10n.balanceLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: WebColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                balance != null
                    ? WebAnimatedNumber(
                        value: balance!,
                        suffix: ' WPGG',
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: WebColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : const Text(
                        '—',
                        style: TextStyle(
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
    this.outline,
    this.filled,
    this.icon,
    this.selectedIcon,
    required this.label,
  });

  final String? outline;
  final String? filled;
  final IconData? icon;
  final IconData? selectedIcon;
  final String label;
}

int webSidebarIndexForLocation(String location) {
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
  return 0;
}
