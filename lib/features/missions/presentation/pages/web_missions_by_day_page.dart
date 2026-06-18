import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../../../core/utils/mission_day.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../bloc/missions_bloc.dart';
import '../widgets/mission_matches_dialog.dart';
import '../widgets/web_day_selector.dart';
import '../widgets/web_filter_chips.dart';
import '../widgets/web_mission_card.dart';
import '../widgets/web_mission_welcome_card.dart';

class WebMissionsByDayPage extends StatefulWidget {
  const WebMissionsByDayPage({super.key});

  @override
  State<WebMissionsByDayPage> createState() => _WebMissionsByDayPageState();
}

class _WebMissionsByDayPageState extends State<WebMissionsByDayPage> {
  var _selectedDate = MissionDay.todayUtc();
  var _filterIndex = 0;
  var _initialLoadRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadWhenVisible());
  }

  void _loadWhenVisible() {
    if (!mounted || _initialLoadRequested) return;
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
    if (_filterIndex == 0) return missions;
    if (_filterIndex == 1) {
      return missions
          .where(
            (m) => m.status == MissionStatus.offer || m.progressPercent == 0,
          )
          .toList();
    }
    if (_filterIndex == 2) {
      return missions
          .where(
            (m) =>
                m.status == MissionStatus.active && m.progressPercent < 100,
          )
          .toList();
    }
    return missions
        .where(
          (m) => m.status == MissionStatus.completed,
        )
        .toList();
  }

  bool _isPastMission(MissionCardEntity mission) {
    return mission.status == MissionStatus.completed ||
        mission.status == MissionStatus.expired;
  }

  String _formattedSelectedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMEd(locale).format(_selectedDate.toUtc());
  }

  @override
  Widget build(BuildContext context) {
    _loadWhenVisible();
    final l10n = context.l10n;

    return BlocBuilder<MissionsBloc, MissionsState>(
      builder: (context, state) {
        final isLoading = state.byDayStatus == MissionsLoadStatus.loading ||
            state.byDayStatus == MissionsLoadStatus.initial;
        final missions = state.byDay != null
            ? _filterMissions(state.byDay!.missions)
            : <MissionCardEntity>[];
        final showInitialSkeleton = isLoading && state.byDay == null;

        if (state.byDayStatus == MissionsLoadStatus.error && state.byDay == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.byDayError ?? l10n.errorGeneric,
                  style: const TextStyle(color: WebColors.textSecondary),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _load,
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: WebColors.accent,
          backgroundColor: WebColors.surface,
          onRefresh: () async {
            _load();
            await context.read<MissionsBloc>().stream.firstWhere(
                  (s) =>
                      s.byDayStatus == MissionsLoadStatus.loaded ||
                      s.byDayStatus == MissionsLoadStatus.error,
                );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WebSectionHeader(
                  title: l10n.missionsByDays,
                  subtitle: _formattedSelectedDate(context),
                ),
                const SizedBox(height: 24),
                WebDaySelector(
                  selectedDate: _selectedDate,
                  onDateSelected: (d) {
                    setState(() => _selectedDate = d);
                    _load();
                  },
                ),
                const SizedBox(height: 20),
                WebFilterChips(
                  labels: [
                    l10n.filterAll,
                    l10n.filterToDo,
                    l10n.filterInProgress,
                    l10n.filterCompleted,
                  ],
                  selectedIndex: _filterIndex,
                  onSelected: (i) => setState(() => _filterIndex = i),
                ),
                const SizedBox(height: 28),
                WebSectionHeader(
                  title: _filterTitle(l10n),
                  count: showInitialSkeleton ? null : missions.length,
                ),
                const SizedBox(height: 20),
                WebAnimatedSwitcher(
                  child: showInitialSkeleton
                      ? const _WebMissionsByDayGridSkeleton(
                          key: ValueKey('by-day-skeleton'),
                        )
                      : _MissionsByDayGrid(
                          key: ValueKey(
                            '${MissionDay.toApiDate(_selectedDate)}-$_filterIndex-$isLoading-${missions.length}',
                          ),
                          isLoading: isLoading,
                          missions: missions,
                          filterIndex: _filterIndex,
                          emptyAllLabel: l10n.noMissionsForDay,
                          emptyFilterLabel: l10n.noMissionsForFilter,
                          isPastMission: _isPastMission,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _filterTitle(AppLocalizations l10n) {
    switch (_filterIndex) {
      case 1:
        return l10n.filterToDo;
      case 2:
        return l10n.filterInProgress;
      case 3:
        return l10n.filterCompleted;
      default:
        return l10n.filterAll;
    }
  }
}

class _MissionsByDayGrid extends StatelessWidget {
  const _MissionsByDayGrid({
    super.key,
    required this.isLoading,
    required this.missions,
    required this.filterIndex,
    required this.emptyAllLabel,
    required this.emptyFilterLabel,
    required this.isPastMission,
  });

  final bool isLoading;
  final List<MissionCardEntity> missions;
  final int filterIndex;
  final String emptyAllLabel;
  final String emptyFilterLabel;
  final bool Function(MissionCardEntity) isPastMission;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        key: ValueKey('by-day-loading'),
        padding: EdgeInsets.only(top: 24),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              color: WebColors.accent,
              strokeWidth: 2.5,
            ),
          ),
        ),
      );
    }

    if (missions.isEmpty) {
      return Text(
        key: const ValueKey('by-day-empty'),
        filterIndex == 0 ? emptyAllLabel : emptyFilterLabel,
        style: const TextStyle(
          color: WebColors.textMuted,
          fontSize: 13,
        ),
      );
    }

    return Wrap(
      key: const ValueKey('by-day-grid'),
      spacing: 20,
      runSpacing: 20,
      children: missions.asMap().entries.map((entry) {
        final mission = entry.value;
        return WebAnimatedAppear(
          key: ValueKey('by-day-${mission.id}'),
          staggerIndex: entry.key,
          child: mission.isWelcome
              ? WebMissionWelcomeCard(
                  mission: mission,
                  onTap: () => showMissionMatchesDialog(context, mission),
                )
              : WebMissionCard(
                  mission: mission,
                  variant: isPastMission(mission)
                      ? WebMissionCardVariant.past
                      : WebMissionCardVariant.active,
                  onTap: () => showMissionMatchesDialog(context, mission),
                ),
        );
      }).toList(),
    );
  }
}

class _WebMissionsByDayGridSkeleton extends StatelessWidget {
  const _WebMissionsByDayGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return WebShimmerScope(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: List.generate(
          4,
          (_) => const WebMissionCardSkeleton(),
        ),
      ),
    );
  }
}
