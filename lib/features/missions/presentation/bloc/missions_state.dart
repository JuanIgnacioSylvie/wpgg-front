part of 'missions_bloc.dart';

sealed class MissionsState extends Equatable {
  const MissionsState();

  @override
  List<Object?> get props => [];
}

class MissionsInitial extends MissionsState {
  const MissionsInitial();
}

class MissionsLoading extends MissionsState {
  const MissionsLoading();
}

class MissionsHomeLoaded extends MissionsState {
  const MissionsHomeLoaded({
    required this.primary,
    required this.secondary,
    required this.past,
    required this.endsInSeconds,
  });

  final MissionCardEntity? primary;
  final List<MissionCardEntity> secondary;
  final List<MissionCardEntity> past;
  final int endsInSeconds;

  @override
  List<Object?> get props => [primary, secondary, past, endsInSeconds];
}

class MissionsPickLoaded extends MissionsState {
  const MissionsPickLoaded({
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
  List<Object?> get props => [date, offers, selectedCount];
}

class MissionsByDayLoaded extends MissionsState {
  const MissionsByDayLoaded({
    required this.date,
    required this.missions,
  });

  final String? date;
  final List<MissionCardEntity> missions;

  @override
  List<Object?> get props => [date, missions];
}

class MissionsError extends MissionsState {
  const MissionsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
