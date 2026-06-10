import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/network_error_message.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
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
    on<CancelActiveMission>(_onCancel);
    on<ClearMissionActionFeedback>(_onClearActionFeedback);
  }

  final MissionsRemoteDataSource _dataSource;

  void _refreshWallet() {
    sl<WalletBloc>().add(const LoadWallet());
  }

  String _missionErrorMessage(Object error) => networkErrorMessage(error);

  Future<void> _onHome(
    LoadMissionsHome event,
    Emitter<MissionsState> emit,
  ) async {
    final hasCachedHome = state.home != null;
    if (!hasCachedHome) {
      emit(state.copyWith(
        homeStatus: MissionsLoadStatus.loading,
        clearHomeError: true,
      ));
    }
    try {
      final home = await _dataSource.fetchHome();
      emit(state.copyWith(
        homeStatus: MissionsLoadStatus.loaded,
        home: MissionsHomeData(
          welcome: home.welcome,
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
      if (hasCachedHome) {
        // Mantener datos visibles si un refresh en segundo plano falla.
        emit(state.copyWith(
          homeStatus: MissionsLoadStatus.loaded,
          clearHomeError: true,
        ));
        return;
      }
      emit(state.copyWith(
        homeStatus: MissionsLoadStatus.error,
        homeError: networkErrorMessage(e),
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

  void _onClearActionFeedback(
    ClearMissionActionFeedback event,
    Emitter<MissionsState> emit,
  ) {
    emit(state.copyWith(clearActionFeedback: true));
  }

  Future<void> _onAccept(
    AcceptMissionOffer event,
    Emitter<MissionsState> emit,
  ) async {
    if (state.actionInProgress != null) {
      return;
    }
    emit(state.copyWith(
      actionInProgress: MissionActionType.accept,
      clearActionFeedback: true,
    ));
    try {
      await _dataSource.acceptOffer(event.offerId);
      _refreshWallet();
      emit(state.copyWith(
        clearActionInProgress: true,
        actionFeedback: const MissionActionFeedback(
          type: MissionActionType.accept,
          success: true,
        ),
      ));
      add(const LoadPickToday());
      add(const LoadMissionsHome());
    } catch (e) {
      emit(state.copyWith(
        clearActionInProgress: true,
        actionFeedback: MissionActionFeedback(
          type: MissionActionType.accept,
          success: false,
          message: _missionErrorMessage(e),
        ),
      ));
    }
  }

  Future<void> _onReroll(
    RerollMissionOffer event,
    Emitter<MissionsState> emit,
  ) async {
    if (state.actionInProgress != null) {
      return;
    }
    emit(state.copyWith(
      actionInProgress: MissionActionType.reroll,
      clearActionFeedback: true,
    ));
    try {
      await _dataSource.rerollOffer(event.offerId);
      _refreshWallet();
      emit(state.copyWith(
        clearActionInProgress: true,
        actionFeedback: const MissionActionFeedback(
          type: MissionActionType.reroll,
          success: true,
        ),
      ));
      add(const LoadPickToday());
    } catch (e) {
      emit(state.copyWith(
        clearActionInProgress: true,
        actionFeedback: MissionActionFeedback(
          type: MissionActionType.reroll,
          success: false,
          message: _missionErrorMessage(e),
        ),
      ));
    }
  }

  Future<void> _onCancel(
    CancelActiveMission event,
    Emitter<MissionsState> emit,
  ) async {
    if (state.actionInProgress != null) {
      return;
    }
    emit(state.copyWith(
      actionInProgress: MissionActionType.cancel,
      clearActionFeedback: true,
    ));
    try {
      await _dataSource.cancelActiveMission(event.missionId);
      _refreshWallet();
      emit(state.copyWith(
        clearActionInProgress: true,
        actionFeedback: const MissionActionFeedback(
          type: MissionActionType.cancel,
          success: true,
        ),
      ));
      add(const LoadMissionsHome());
      add(const LoadPickToday());
    } catch (e) {
      emit(state.copyWith(
        clearActionInProgress: true,
        actionFeedback: MissionActionFeedback(
          type: MissionActionType.cancel,
          success: false,
          message: _missionErrorMessage(e),
        ),
      ));
    }
  }
}
