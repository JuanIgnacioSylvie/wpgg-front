import 'package:equatable/equatable.dart';

class MissionProgressLine extends Equatable {
  const MissionProgressLine({
    required this.current,
    required this.target,
  });

  final int current;
  final int target;

  @override
  List<Object?> get props => [current, target];
}
