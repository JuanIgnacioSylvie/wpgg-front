import '../../domain/entities/mission_card_entity.dart';
import '../bloc/missions_bloc.dart';

bool canAcceptMissionOffer(
  MissionCardEntity mission,
  MissionsPickData pick,
) {
  if (pick.activeCount >= pick.maxActive) {
    return false;
  }
  if (mission.difficulty == MissionDifficulty.hard &&
      pick.hardActiveCount >= pick.maxHard) {
    return false;
  }
  return true;
}

bool canPickMoreMissions(MissionsPickData pick) {
  return pick.activeCount < pick.maxActive;
}
