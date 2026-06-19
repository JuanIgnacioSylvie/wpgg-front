import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/wpgg_app_bar.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_event.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../../../riot/presentation/widgets/riot_link_sheet.dart';
import '../../../riot/presentation/widgets/stats_header.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../bloc/missions_bloc.dart';
import '../widgets/cancel_mission_dialog.dart';
import '../widgets/mission_matches_dialog.dart';
import '../widgets/mission_completed_card.dart';
import '../widgets/mission_primary_card.dart';
import '../widgets/mission_secondary_card.dart';
import '../widgets/mission_sync_button.dart';
import '../widgets/mission_tertiary_card.dart';
import '../widgets/mission_welcome_card.dart';
import '../../../profile/presentation/widgets/live_profile_balance_card.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../../wallet/data/datasources/wallet_remote_datasource.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _showRiotLinkFallback = false;

  @override
  void initState() {
    super.initState();
    context.read<MissionsBloc>().add(const LoadMissionsHome());
    context.read<WalletBloc>().add(const LoadWallet());
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    if (!mounted) return;
    final afterRiot = await sl<SecureStorage>().consumeRiotRsoJustLoggedIn();
    if (mounted) {
      setState(() => _showRiotLinkFallback = afterRiot);
    }
    if (!mounted) return;
    await context.read<DDragonProvider>().ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ddragon = context.watch<DDragonProvider>();
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
            return const WpggGradientScaffold(
              body: Center(
                child: CircularProgressIndicator(color: WpggBrand.primary),
              ),
            );
          }

          if (riotState is RiotNoAccount) {
            return WpggGradientScaffold(
              appBar: const WpggAppBar(),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  StatsHeaderEmpty(
                    onLinkTap: () => showRiotLinkSheet(context),
                    afterRiotLogin: _showRiotLinkFallback,
                  ),
                ],
              ),
            );
          }

          if (riotState is RiotError) {
            return WpggGradientScaffold(
              appBar: const WpggAppBar(),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        riotState.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: WpggBrand.white),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context
                            .read<RiotBloc>()
                            .add(const LoadDashboard()),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          SummonerEntity? summoner;
          if (riotState is RiotLoaded) {
            summoner = riotState.summoner;
          }

          return WpggGradientScaffold(
            appBar: WpggAppBar(summoner: summoner, ddragon: ddragon),
            body: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, walletState) {
                WalletSummary? walletSummary;
                if (walletState is WalletLoaded) {
                  walletSummary = walletState.summary;
                } else if (walletState is WalletWithdrawing) {
                  walletSummary = walletState.summary;
                }

                return BlocBuilder<MissionsBloc, MissionsState>(
              builder: (context, state) {
                if (state.homeStatus == MissionsLoadStatus.loading ||
                    state.homeStatus == MissionsLoadStatus.initial) {
                  return const Center(
                    child: CircularProgressIndicator(color: WpggBrand.primary),
                  );
                }
                if (state.homeStatus == MissionsLoadStatus.error) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.homeError ?? l10n.errorLoadingMissions,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: WpggBrand.white),
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
                    ),
                  );
                }

                final home = state.home;
                if (home == null) {
                  return const SizedBox.shrink();
                }

                return MissionSyncStatusPoller(
                  child: RefreshIndicator(
                  color: WpggBrand.primary,
                  onRefresh: () async {
                    context.read<MissionsBloc>().add(const LoadMissionsHome());
                    await context.read<MissionsBloc>().stream.firstWhere(
                          (s) =>
                              s.homeStatus == MissionsLoadStatus.loaded ||
                              s.homeStatus == MissionsLoadStatus.error,
                        );
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    children: [
                    if (walletSummary != null) ...[
                      LiveProfileBalanceCard(
                        balanceWpgg: walletSummary.balance,
                      ),
                      const SizedBox(height: 20),
                    ],
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                l10n.inProgress,
                                style: const TextStyle(
                                  color: WpggBrand.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const MissionSyncButton(),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.missionDayResets(
                              home.missionDate,
                              home.missionDayTimezone,
                            ),
                            style: const TextStyle(
                              color: WpggBrand.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                      if (home.welcome != null)
                        MissionWelcomeCard(
                          mission: home.welcome!,
                          onTap: () => _openMissionMatches(
                            context,
                            home.welcome!,
                          ),
                        ),
                      if (home.primary != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: MissionPrimaryCard(
                            mission: home.primary!,
                            onTap: () => _openMissionMatches(
                              context,
                              home.primary!,
                            ),
                            onCancel: () => _cancelMission(
                              context,
                              home.primary!.id,
                            ),
                          ),
                        )
                      else if (home.welcome == null &&
                          home.secondary.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Text(
                                l10n.noActiveMissions,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: WpggBrand.textMuted),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () => context.push('/missions/pick'),
                                icon: const Icon(Icons.add),
                                label: Text(l10n.pickMissions),
                              ),
                            ],
                          ),
                        ),
                      if (home.secondary.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 148,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16),
                            itemCount: home.secondary.length,
                            itemBuilder: (_, i) {
                              final mission = home.secondary[i];
                              return MissionSecondaryCard(
                                mission: mission,
                                onTap: () => _openMissionMatches(
                                  context,
                                  mission,
                                ),
                                onCancel: () => _cancelMission(
                                  context,
                                  mission.id,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              l10n.completedMissions,
                              style: TextStyle(
                                color: WpggBrand.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: WpggBrand.primary,
                              child: Text(
                                '${home.completed.length}',
                                style: const TextStyle(
                                  color: WpggBrand.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (home.completed.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            l10n.completedMissionsPlaceholder,
                            style: const TextStyle(color: WpggBrand.textMuted),
                          ),
                        )
                      else
                        ...home.completed.map(
                          (m) => Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: MissionCompletedCard(
                              mission: m,
                              onTap: () => _openMissionMatches(context, m),
                              onClaim: () => _claimMission(context, m.id),
                              claimInProgress:
                                  state.actionInProgress ==
                                      MissionActionType.claim,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              l10n.passMissions,
                              style: TextStyle(
                                color: WpggBrand.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: WpggBrand.primary,
                              child: Text(
                                '${home.past.length}',
                                style: const TextStyle(
                                  color: WpggBrand.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (home.past.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            l10n.passMissionsPlaceholder,
                            style: const TextStyle(color: WpggBrand.textMuted),
                          ),
                        )
                      else
                        ...home.past.map(
                          (m) => Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: MissionTertiaryCard(
                              mission: m,
                              onTap: () => _openMissionMatches(context, m),
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
        },
      ),
    );
  }

  void _openMissionMatches(BuildContext context, MissionCardEntity mission) {
    showMissionMatchesDialog(context, mission);
  }

  Future<void> _cancelMission(BuildContext context, String missionId) async {
    final ok = await showCancelMissionDialog(
      context,
      missionId: missionId,
    );
    if (!ok || !context.mounted) return;
    context.read<MissionsBloc>().add(CancelActiveMission(missionId));
  }

  void _claimMission(BuildContext context, String missionId) {
    context.read<MissionsBloc>().add(ClaimMissionReward(missionId));
  }
}
