import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../profile/data/datasources/profile_remote_datasource.dart';
import '../../../profile/presentation/bloc/profile_settings_bloc.dart';
import '../../../profile/presentation/pages/web_user_profile_page.dart';
import '../../../profile/presentation/profile_leaderboard_access.dart';
import '../../../profile/presentation/widgets/profile_privacy_blocked.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../data/leaderboard_rank_snapshot_store.dart';
import '../../../wallet/presentation/widgets/live_wpgg_price_scope.dart';
import '../../domain/leaderboard_helpers.dart';
import '../bloc/leaderboard_bloc.dart';
import '../widgets/leaderboard_controls.dart';
import '../widgets/leaderboard_layout.dart';
import '../widgets/leaderboard_podium.dart';
import '../widgets/leaderboard_row.dart';
import '../widgets/leaderboard_viewer_card.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key, this.useWebStyle = false});

  final bool useWebStyle;

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String? _regionFilter;
  LeaderboardListMode _listMode = LeaderboardListMode.full;
  Map<String, int> _rankDeltas = {};
  LeaderboardRankSnapshotStore? _rankStore;

  @override
  void initState() {
    super.initState();
    context.read<ProfileSettingsBloc>().add(const LoadProfileSettings());
    _initRankStore();
  }

  Future<void> _initRankStore() async {
    _rankStore = await LeaderboardRankSnapshotStore.create();
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

  LeaderboardViewerSnapshot _viewerSnapshot(
    BuildContext context,
    LeaderboardViewerPayload? payload,
  ) {
    final authState = context.read<AuthBloc>().state;
    String? userId;
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;
    }
    return LeaderboardViewerSnapshot(
      userId: userId,
      balanceWpgg: payload?.balanceWpgg ?? 0,
    );
  }

  Future<void> _persistRankSnapshots(List<LeaderboardEntry> entries) async {
    final store = _rankStore;
    if (store == null) return;

    final previous = store.load();
    final deltas = store.computeDeltas(
      previous: previous,
      current: entries
          .map((e) => (userId: e.userId, rank: e.rank))
          .toList(growable: false),
    );

    await store.save({for (final e in entries) e.userId: e.rank});
    if (!mounted) return;
    setState(() => _rankDeltas = deltas);
  }

  List<LeaderboardEntry> _prepareEntries({
    required List<LeaderboardEntry> raw,
    required LeaderboardViewerRank viewerRank,
  }) {
    var entries = leaderboardFilterByRegion(raw, _regionFilter);
    if (_listMode == LeaderboardListMode.nearMe) {
      entries = leaderboardSliceNearViewer(
        entries: entries,
        viewerRank: viewerRank,
      );
    }
    return entries;
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
      return SingleChildScrollView(
        padding: leaderboardPagePadding(context, useWeb: true),
        child: const LeaderboardSkeleton(),
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
        padding: leaderboardPagePadding(context, useWeb: true),
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
        padding: leaderboardPagePadding(context, useWeb: true),
        child: child,
      );
    }
    return Center(child: child);
  }

  Widget _buildRow({
    required LeaderboardEntry item,
    required int index,
    required bool useWeb,
    required DDragonProvider ddragon,
    required List<LeaderboardEntry> allEntries,
    required LeaderboardViewerSnapshot viewer,
  }) {
    final summoner = SummonerEntity(
      gameName: item.gameName,
      tagLine: item.tagLine,
      region: item.region,
      profileIconId: item.profileIconId,
      puuid: '',
      summonerLevel: 0,
    );

    return WebAnimatedAppear(
      key: ValueKey('leaderboard-${item.userId}-${item.rank}'),
      staggerIndex: index,
      child: Padding(
        padding: EdgeInsets.only(bottom: useWeb ? 10 : 8),
        child: LeaderboardRow(
          entry: item,
          summoner: summoner,
          ddragon: ddragon,
          useWebStyle: useWeb,
          onTap: () => _openProfile(item),
          gapToAbove: leaderboardGapToRankAbove(item, allEntries),
          rankDelta: _rankDeltas[item.userId],
          priceUsd: LiveWpggPriceScope.of(context),
          viewer: viewer,
          allEntries: allEntries,
          isViewer: viewer.userId == item.userId,
        ),
      ),
    );
  }

  Widget _entriesList({
    required LeaderboardResponse response,
    required bool useWeb,
    required DDragonProvider ddragon,
    required String title,
  }) {
    final l10n = context.l10n;
    final rawEntries = response.entries;
    final viewer = _viewerSnapshot(context, response.viewer);
    final listedEntry = leaderboardFindByUserId(rawEntries, viewer.userId);
    final viewerRank = leaderboardViewerRankFromPayload(
      response.viewer,
      entry: listedEntry,
    );

    final priceUsd = LiveWpggPriceScope.of(context);
    final entries = _prepareEntries(raw: rawEntries, viewerRank: viewerRank);
    final showPodium = _listMode == LeaderboardListMode.full;
    final split = showPodium
        ? leaderboardSplitPodium(entries)
        : (podium: <LeaderboardEntry>[], rest: entries);
    final regions = leaderboardDistinctRegions(rawEntries);

    final children = <Widget>[
      WebSectionHeader(
        title: title,
        count: entries.length,
        subtitle: l10n.leaderboardSubtitle,
      ),
      const SizedBox(height: 16),
      LeaderboardControls(
        regions: regions,
        selectedRegion: _regionFilter,
        onRegionChanged: (region) => setState(() => _regionFilter = region),
        listMode: _listMode,
        onListModeChanged: (mode) => setState(() => _listMode = mode),
        useWebStyle: useWeb,
      ),
      const SizedBox(height: 20),
      LeaderboardViewerCard(
        viewerRank: viewerRank,
        viewer: viewer,
        allEntries: rawEntries,
        ddragon: ddragon,
        priceUsd: priceUsd,
        useWebStyle: useWeb,
      ),
      const SizedBox(height: 20),
      if (split.podium.isNotEmpty) ...[
        LeaderboardPodium(
          entries: split.podium,
          ddragon: ddragon,
          priceUsd: priceUsd,
          onTap: _openProfile,
          useWebStyle: useWeb,
        ),
        const SizedBox(height: 24),
        if (split.rest.isNotEmpty)
          Text(
            l10n.leaderboardRestOfRanking,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: useWeb ? WebColors.textMuted : WpggBrand.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (split.rest.isNotEmpty) const SizedBox(height: 12),
      ],
      for (final entry in split.rest.asMap().entries)
        _buildRow(
          item: entry.value,
          index: entry.key + split.podium.length,
          useWeb: useWeb,
          ddragon: ddragon,
          allEntries: rawEntries,
          viewer: viewer,
        ),
    ];

    return SingleChildScrollView(
      padding: leaderboardPagePadding(context, useWeb: useWeb),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
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

    if (state is LeaderboardLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _persistRankSnapshots(state.entries);
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
        LeaderboardLoaded(:final response) when response.entries.isEmpty =>
          KeyedSubtree(
            key: const ValueKey('leaderboard-empty'),
            child: _emptyView(
              useWeb: useWeb,
              message: l10n.leaderboardEmpty,
            ),
          ),
        LeaderboardLoaded(:final response) => KeyedSubtree(
            key: ValueKey('leaderboard-loaded-${response.entries.length}'),
            child: _entriesList(
              response: response,
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

        final body = LiveWpggPriceScope(
          child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
            builder: (context, state) => _leaderboardBody(
              state: state,
              useWeb: useWeb,
              ddragon: ddragon,
              title: l10n.leaderboardTitle,
            ),
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
