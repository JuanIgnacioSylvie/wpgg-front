part of 'missions_bloc.dart';

sealed class MissionsEvent extends Equatable {
  const MissionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMissionsHome extends MissionsEvent {
  const LoadMissionsHome();
}

class LoadPickToday extends MissionsEvent {
  const LoadPickToday();
}

class LoadMissionsByDay extends MissionsEvent {
  const LoadMissionsByDay({this.date});

  final String? date;

  @override
  List<Object?> get props => [date];
}

class AcceptMissionOffer extends MissionsEvent {
  const AcceptMissionOffer(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

class RerollMissionOffer extends MissionsEvent {
  const RerollMissionOffer(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

class CancelActiveMission extends MissionsEvent {
  const CancelActiveMission(this.missionId);

  final String missionId;

  @override
  List<Object?> get props => [missionId];
}

class ReorderActiveMissions extends MissionsEvent {
  const ReorderActiveMissions({
    required this.draggedId,
    required this.targetId,
  });

  final String draggedId;
  final String targetId;

  @override
  List<Object?> get props => [draggedId, targetId];
}

class ClearMissionActionFeedback extends MissionsEvent {
  const ClearMissionActionFeedback();
}
