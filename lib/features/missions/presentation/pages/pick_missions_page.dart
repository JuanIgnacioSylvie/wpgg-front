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
import '../../domain/entities/mission_card_entity.dart';
import '../bloc/missions_bloc.dart';
import '../widgets/day_carousel.dart';
import '../widgets/filter_pills.dart';
import '../widgets/mission_pick_card.dart';

class PickMissionsPage extends StatefulWidget {
  const PickMissionsPage({super.key});

  @override
  State<PickMissionsPage> createState() => _PickMissionsPageState();
}

class _PickMissionsPageState extends State<PickMissionsPage> {
  var _filterIndex = 0;
  final _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<MissionsBloc>().add(const LoadPickToday());
  }

  List<MissionCardEntity> _filterOffers(List<MissionCardEntity> offers) {
    if (_filterIndex == 0) {
      return offers;
    }
    final diff = switch (_filterIndex) {
      1 => MissionDifficulty.hard,
      2 => MissionDifficulty.medium,
      _ => MissionDifficulty.easy,
    };
    return offers.where((o) => o.difficulty == diff).toList();
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
          appBar: WpggAppBar(
            title: 'Pick Missions',
            showBack: true,
            summoner: summoner,
            ddragon: ddragon,
          ),
          body: BlocConsumer<MissionsBloc, MissionsState>(
            listener: (context, state) {
              if (state.pickError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.pickError!)),
                );
              }
            },
            builder: (context, state) {
              if (state.pickStatus == MissionsLoadStatus.loading ||
                  state.pickStatus == MissionsLoadStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(color: WpggBrand.primary),
                );
              }
              if (state.pickStatus == MissionsLoadStatus.error) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      state.pickError ?? 'Error loading offers',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: WpggBrand.white),
                    ),
                  ),
                );
              }
              final pick = state.pick;
              if (pick == null) {
                return const SizedBox.shrink();
              }
              final offers = _filterOffers(pick.offers);
              final acceptedIds = pick.offers
                  .where((o) => o.status != MissionStatus.offer)
                  .map((o) => o.offerId ?? o.id)
                  .toSet();
              return Column(
                children: [
                  DayCarousel(
                    selectedDate: _selectedDate,
                    onDateSelected: (_) {},
                    lockToToday: true,
                  ),
                  const SizedBox(height: 12),
                  FilterPills(
                    labels: const ['All', 'Hard', 'Medium', 'Easy'],
                    selectedIndex: _filterIndex,
                    onSelected: (i) => setState(() => _filterIndex = i),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Selected ${pick.selectedCount}/${pick.maxSelectable} (max ${pick.maxHard} hard)',
                      style: const TextStyle(color: WpggBrand.textMuted),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: offers.length,
                      itemBuilder: (_, i) {
                        final m = offers[i];
                        final oid = m.offerId ?? m.id;
                        final accepted = acceptedIds.contains(oid);
                        return MissionPickCard(
                          mission: m,
                          accepted: accepted,
                          onAccept: () {
                            context.read<MissionsBloc>().add(
                                  AcceptMissionOffer(oid),
                                );
                          },
                          onReroll: () async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Reroll mission?'),
                                content: const Text(
                                  'This will cost 5 WPGG from your balance.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Reroll'),
                                  ),
                                ],
                              ),
                            );
                            if (ok == true && context.mounted) {
                              context.read<MissionsBloc>().add(
                                    RerollMissionOffer(oid),
                                  );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
