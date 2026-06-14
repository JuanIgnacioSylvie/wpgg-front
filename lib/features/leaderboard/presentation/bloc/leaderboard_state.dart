part of 'leaderboard_bloc.dart';

sealed class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object?> get props => [];
}

class LeaderboardInitial extends LeaderboardState {
  const LeaderboardInitial();
}

class LeaderboardLoading extends LeaderboardState {
  const LeaderboardLoading();
}

class LeaderboardLoaded extends LeaderboardState {
  const LeaderboardLoaded({required this.response});

  final LeaderboardResponse response;

  List<LeaderboardEntry> get entries => response.entries;

  @override
  List<Object?> get props => [response];
}

class LeaderboardError extends LeaderboardState {
  const LeaderboardError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
