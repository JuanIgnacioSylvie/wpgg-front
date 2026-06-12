import 'bloc/profile_settings_bloc.dart';

bool canAccessLeaderboard(ProfileSettingsState state) {
  return state is ProfileSettingsLoaded && state.profilePublic;
}
