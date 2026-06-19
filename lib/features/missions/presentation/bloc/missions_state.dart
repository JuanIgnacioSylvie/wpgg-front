part of 'missions_bloc.dart';

enum MissionsLoadStatus { initial, loading, loaded, error }

enum MissionActionType { accept, reroll, cancel, claim }

enum MissionSyncUiStatus {
  hidden,
  unknown,
  upToDate,
  updatesAvailable,
  syncing,
  error,
}

class MissionActionFeedback extends Equatable {
  const MissionActionFeedback({
    required this.type,
    required this.success,
    this.message,
  });

  final MissionActionType type;
  final bool success;
  final String? message;

  @override
  List<Object?> get props => [type, success, message];
}

class MissionsHomeData extends Equatable {
  const MissionsHomeData({
    this.welcome,
    required this.primary,
    required this.secondary,
    required this.completed,
    required this.past,
    required this.endsInSeconds,
    required this.missionDate,
    required this.missionDayTimezone,
  });

  final MissionCardEntity? welcome;
  final MissionCardEntity? primary;
  final List<MissionCardEntity> secondary;
  final List<MissionCardEntity> completed;
  final List<MissionCardEntity> past;
  final int endsInSeconds;
  final String missionDate;
  final String missionDayTimezone;

  @override
  List<Object?> get props => [
        welcome,
        primary,
        secondary,
        completed,
        past,
        endsInSeconds,
        missionDate,
        missionDayTimezone,
      ];
}

class MissionsPickData extends Equatable {
  const MissionsPickData({
    required this.offers,
    required this.activeCount,
    required this.hardActiveCount,
    required this.maxActive,
    required this.maxHard,
    required this.offersPerDifficulty,
    required this.offersRefreshAt,
    required this.offersRefreshInSeconds,
  });

  final List<MissionCardEntity> offers;
  final int activeCount;
  final int hardActiveCount;
  final int maxActive;
  final int maxHard;
  final int offersPerDifficulty;
  final DateTime? offersRefreshAt;
  final int offersRefreshInSeconds;

  @override
  List<Object?> get props => [
        offers,
        activeCount,
        hardActiveCount,
        maxActive,
        maxHard,
        offersPerDifficulty,
        offersRefreshAt,
        offersRefreshInSeconds,
      ];
}

class MissionsByDayData extends Equatable {
  const MissionsByDayData({
    required this.date,
    required this.missions,
  });

  final String? date;
  final List<MissionCardEntity> missions;

  @override
  List<Object?> get props => [date, missions];
}

class MissionsState extends Equatable {
  const MissionsState({
    this.homeStatus = MissionsLoadStatus.initial,
    this.home,
    this.homeError,
    this.pickStatus = MissionsLoadStatus.initial,
    this.pick,
    this.pickError,
    this.byDayStatus = MissionsLoadStatus.initial,
    this.byDay,
    this.byDayError,
    this.actionInProgress,
    this.actionFeedback,
    this.missionSyncStatus = MissionSyncUiStatus.hidden,
    this.missionSyncError,
  });

  final MissionsLoadStatus homeStatus;
  final MissionsHomeData? home;
  final String? homeError;

  final MissionsLoadStatus pickStatus;
  final MissionsPickData? pick;
  final String? pickError;

  final MissionsLoadStatus byDayStatus;
  final MissionsByDayData? byDay;
  final String? byDayError;

  final MissionActionType? actionInProgress;
  final MissionActionFeedback? actionFeedback;

  final MissionSyncUiStatus missionSyncStatus;
  final String? missionSyncError;

  MissionsState copyWith({
    MissionsLoadStatus? homeStatus,
    MissionsHomeData? home,
    String? homeError,
    bool clearHomeError = false,
    MissionsLoadStatus? pickStatus,
    MissionsPickData? pick,
    String? pickError,
    bool clearPickError = false,
    MissionsLoadStatus? byDayStatus,
    MissionsByDayData? byDay,
    String? byDayError,
    bool clearByDayError = false,
    MissionActionType? actionInProgress,
    bool clearActionInProgress = false,
    MissionActionFeedback? actionFeedback,
    bool clearActionFeedback = false,
    MissionSyncUiStatus? missionSyncStatus,
    String? missionSyncError,
    bool clearMissionSyncError = false,
  }) {
    return MissionsState(
      homeStatus: homeStatus ?? this.homeStatus,
      home: home ?? this.home,
      homeError: clearHomeError ? null : (homeError ?? this.homeError),
      pickStatus: pickStatus ?? this.pickStatus,
      pick: pick ?? this.pick,
      pickError: clearPickError ? null : (pickError ?? this.pickError),
      byDayStatus: byDayStatus ?? this.byDayStatus,
      byDay: byDay ?? this.byDay,
      byDayError: clearByDayError ? null : (byDayError ?? this.byDayError),
      actionInProgress: clearActionInProgress
          ? null
          : (actionInProgress ?? this.actionInProgress),
      actionFeedback: clearActionFeedback
          ? null
          : (actionFeedback ?? this.actionFeedback),
      missionSyncStatus: missionSyncStatus ?? this.missionSyncStatus,
      missionSyncError: clearMissionSyncError
          ? null
          : (missionSyncError ?? this.missionSyncError),
    );
  }

  @override
  List<Object?> get props => [
        homeStatus,
        home,
        homeError,
        pickStatus,
        pick,
        pickError,
        byDayStatus,
        byDay,
        byDayError,
        actionInProgress,
        actionFeedback,
        missionSyncStatus,
        missionSyncError,
      ];
}
