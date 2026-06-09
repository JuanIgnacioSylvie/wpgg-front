import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/ranked_entry_entity.dart';
import '../../domain/entities/summoner_entity.dart';
import '../../domain/usecases/get_match_history_usecase.dart';
import '../../domain/usecases/get_ranked_stats_usecase.dart';
import '../../domain/usecases/get_summoner_profile_usecase.dart';
import '../../domain/usecases/link_riot_account_usecase.dart';
import 'riot_event.dart';
import 'riot_state.dart';

class RiotBloc extends Bloc<RiotEvent, RiotState> {
  RiotBloc({
    required GetSummonerProfileUseCase getSummonerProfile,
    required GetMatchHistoryUseCase getMatchHistory,
    required GetRankedStatsUseCase getRankedStats,
    required LinkRiotAccountUseCase linkRiotAccount,
  })  : _getSummonerProfile = getSummonerProfile,
        _getMatchHistory = getMatchHistory,
        _getRankedStats = getRankedStats,
        _linkRiotAccount = linkRiotAccount,
        super(const RiotInitial()) {
    on<LoadDashboard>(_onLoad);
    on<LinkRiotAccount>(_onLink);
    on<RefreshMatchHistory>(_onRefreshMatches);
  }

  final GetSummonerProfileUseCase _getSummonerProfile;
  final GetMatchHistoryUseCase _getMatchHistory;
  final GetRankedStatsUseCase _getRankedStats;
  final LinkRiotAccountUseCase _linkRiotAccount;

  Future<void> _onLoad(LoadDashboard event, Emitter<RiotState> emit) async {
    final previous = state;
    if (previous is! RiotLoaded) {
      emit(const RiotLoading());
    }

    final summonerRes = await _getSummonerProfile();
    final summonerFail = summonerRes.fold<Failure?>((f) => f, (_) => null);
    if (summonerFail != null) {
      if (previous is RiotLoaded) {
        emit(previous);
        return;
      }
      emit(RiotError(summonerFail.message));
      return;
    }
    final summoner = summonerRes.fold<SummonerEntity?>((_) => null, (s) => s);
    if (summoner == null) {
      emit(const RiotNoAccount());
      return;
    }

    final results = await Future.wait([
      _getMatchHistory(limit: 10),
      _getRankedStats(),
    ]);
    final matchesRes = results[0] as Either<Failure, List<MatchEntity>>;
    final rankedRes = results[1] as Either<Failure, List<RankedEntryEntity>>;

    final matches = matchesRes.fold<List<MatchEntity>>(
      (_) => previous is RiotLoaded ? previous.matches : const [],
      (m) => m,
    );
    final ranked = rankedRes.fold<List<RankedEntryEntity>>(
      (_) => previous is RiotLoaded ? previous.rankedEntries : const [],
      (r) => r,
    );

    emit(
      RiotLoaded(
        summoner: summoner,
        matches: matches,
        rankedEntries: ranked,
      ),
    );
  }

  Future<void> _onLink(LinkRiotAccount event, Emitter<RiotState> emit) async {
    emit(const RiotLoading());
    final res = await _linkRiotAccount(
      gameName: event.gameName,
      tagLine: event.tagLine,
      region: event.region,
    );
    final fail = res.fold<Failure?>((f) => f, (_) => null);
    if (fail != null) {
      emit(RiotError(fail.message));
      return;
    }
    emit(const RiotAccountLinked());
  }

  Future<void> _onRefreshMatches(
    RefreshMatchHistory event,
    Emitter<RiotState> emit,
  ) async {
    final current = state;
    if (current is! RiotLoaded) {
      add(const LoadDashboard());
      return;
    }
    final matchesRes = await _getMatchHistory(limit: 10);
    final fail = matchesRes.fold<Failure?>((f) => f, (_) => null);
    if (fail != null) {
      emit(RiotError(fail.message));
      return;
    }
    final list = matchesRes.fold<List<MatchEntity>>((_) => const [], (m) => m);
    emit(
      RiotLoaded(
        summoner: current.summoner,
        matches: list,
        rankedEntries: current.rankedEntries,
      ),
    );
  }
}
