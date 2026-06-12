import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/profile_remote_datasource.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc(this._datasource) : super(const UserProfileInitial()) {
    on<LoadUserProfile>(_onLoad);
  }

  final ProfileRemoteDataSource _datasource;

  Future<void> _onLoad(
    LoadUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(const UserProfileLoading());
    try {
      final profile = await _datasource.fetchUserProfile(event.userId);
      emit(UserProfileLoaded(profile: profile));
    } on ProfileAccessException catch (e) {
      emit(UserProfileAccessDenied(code: e.code));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }
}
