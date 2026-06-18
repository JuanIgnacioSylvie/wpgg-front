import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/wpgg_app_bar.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../bloc/missions_bloc.dart';
import '../utils/pick_mission_utils.dart';
import '../widgets/filter_pills.dart';
import '../widgets/mission_pick_card.dart';
import '../widgets/mission_spend_dialog.dart';
import '../widgets/pick_offers_header.dart';

class PickMissionsPage extends StatefulWidget {
  const PickMissionsPage({super.key});

  @override
  State<PickMissionsPage> createState() => _PickMissionsPageState();
}

class _PickMissionsPageState extends State<PickMissionsPage> {
  var _filterIndex = 0;

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
    final l10n = context.l10n;
    final ddragon = context.watch<DDragonProvider>();
    return BlocBuilder<RiotBloc, RiotState>(
      builder: (context, riotState) {
        SummonerEntity? summoner;
        if (riotState is RiotLoaded) {
          summoner = riotState.summoner;
        }
        return WpggGradientScaffold(
          appBar: WpggAppBar(
            title: l10n.pickMissionsTitle,
            showBack: true,
            summoner: summoner,
            ddragon: ddragon,
          ),
          body: BlocBuilder<MissionsBloc, MissionsState>(
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
                      state.pickError ?? l10n.errorLoadingOffers,
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
                  const SizedBox(height: 12),
                  FilterPills(
                    labels: [
                      l10n.filterAll,
                      l10n.difficultyHard,
                      l10n.difficultyMedium,
                      l10n.difficultyEasy,
                    ],
                    selectedIndex: _filterIndex,
                    onSelected: (i) => setState(() => _filterIndex = i),
                  ),
                  PickOffersHeader(pick: pick, useWebStyle: false),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: offers.length,
                      itemBuilder: (_, i) {
                        final m = offers[i];
                        final oid = m.offerId ?? m.id;
                        final accepted = acceptedIds.contains(oid);
                        final canAccept =
                            !accepted && canAcceptMissionOffer(m, pick);
                        return MissionPickCard(
                          mission: m,
                          accepted: accepted,
                          canAccept: canAccept,
                          onAccept: () {
                            context.read<MissionsBloc>().add(
                                  AcceptMissionOffer(oid),
                                );
                          },
                          onReroll: () async {
                            final ok = await showRerollMissionDialog(context);
                            if (ok && context.mounted) {
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
