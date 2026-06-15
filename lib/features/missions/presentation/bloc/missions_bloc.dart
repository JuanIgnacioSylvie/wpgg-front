import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/network_error_message.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../data/datasources/missions_remote_datasource.dart';
import '../../data/mission_layout_store.dart';
import '../../domain/entities/mission_card_entity.dart';
import '../utils/mission_layout_utils.dart';

part 'missions_event.dart';
part 'missions_state.dart';

class MissionsBloc extends Bloc<MissionsEvent, MissionsState> {
  MissionsBloc(this._dataSource, this._layoutStore) : super(const MissionsState()) {
    on<LoadMissionsHome>(_onHome);
    on<LoadPickToday>(_onPick);
    on<LoadMissionsByDay>(_onByDay);
    on<AcceptMissionOffer>(_onAccept);
    on<RerollMissionOffer>(_onReroll);
    on<CancelActiveMission>(_onCancel);
    on<ReorderActiveMissions>(_onReorder);
    on<ClearMissionActionFeedback>(_onClearActionFeedback);
    on<CheckMissionSyncStatus>(_onCheckSyncStatus);
    on<SyncMissionsNow>(_onSyncNow);
  }

  final MissionsRemoteDataSource _dataSource;
  final MissionLayoutStore _layoutStore;

  void _refreshWallet() {
    sl<WalletBloc>().add(const LoadWallet());
  }

  String _missionErrorMessage(Object error) => networkErrorMessage(error);

  bool _homeHasSyncableMissions(MissionsHomeData? home) {
    if (home == null) return false;
    return home.welcome != null ||
        home.primary != null ||
        home.secondary.isNotEmpty;
  }

  MissionSyncUiStatus _uiStatusFromApi(MissionSyncApiStatus status) {
    return switch (status) {
      MissionSyncApiStatus.noActiveMissions => MissionSyncUiStatus.hidden,
      MissionSyncApiStatus.upToDate => MissionSyncUiStatus.upToDate,
      MissionSyncApiStatus.updatesAvailable =>
        MissionSyncUiStatus.updatesAvailable,
    };
  }

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
      final baseHome = MissionsHomeData(
        welcome: home.welcome,
        primary: home.primary,
        secondary: home.secondary,
        past: home.past,
        endsInSeconds: home.endsInSeconds,
        missionDate: home.missionDate,
        missionDayTimezone: home.missionDayTimezone,
      );
      final active = activeMissionsFromHome(baseHome);
      final savedOrder = _layoutStore.loadOrder(home.missionDate);
      final ordered = applySavedOrder(active, savedOrder);
      emit(state.copyWith(
        homeStatus: MissionsLoadStatus.loaded,
        home: homeFromOrderedMissions(baseHome, ordered),
        clearHomeError: true,
      ));
      if (_homeHasSyncableMissions(baseHome)) {
        emit(state.copyWith(missionSyncStatus: MissionSyncUiStatus.unknown));
        add(const CheckMissionSyncStatus());
      } else {
        emit(state.copyWith(missionSyncStatus: MissionSyncUiStatus.hidden));
      }
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

  Future<void> _onReorder(
    ReorderActiveMissions event,
    Emitter<MissionsState> emit,
  ) async {
    final home = state.home;
    if (home == null) return;

    final active = activeMissionsFromHome(home);
    final reordered = reorderMissions(
      active,
      event.draggedId,
      event.targetId,
    );
    if (listEquals(
      active.map((mission) => mission.id).toList(),
      reordered.map((mission) => mission.id).toList(),
    )) {
      return;
    }

    final updatedHome = homeFromOrderedMissions(home, reordered);
    emit(state.copyWith(home: updatedHome));
    await _layoutStore.saveOrder(
      home.missionDate,
      reordered.map((mission) => mission.id).toList(),
    );
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

  Future<void> _onCheckSyncStatus(
    CheckMissionSyncStatus event,
    Emitter<MissionsState> emit,
  ) async {
    if (state.missionSyncStatus == MissionSyncUiStatus.syncing) {
      return;
    }
    if (!_homeHasSyncableMissions(state.home)) {
      emit(state.copyWith(missionSyncStatus: MissionSyncUiStatus.hidden));
      return;
    }

    try {
      final status = await _dataSource.fetchSyncStatus();
      emit(state.copyWith(
        missionSyncStatus: _uiStatusFromApi(status.status),
        clearMissionSyncError: true,
      ));
    } catch (e) {
      if (state.missionSyncStatus == MissionSyncUiStatus.hidden ||
          state.missionSyncStatus == MissionSyncUiStatus.unknown) {
        emit(state.copyWith(
          missionSyncStatus: MissionSyncUiStatus.updatesAvailable,
          clearMissionSyncError: true,
        ));
        return;
      }
      emit(state.copyWith(
        missionSyncStatus: MissionSyncUiStatus.error,
        missionSyncError: _missionErrorMessage(e),
      ));
    }
  }

  Future<void> _onSyncNow(
    SyncMissionsNow event,
    Emitter<MissionsState> emit,
  ) async {
    if (state.missionSyncStatus == MissionSyncUiStatus.syncing) {
      return;
    }

    emit(state.copyWith(
      missionSyncStatus: MissionSyncUiStatus.syncing,
      clearMissionSyncError: true,
    ));

    try {
      await _dataSource.syncMatches();
      _refreshWallet();
      add(const LoadMissionsHome());
      emit(state.copyWith(
        missionSyncStatus: MissionSyncUiStatus.upToDate,
        clearMissionSyncError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        missionSyncStatus: MissionSyncUiStatus.error,
        missionSyncError: _missionErrorMessage(e),
      ));
    }
  }
}
