import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../profile/data/datasources/profile_remote_datasource.dart';
import '../../../profile/presentation/bloc/profile_settings_bloc.dart';
import '../../../profile/presentation/pages/web_user_profile_page.dart';
import '../../../profile/presentation/profile_leaderboard_access.dart';
import '../../../profile/presentation/widgets/profile_privacy_blocked.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../bloc/leaderboard_bloc.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key, this.useWebStyle = false});

  final bool useWebStyle;

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileSettingsBloc>().add(const LoadProfileSettings());
  }

  void _reloadLeaderboard() {
    context.read<LeaderboardBloc>().add(const LoadLeaderboard());
  }

  void _openSettings() {
    if (widget.useWebStyle) {
      final openSettings = WebShellScope.openSettingsHandler(context);
      if (openSettings != null) {
        openSettings();
        return;
      }
    }
    context.go('/settings');
  }

  void _openProfile(LeaderboardEntry entry) {
    if (widget.useWebStyle) {
      showWebUserProfileDialog(
        context,
        userId: entry.userId,
        onOpenSettings: WebShellScope.openSettingsHandler(context),
      );
      return;
    }
    context.push('/users/${entry.userId}');
  }

  Widget _blockedView() {
    return ProfilePrivacyBlocked(
      useWebStyle: widget.useWebStyle,
      onOpenSettings: _openSettings,
      body: context.l10n.leaderboardPrivateBody,
    );
  }

  Widget _loadingView({required bool useWeb}) {
    if (useWeb) {
      return const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(32, 32, 32, 120),
        child: LeaderboardSkeleton(),
      );
    }
    return const Center(
      child: CircularProgressIndicator(color: WpggBrand.primary),
    );
  }

  Widget _errorView({
    required bool useWeb,
    required String message,
    required VoidCallback onRetry,
  }) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: TextStyle(
            color: useWeb ? WebColors.textSecondary : WpggBrand.white,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          style: useWeb
              ? FilledButton.styleFrom(
                  backgroundColor: WebColors.accent,
                  foregroundColor: Colors.white,
                )
              : null,
          onPressed: onRetry,
          child: Text(context.l10n.retry),
        ),
      ],
    );

    if (useWeb) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(child: content),
      );
    }
    return Center(child: content);
  }

  Widget _emptyView({required bool useWeb, required String message}) {
    final child = Text(
      message,
      style: TextStyle(
        color: useWeb ? WebColors.textMuted : WpggBrand.textMuted,
        fontSize: useWeb ? 13 : null,
      ),
    );

    if (useWeb) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: child,
      );
    }
    return Center(child: child);
  }

  Widget _entriesList({
    required List<LeaderboardEntry> entries,
    required bool useWeb,
    required DDragonProvider ddragon,
    required String title,
  }) {
    final rows = entries.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final summoner = SummonerEntity(
        gameName: item.gameName,
        tagLine: item.tagLine,
        region: item.region,
        profileIconId: item.profileIconId,
        puuid: '',
        summonerLevel: 0,
      );

      return WebAnimatedAppear(
        key: ValueKey('leaderboard-${item.userId}'),
        staggerIndex: index,
        child: Padding(
          padding: EdgeInsets.only(bottom: useWeb ? 10 : 8),
          child: _LeaderboardRow(
            entry: item,
            summoner: summoner,
            ddragon: ddragon,
            useWebStyle: useWeb,
            onTap: () => _openProfile(item),
          ),
        ),
      );
    }).toList();

    if (useWeb) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WebSectionHeader(
              title: title,
              count: entries.length,
            ),
            const SizedBox(height: 20),
            ...rows,
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: rows,
    );
  }

  Widget _leaderboardBody({
    required LeaderboardState state,
    required bool useWeb,
    required DDragonProvider ddragon,
    required String title,
  }) {
    final l10n = context.l10n;

    if (state is LeaderboardInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _reloadLeaderboard();
      });
    }

    return WebAnimatedSwitcher(
      child: switch (state) {
        LeaderboardLoading() => KeyedSubtree(
            key: const ValueKey('leaderboard-loading'),
            child: _loadingView(useWeb: useWeb),
          ),
        LeaderboardError() => KeyedSubtree(
            key: const ValueKey('leaderboard-error'),
            child: _errorView(
              useWeb: useWeb,
              message: l10n.errorGeneric,
              onRetry: _reloadLeaderboard,
            ),
          ),
        LeaderboardLoaded(:final entries) when entries.isEmpty => KeyedSubtree(
            key: const ValueKey('leaderboard-empty'),
            child: _emptyView(
              useWeb: useWeb,
              message: l10n.leaderboardEmpty,
            ),
          ),
        LeaderboardLoaded(:final entries) => KeyedSubtree(
            key: ValueKey('leaderboard-loaded-${entries.length}'),
            child: _entriesList(
              entries: entries,
              useWeb: useWeb,
              ddragon: ddragon,
              title: title,
            ),
          ),
        _ => KeyedSubtree(
            key: const ValueKey('leaderboard-initial'),
            child: _loadingView(useWeb: useWeb),
          ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ddragon = context.watch<DDragonProvider>();
    final useWeb = widget.useWebStyle;

    return BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
      listenWhen: (prev, curr) =>
          prev is ProfileSettingsLoaded && curr is ProfileSettingsLoaded
              ? prev.profilePublic != curr.profilePublic
              : curr is ProfileSettingsLoaded,
      listener: (context, state) {
        if (canAccessLeaderboard(state)) {
          _reloadLeaderboard();
        }
      },
      builder: (context, settingsState) {
        if (settingsState is ProfileSettingsLoading ||
            settingsState is ProfileSettingsInitial) {
          final loading = _loadingView(useWeb: useWeb);
          if (useWeb) return loading;
          return WpggGradientScaffold(body: loading);
        }

        if (!canAccessLeaderboard(settingsState)) {
          if (useWeb) return _blockedView();
          return WpggGradientScaffold(body: _blockedView());
        }

        final body = BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) => _leaderboardBody(
            state: state,
            useWeb: useWeb,
            ddragon: ddragon,
            title: l10n.leaderboardTitle,
          ),
        );

        if (useWeb) {
          return body;
        }

        return WpggGradientScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    l10n.leaderboardTitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WpggBrand.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}

Color? _leaderboardRankAccent(int rank) {
  switch (rank) {
    case 1:
      return const Color(0xFFEAB308);
    case 2:
      return const Color(0xFF94A3B8);
    case 3:
      return const Color(0xFFD97706);
    default:
      return null;
  }
}

class _LeaderboardRow extends StatefulWidget {
  const _LeaderboardRow({
    required this.entry,
    required this.summoner,
    required this.ddragon,
    required this.onTap,
    this.useWebStyle = false,
  });

  final LeaderboardEntry entry;
  final SummonerEntity summoner;
  final DDragonProvider? ddragon;
  final VoidCallback onTap;
  final bool useWebStyle;

  @override
  State<_LeaderboardRow> createState() => _LeaderboardRowState();
}

class _LeaderboardRowState extends State<_LeaderboardRow> {
  var _hovered = false;

  BoxDecoration _decoration() {
    final rankAccent = _leaderboardRankAccent(widget.entry.rank);
    final radius = BorderRadius.circular(widget.useWebStyle ? 12 : 16);

    if (widget.useWebStyle) {
      return BoxDecoration(
        color: _hovered ? WebColors.surfaceElevated : WebColors.surface,
        borderRadius: radius,
        border: Border.all(
          color: rankAccent != null
              ? rankAccent.withValues(alpha: _hovered ? 0.5 : 0.32)
              : (_hovered ? WebColors.border : WebColors.borderSubtle),
        ),
        boxShadow: rankAccent != null && widget.entry.rank == 1
            ? [
                BoxShadow(
                  color: rankAccent.withValues(alpha: _hovered ? 0.14 : 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      );
    }

    return BoxDecoration(
      color: WpggBrand.cardSurface,
      borderRadius: radius,
      border: rankAccent != null
          ? Border.all(color: rankAccent.withValues(alpha: 0.35))
          : null,
    );
  }

  Widget _rankBadge(Color mutedColor) {
    final rankAccent = _leaderboardRankAccent(widget.entry.rank);
    final rank = widget.entry.rank;

    if (rankAccent != null) {
      return Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: rankAccent.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: rankAccent.withValues(alpha: 0.45)),
        ),
        child: Text(
          '$rank',
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: rankAccent,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      );
    }

    return SizedBox(
      width: 32,
      child: Text(
        '#$rank',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          color: mutedColor,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _balanceChip({required Color textColor}) {
    final balanceStyle = TextStyle(
      fontFamily: AppFonts.lexendDeca,
      color: textColor,
      fontWeight: FontWeight.w700,
      fontSize: widget.useWebStyle ? 14 : 15,
    );

    final balanceText = widget.useWebStyle
        ? WebAnimatedNumber(
            value: widget.entry.balanceWpgg,
            style: balanceStyle,
          )
        : Text(
            '${widget.entry.balanceWpgg}',
            style: balanceStyle,
          );

    if (widget.useWebStyle) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: WebColors.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: WebColors.borderSubtle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/wpgg-coin_24x24.png',
              width: 16,
              height: 16,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(width: 6),
            balanceText,
          ],
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/wpgg-coin_24x24.png',
          width: 18,
          height: 18,
        ),
        const SizedBox(width: 6),
        balanceText,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        widget.useWebStyle ? WebColors.textPrimary : WpggBrand.cardTextDark;
    final mutedColor =
        widget.useWebStyle ? WebColors.textMuted : WpggBrand.textMuted;
    final avatarSize = widget.entry.rank <= 3 ? 44.0 : 40.0;
    final duration = WebMotion.resolve(context, WebMotion.fast);

    final row = AnimatedContainer(
      duration: duration,
      curve: WebMotion.curve,
      decoration: _decoration(),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.useWebStyle ? 12 : 16),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.useWebStyle ? 12 : 16),
          hoverColor: widget.useWebStyle
              ? WebColors.sidebarHover.withValues(alpha: 0.35)
              : null,
          splashColor: widget.useWebStyle
              ? WebColors.accent.withValues(alpha: 0.08)
              : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.useWebStyle ? 16 : 16,
              vertical: widget.useWebStyle ? 14 : 12,
            ),
            child: Row(
              children: [
                _rankBadge(mutedColor),
                SizedBox(width: widget.useWebStyle ? 14 : 12),
                WpggProfileAvatar(
                  summoner: widget.summoner,
                  ddragon: widget.ddragon,
                  size: avatarSize,
                  enableHero: false,
                ),
                SizedBox(width: widget.useWebStyle ? 14 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.entry.gameName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: widget.useWebStyle ? 14 : 15,
                        ),
                      ),
                      if (widget.entry.tagLine.isNotEmpty)
                        Text(
                          '#${widget.entry.tagLine}',
                          style: TextStyle(
                            fontFamily: AppFonts.lexendDeca,
                            color: mutedColor,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _balanceChip(textColor: textColor),
              ],
            ),
          ),
        ),
      ),
    );

    if (!widget.useWebStyle) {
      return row;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: row,
    );
  }
}
