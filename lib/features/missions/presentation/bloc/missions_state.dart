part of 'missions_bloc.dart';

enum MissionsLoadStatus { initial, loading, loaded, error }

class MissionsHomeData extends Equatable {
  const MissionsHomeData({
    required this.primary,
    required this.secondary,
    required this.past,
    required this.endsInSeconds,
    required this.missionDate,
    required this.missionDayTimezone,
  });

  final MissionCardEntity? primary;
  final List<MissionCardEntity> secondary;
  final List<MissionCardEntity> past;
  final int endsInSeconds;
  final String missionDate;
  final String missionDayTimezone;

  @override
  List<Object?> get props =>
      [primary, secondary, past, endsInSeconds, missionDate, missionDayTimezone];
}

class MissionsPickData extends Equatable {
  const MissionsPickData({
    required this.date,
    required this.offers,
    required this.selectedCount,
    required this.maxSelectable,
    required this.maxHard,
  });

  final String date;
  final List<MissionCardEntity> offers;
  final int selectedCount;
  final int maxSelectable;
  final int maxHard;

  @override
  List<Object?> get props => [date, offers, selectedCount, maxSelectable, maxHard];
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
      ];
}
