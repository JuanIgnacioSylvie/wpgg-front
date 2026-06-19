import '../bloc/missions_bloc.dart';
import '../../domain/entities/mission_card_entity.dart';

List<MissionCardEntity> activeMissionsFromHome(MissionsHomeData home) {
  return [
    if (home.primary != null) home.primary!,
    ...home.secondary,
  ];
}

List<MissionCardEntity> applySavedOrder(
  List<MissionCardEntity> missions,
  List<String>? savedOrder,
) {
  if (savedOrder == null || savedOrder.isEmpty || missions.isEmpty) {
    return missions;
  }

  final byId = {for (final mission in missions) mission.id: mission};
  final ordered = <MissionCardEntity>[];

  for (final id in savedOrder) {
    final mission = byId.remove(id);
    if (mission != null) ordered.add(mission);
  }

  ordered.addAll(byId.values);
  return ordered;
}

List<MissionCardEntity> reorderMissions(
  List<MissionCardEntity> missions,
  String draggedId,
  String targetId,
) {
  if (draggedId == targetId) return missions;

  final list = [...missions];
  final fromIndex = list.indexWhere((mission) => mission.id == draggedId);
  final toIndex = list.indexWhere((mission) => mission.id == targetId);
  if (fromIndex == -1 || toIndex == -1) return missions;

  final item = list.removeAt(fromIndex);
  list.insert(toIndex, item);
  return list;
}

MissionsHomeData homeFromOrderedMissions(
  MissionsHomeData home,
  List<MissionCardEntity> ordered,
) {
  return MissionsHomeData(
    welcome: home.welcome,
    primary: ordered.isEmpty ? null : ordered.first,
    secondary: ordered.length <= 1 ? const [] : ordered.sublist(1),
    completed: home.completed,
    past: home.past,
    endsInSeconds: home.endsInSeconds,
    missionDate: home.missionDate,
    missionDayTimezone: home.missionDayTimezone,
  );
}
