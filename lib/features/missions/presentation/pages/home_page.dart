import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/wpgg_brand.dart';
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
import '../bloc/missions_bloc.dart';
import '../widgets/mission_primary_card.dart';
import '../widgets/mission_secondary_card.dart';

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
                        child: const Text('Reintentar'),
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
            body: BlocBuilder<MissionsBloc, MissionsState>(
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
                            state.homeError ?? 'Error loading missions',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: WpggBrand.white),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => context
                                .read<MissionsBloc>()
                                .add(const LoadMissionsHome()),
                            child: const Text('Reintentar'),
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

                return RefreshIndicator(
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
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: Text(
                          'In Progress',
                          style: TextStyle(
                            color: WpggBrand.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (home.primary != null)
                        MissionPrimaryCard(
                          mission: home.primary!,
                          endsInSeconds: home.endsInSeconds,
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              const Text(
                                'No active missions yet. Pick up to 3 for today!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: WpggBrand.textMuted),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () => context.push('/missions/pick'),
                                icon: const Icon(Icons.add),
                                label: const Text('Pick missions'),
                              ),
                            ],
                          ),
                        ),
                      if (home.secondary.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16),
                            itemCount: home.secondary.length,
                            itemBuilder: (_, i) => MissionSecondaryCard(
                              mission: home.secondary[i],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Text(
                              'Pass Missions',
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Completed missions will appear here.',
                            style: TextStyle(color: WpggBrand.textMuted),
                          ),
                        )
                      else
                        ...home.past.map(
                          (m) => Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: MissionSecondaryCard(
                              mission: m,
                              width: double.infinity,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
