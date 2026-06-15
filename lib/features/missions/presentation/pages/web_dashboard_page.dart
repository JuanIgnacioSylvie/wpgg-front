import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_motion.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_event.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../../../riot/presentation/widgets/riot_link_sheet.dart';
import '../../../riot/presentation/widgets/stats_header.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../bloc/missions_bloc.dart';
import '../widgets/cancel_mission_dialog.dart';
import '../widgets/draggable_web_mission_card.dart';
import '../widgets/mission_sync_button.dart';
import '../widgets/pick_missions_dialog.dart';
import '../widgets/web_mission_card.dart';
import '../widgets/web_mission_trash_zone.dart';
import '../widgets/web_mission_welcome_card.dart';
import '../../../profile/presentation/widgets/live_profile_balance_card.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../../wallet/data/datasources/wallet_remote_datasource.dart';

class WebDashboardPage extends StatefulWidget {
  const WebDashboardPage({super.key});

  @override
  State<WebDashboardPage> createState() => _WebDashboardPageState();
}

class _WebDashboardPageState extends State<WebDashboardPage> {
  String? _draggingMissionId;
  final Set<String> _removingMissionIds = {};

  void _openPickMissions() {
    showPickMissionsDialog(context);
  }

  bool _canAddMore(MissionsHomeData home) {
    final activeCount =
        (home.primary != null ? 1 : 0) + home.secondary.length;
    return activeCount < 3;
  }

  int _inProgressCount(MissionsHomeData home) {
    return (home.welcome != null ? 1 : 0) +
        (home.primary != null ? 1 : 0) +
        home.secondary.length;
  }

  bool _hasInProgressMissions(MissionsHomeData home) {
    return home.welcome != null ||
        home.primary != null ||
        home.secondary.isNotEmpty;
  }

  List<MissionCardEntity> _activeMissions(MissionsHomeData home) {
    return [
      if (home.primary != null) home.primary!,
      ...home.secondary,
    ];
  }

  void _onDragStarted(String missionId) {
    setState(() => _draggingMissionId = missionId);
  }

  void _onDragEnded() {
    if (_draggingMissionId != null) {
      setState(() => _draggingMissionId = null);
    }
  }

  Future<void> _cancelMissionWithAnimation(String missionId) async {
    final ok = await showCancelMissionDialog(context, missionId: missionId);
    if (!ok || !mounted) return;

    setState(() => _removingMissionIds.add(missionId));
    await Future<void>.delayed(WebMotion.normal);
    if (!mounted) return;

    context.read<MissionsBloc>().add(CancelActiveMission(missionId));
    setState(() => _removingMissionIds.remove(missionId));
  }

  Future<void> _onDroppedOnTrash(String missionId) async {
    setState(() => _draggingMissionId = null);
    await _cancelMissionWithAnimation(missionId);
  }

  void _onReorder(String draggedId, String targetId) {
    setState(() => _draggingMissionId = null);
    context.read<MissionsBloc>().add(
          ReorderActiveMissions(
            draggedId: draggedId,
            targetId: targetId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<RiotBloc, RiotState>(
          listenWhen: (prev, curr) => curr is RiotAccountLinked,
          listener: (context, _) {
            context.read<RiotBloc>().add(const LoadDashboard());
            context.read<MissionsBloc>().add(const LoadMissionsHome());
          },
        ),
      ],
      child: BlocBuilder<RiotBloc, RiotState>(
        builder: (context, riotState) {
          if (riotState is RiotLoading ||
              riotState is RiotInitial ||
              riotState is RiotAccountLinked) {
            return const WebAnimatedSwitcher(
              child: WebDashboardSkeleton(key: ValueKey('riot-skeleton')),
            );
          }

          if (riotState is RiotNoAccount) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: StatsHeaderEmpty(
                  onLinkTap: () => showRiotLinkSheet(context),
                ),
              ),
            );
          }

          if (riotState is RiotError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    riotState.message,
                    style: const TextStyle(color: WebColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        context.read<RiotBloc>().add(const LoadDashboard()),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<MissionsBloc, MissionsState>(
            builder: (context, state) {
              if (state.homeStatus == MissionsLoadStatus.loading ||
                  state.homeStatus == MissionsLoadStatus.initial) {
                return const WebAnimatedSwitcher(
                  child: WebDashboardSkeleton(key: ValueKey('missions-skeleton')),
                );
              }

              if (state.homeStatus == MissionsLoadStatus.error) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.homeError ?? l10n.errorLoadingMissions,
                        style: const TextStyle(color: WebColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context
                            .read<MissionsBloc>()
                            .add(const LoadMissionsHome()),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              final home = state.home;
              if (home == null) return const SizedBox.shrink();

              final canAdd = _canAddMore(home);
              final onAdd = WebShellScope.addMissionHandler(context) ??
                  _openPickMissions;
              final activeMissions = _activeMissions(home);
              final isDragging = _draggingMissionId != null;

              return MissionSyncStatusPoller(
                child: WebAnimatedSwitcher(
                  child: Stack(
                    key: const ValueKey('dashboard-content'),
                    children: [
                    RefreshIndicator(
                      color: WebColors.accent,
                      backgroundColor: WebColors.surface,
                      onRefresh: () async {
                        context
                            .read<MissionsBloc>()
                            .add(const LoadMissionsHome());
                        await context.read<MissionsBloc>().stream.firstWhere(
                              (s) =>
                                  s.homeStatus == MissionsLoadStatus.loaded ||
                                  s.homeStatus == MissionsLoadStatus.error,
                            );
                      },
                      child: SingleChildScrollView(
                        physics: isDragging
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(32, 32, 32, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<WalletBloc, WalletState>(
                              builder: (context, walletState) {
                                WalletSummary? summary;
                                if (walletState is WalletLoaded) {
                                  summary = walletState.summary;
                                } else if (walletState is WalletWithdrawing) {
                                  summary = walletState.summary;
                                }
                                if (summary == null) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: LiveProfileBalanceCard(
                                    balanceWpgg: summary.balance,
                                    useWebStyle: true,
                                  ),
                                );
                              },
                            ),
                            WebSectionHeader(
                              title: l10n.inProgress,
                              count: _inProgressCount(home),
                              trailing: const MissionSyncButton(useWebStyle: true),
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                if (home.welcome != null)
                                  WebAnimatedAppear(
                                    key: ValueKey('welcome-${home.welcome!.id}'),
                                    staggerIndex: 0,
                                    child: WebMissionWelcomeCard(
                                      mission: home.welcome!,
                                    ),
                                  ),
                                ...activeMissions.asMap().entries.map(
                                  (entry) {
                                    final index = entry.key +
                                        (home.welcome != null ? 1 : 0);
                                    final m = entry.value;
                                    return WebAnimatedAppear(
                                      key: ValueKey('active-${m.id}'),
                                      staggerIndex: index,
                                      removing: _removingMissionIds.contains(
                                        m.id,
                                      ),
                                      child: DraggableWebMissionCard(
                                        mission: m,
                                        endsInSeconds: m == home.primary
                                            ? home.endsInSeconds
                                            : null,
                                        onDragStarted: _onDragStarted,
                                        onDragEnded: _onDragEnded,
                                        onReorder: _onReorder,
                                      ),
                                    );
                                  },
                                ),
                                if (canAdd)
                                  WebAnimatedAppear(
                                    key: ValueKey(
                                      'empty-slot-${activeMissions.length}',
                                    ),
                                    staggerIndex: activeMissions.length +
                                        (home.welcome != null ? 1 : 0),
                                    child: WebMissionCard.empty(onTap: onAdd),
                                  ),
                              ],
                            ),
                            if (!_hasInProgressMissions(home))
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  l10n.noActiveMissions,
                                  style: const TextStyle(
                                    color: WebColors.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 48),
                            WebSectionHeader(
                              title: l10n.passMissions,
                              count: home.past.length,
                            ),
                            const SizedBox(height: 20),
                            if (home.past.isEmpty)
                              Text(
                                l10n.completedMissionsPlaceholder,
                                style: const TextStyle(
                                  color: WebColors.textMuted,
                                  fontSize: 13,
                                ),
                              )
                            else
                              Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children: home.past.asMap().entries.map(
                                  (entry) {
                                    final m = entry.value;
                                    return WebAnimatedAppear(
                                      key: ValueKey('past-${m.id}'),
                                      staggerIndex: entry.key,
                                      child: WebMissionCard(
                                        mission: m,
                                        variant: WebMissionCardVariant.past,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 32,
                      child: IgnorePointer(
                        ignoring: !isDragging,
                        child: AnimatedOpacity(
                          opacity: isDragging ? 1 : 0,
                          duration: WebMotion.normal,
                          curve: WebMotion.curve,
                          child: AnimatedSlide(
                            offset: isDragging
                                ? Offset.zero
                                : const Offset(0, 0.4),
                            duration: WebMotion.normal,
                            curve: WebMotion.curve,
                            child: Center(
                              child: WebMissionTrashZone(
                                onAccept: _onDroppedOnTrash,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            },
          );
        },
      ),
    );
  }
}
