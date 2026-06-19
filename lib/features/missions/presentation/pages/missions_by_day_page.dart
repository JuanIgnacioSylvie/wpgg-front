import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/utils/mission_day.dart';
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
import '../widgets/mission_matches_dialog.dart';
import '../widgets/mission_tertiary_card.dart';

class MissionsByDayPage extends StatefulWidget {
  const MissionsByDayPage({super.key});

  @override
  State<MissionsByDayPage> createState() => _MissionsByDayPageState();
}

class _MissionsByDayPageState extends State<MissionsByDayPage> {
  var _selectedDate = MissionDay.todayUtc();
  var _filterIndex = 0;
  var _initialLoadRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadWhenVisible();
  }

  void _loadWhenVisible() {
    if (_initialLoadRequested) return;
    final route = ModalRoute.of(context);
    if (route == null || !route.isCurrent) return;
    _initialLoadRequested = true;
    _load();
  }

  void _load() {
    final date = MissionDay.toApiDate(_selectedDate);
    context.read<MissionsBloc>().add(LoadMissionsByDay(date: date));
  }

  List<MissionCardEntity> _filterMissions(List<MissionCardEntity> missions) {
    if (_filterIndex == 0) {
      return missions;
    }
    if (_filterIndex == 1) {
      return missions
          .where((m) => m.status == MissionStatus.offer || m.progressPercent == 0)
          .toList();
    }
    if (_filterIndex == 2) {
      return missions
          .where((m) =>
              m.status == MissionStatus.active && m.progressPercent < 100)
          .toList();
    }
    return missions
        .where((m) =>
            m.status == MissionStatus.completed ||
            m.status == MissionStatus.claimed)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    _loadWhenVisible();
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
            title: l10n.missionsByDays,
            summoner: summoner,
            ddragon: ddragon,
          ),
          body: BlocBuilder<MissionsBloc, MissionsState>(
            builder: (context, state) {
              final missions = state.byDay != null
                  ? _filterMissions(state.byDay!.missions)
                  : <MissionCardEntity>[];

              return Column(
                children: [
                  DayCarousel(
                    selectedDate: _selectedDate,
                    onDateSelected: (d) {
                      setState(() => _selectedDate = d);
                      _load();
                    },
                  ),
                  const SizedBox(height: 12),
                  FilterPills(
                    labels: [
                      l10n.filterAll,
                      l10n.filterToDo,
                      l10n.filterInProgress,
                      l10n.filterCompleted,
                    ],
                    selectedIndex: _filterIndex,
                    onSelected: (i) => setState(() => _filterIndex = i),
                  ),
                  Expanded(
                    child: state.byDayStatus == MissionsLoadStatus.loading ||
                            state.byDayStatus == MissionsLoadStatus.initial
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: WpggBrand.primary,
                            ),
                          )
                        : state.byDayStatus == MissionsLoadStatus.error
                            ? Center(
                                child: Text(
                                  state.byDayError ?? l10n.errorGeneric,
                                  style: const TextStyle(
                                    color: WpggBrand.white,
                                  ),
                                ),
                              )
                            : ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 100,
                            ),
                            itemCount: missions.length,
                            itemBuilder: (_, i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              child: MissionTertiaryCard(
                                mission: missions[i],
                                onTap: () => showMissionMatchesDialog(
                                  context,
                                  missions[i],
                                ),
                              ),
                            ),
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
