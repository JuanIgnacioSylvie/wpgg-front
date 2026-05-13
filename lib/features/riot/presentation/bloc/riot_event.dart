import 'package:equatable/equatable.dart';

abstract class RiotEvent extends Equatable {
  const RiotEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends RiotEvent {
  const LoadDashboard();
}

class LinkRiotAccount extends RiotEvent {
  const LinkRiotAccount({
    required this.gameName,
    required this.tagLine,
    required this.region,
  });

  final String gameName;
  final String tagLine;
  final String region;

  @override
  List<Object?> get props => [gameName, tagLine, region];
}

class RefreshMatchHistory extends RiotEvent {
  const RefreshMatchHistory();
}
