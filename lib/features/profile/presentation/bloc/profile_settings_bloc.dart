import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/profile_remote_datasource.dart';

part 'profile_settings_event.dart';
part 'profile_settings_state.dart';

class ProfileSettingsBloc
    extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  ProfileSettingsBloc(this._datasource) : super(const ProfileSettingsInitial()) {
    on<LoadProfileSettings>(_onLoad);
    on<UpdateProfilePublic>(_onUpdate);
  }

  final ProfileRemoteDataSource _datasource;

  Future<void> _onLoad(
    LoadProfileSettings event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(const ProfileSettingsLoading());
    try {
      final settings = await _datasource.fetchSettings();
      emit(ProfileSettingsLoaded(profilePublic: settings.profilePublic));
    } catch (e) {
      emit(ProfileSettingsError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateProfilePublic event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final previous = state;
    if (previous is ProfileSettingsLoaded) {
      emit(ProfileSettingsLoaded(
        profilePublic: event.profilePublic,
        saving: true,
      ));
    }
    try {
      final settings = await _datasource.updateSettings(
        profilePublic: event.profilePublic,
      );
      emit(ProfileSettingsLoaded(profilePublic: settings.profilePublic));
    } catch (e) {
      if (previous is ProfileSettingsLoaded) {
        emit(ProfileSettingsLoaded(
          profilePublic: previous.profilePublic,
          errorMessage: e.toString(),
        ));
      } else {
        emit(ProfileSettingsError(e.toString()));
      }
    }
  }
}
