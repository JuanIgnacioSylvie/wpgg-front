import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/missions_remote_datasource.dart';
import '../../domain/entities/mission_card_entity.dart';

part 'missions_event.dart';
part 'missions_state.dart';

class MissionsBloc extends Bloc<MissionsEvent, MissionsState> {
  MissionsBloc(this._dataSource) : super(const MissionsState()) {
    on<LoadMissionsHome>(_onHome);
    on<LoadPickToday>(_onPick);
    on<LoadMissionsByDay>(_onByDay);
    on<AcceptMissionOffer>(_onAccept);
    on<RerollMissionOffer>(_onReroll);
  }

  final MissionsRemoteDataSource _dataSource;

  Future<void> _onHome(
    LoadMissionsHome event,
    Emitter<MissionsState> emit,
  ) async {
    emit(state.copyWith(
      homeStatus: MissionsLoadStatus.loading,
      clearHomeError: true,
    ));
    try {
      final home = await _dataSource.fetchHome();
      emit(state.copyWith(
        homeStatus: MissionsLoadStatus.loaded,
        home: MissionsHomeData(
          primary: home.primary,
          secondary: home.secondary,
          past: home.past,
          endsInSeconds: home.endsInSeconds,
          missionDate: home.missionDate,
          missionDayTimezone: home.missionDayTimezone,
        ),
        clearHomeError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        homeStatus: MissionsLoadStatus.error,
        homeError: e.toString(),
      ));
    }
  }

  Future<void> _onPick(
    LoadPickToday event,
    Emitter<MissionsState> emit,
  ) async {
    emit(state.copyWith(
      pickStatus: MissionsLoadStatus.loading,
      clearPickError: true,
    ));
    try {
      final pick = await _dataSource.fetchPickToday();
      emit(state.copyWith(
        pickStatus: MissionsLoadStatus.loaded,
        pick: MissionsPickData(
          date: pick.date,
          offers: pick.offers,
          selectedCount: pick.selectedCount,
          maxSelectable: pick.maxSelectable,
          maxHard: pick.maxHard,
        ),
        clearPickError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        pickStatus: MissionsLoadStatus.error,
        pickError: e.toString(),
      ));
    }
  }

  Future<void> _onByDay(
    LoadMissionsByDay event,
    Emitter<MissionsState> emit,
  ) async {
    emit(state.copyWith(
      byDayStatus: MissionsLoadStatus.loading,
      clearByDayError: true,
    ));
    try {
      final missions = await _dataSource.fetchByDay(event.date);
      emit(state.copyWith(
        byDayStatus: MissionsLoadStatus.loaded,
        byDay: MissionsByDayData(
          date: event.date,
          missions: missions,
        ),
        clearByDayError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        byDayStatus: MissionsLoadStatus.error,
        byDayError: e.toString(),
      ));
    }
  }

  Future<void> _onAccept(
    AcceptMissionOffer event,
    Emitter<MissionsState> emit,
  ) async {
    try {
      await _dataSource.acceptOffer(event.offerId);
      add(const LoadPickToday());
      add(const LoadMissionsHome());
    } catch (e) {
      emit(state.copyWith(pickError: e.toString()));
    }
  }

  Future<void> _onReroll(
    RerollMissionOffer event,
    Emitter<MissionsState> emit,
  ) async {
    try {
      await _dataSource.rerollOffer(event.offerId);
      add(const LoadPickToday());
    } catch (e) {
      emit(state.copyWith(pickError: e.toString()));
    }
  }
}
