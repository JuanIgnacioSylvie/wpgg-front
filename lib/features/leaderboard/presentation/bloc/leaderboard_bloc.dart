import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../profile/data/datasources/profile_remote_datasource.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc(this._datasource) : super(const LeaderboardInitial()) {
    on<LoadLeaderboard>(_onLoad);
  }

  final ProfileRemoteDataSource _datasource;

  Future<void> _onLoad(
    LoadLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(const LeaderboardLoading());
    try {
      final entries = await _datasource.fetchLeaderboard();
      emit(LeaderboardLoaded(entries: entries));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }
}
