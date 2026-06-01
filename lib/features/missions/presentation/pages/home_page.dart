import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/wpgg_app_bar.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../bloc/missions_bloc.dart';
import '../widgets/mission_primary_card.dart';
import '../widgets/mission_secondary_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<MissionsBloc>().add(const LoadMissionsHome());
  }

  @override
  Widget build(BuildContext context) {
    final ddragon = context.watch<DDragonProvider>();
    return BlocBuilder<RiotBloc, RiotState>(
      builder: (context, riotState) {
        SummonerEntity? summoner;
        if (riotState is RiotLoaded) {
          summoner = riotState.summoner;
        }
        return WpggGradientScaffold(
          appBar: WpggAppBar(summoner: summoner, ddragon: ddragon),
          body: BlocBuilder<MissionsBloc, MissionsState>(
            builder: (context, state) {
              if (state is MissionsLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: WpggBrand.primary),
                );
              }
              if (state is MissionsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: WpggBrand.white),
                    ),
                  ),
                );
              }
              if (state is! MissionsHomeLoaded) {
                return const SizedBox.shrink();
              }
              return RefreshIndicator(
                color: WpggBrand.primary,
                onRefresh: () async {
                  context.read<MissionsBloc>().add(const LoadMissionsHome());
                },
                child: ListView(
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
                    if (state.primary != null)
                      MissionPrimaryCard(
                        mission: state.primary!,
                        endsInSeconds: state.endsInSeconds,
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No active missions. Pick missions for today!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: WpggBrand.textMuted),
                        ),
                      ),
                    if (state.secondary.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          itemCount: state.secondary.length,
                          itemBuilder: (_, i) => MissionSecondaryCard(
                            mission: state.secondary[i],
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
                              '${state.past.length}',
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
                    ...state.past.map(
                      (m) => Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: MissionSecondaryCard(mission: m, width: double.infinity),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
