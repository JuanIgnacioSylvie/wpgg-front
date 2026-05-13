import 'package:equatable/equatable.dart';

import '../../domain/entities/match_entity.dart';
import '../../domain/entities/ranked_entry_entity.dart';
import '../../domain/entities/summoner_entity.dart';

abstract class RiotState extends Equatable {
  const RiotState();

  @override
  List<Object?> get props => [];
}

class RiotInitial extends RiotState {
  const RiotInitial();
}

class RiotLoading extends RiotState {
  const RiotLoading();
}

class RiotLoaded extends RiotState {
  const RiotLoaded({
    required this.summoner,
    required this.matches,
    required this.rankedEntries,
  });

  final SummonerEntity summoner;
  final List<MatchEntity> matches;
  final List<RankedEntryEntity> rankedEntries;

  @override
  List<Object?> get props => [summoner, matches, rankedEntries];
}

class RiotNoAccount extends RiotState {
  const RiotNoAccount();
}

/// Cuenta vinculada correctamente; la UI debe disparar [LoadDashboard].
class RiotAccountLinked extends RiotState {
  const RiotAccountLinked();
}

class RiotError extends RiotState {
  const RiotError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
