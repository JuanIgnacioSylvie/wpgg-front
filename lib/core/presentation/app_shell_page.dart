import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/missions/presentation/bloc/missions_bloc.dart';
import '../../features/profile/presentation/bloc/profile_settings_bloc.dart';
import '../../features/profile/presentation/profile_leaderboard_access.dart';
import '../../features/profile/presentation/widgets/profile_privacy_dialog.dart';
import '../../features/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../features/riot/presentation/bloc/riot_event.dart';
import '../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../constants/wpgg_brand.dart';
import '../l10n/l10n_extension.dart';
import 'wpgg_bottom_nav.dart';

class AppShellPage extends StatefulWidget {
  const AppShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  @override
  void initState() {
    super.initState();
    context.read<RiotBloc>().add(const LoadDashboard());
    context.read<DDragonProvider>().ensureLoaded();
    context.read<WalletBloc>().add(const LoadWallet());
    context.read<ProfileSettingsBloc>().add(const LoadProfileSettings());
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final navIndex = wpggNavIndexForLocation(location);

    return BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
      listenWhen: (prev, curr) =>
          prev is ProfileSettingsLoaded &&
              curr is ProfileSettingsLoaded
          ? prev.profilePublic != curr.profilePublic
          : curr is ProfileSettingsLoaded,
      listener: (context, state) {
        if (!canAccessLeaderboard(state) &&
            location.startsWith('/leaderboard')) {
          context.go('/home');
        }
      },
      child: Container(
        decoration: const BoxDecoration(gradient: WpggBrand.scaffoldGradient),
        child: Stack(
          children: [
            Positioned.fill(child: widget.navigationShell),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                buildWhen: (prev, curr) =>
                    prev is ProfileSettingsLoaded &&
                        curr is ProfileSettingsLoaded
                    ? prev.profilePublic != curr.profilePublic
                    : curr is ProfileSettingsLoaded,
                builder: (context, settingsState) {
                  final showLeaderboard = canAccessLeaderboard(settingsState);

                  return WpggBottomNav(
                    currentIndex: navIndex,
                    showLeaderboard: showLeaderboard,
                    onTap: (index) {
                      if (index == 0) {
                        context.go('/home');
                        context
                            .read<MissionsBloc>()
                            .add(const LoadMissionsHome());
                        return;
                      }
                      if (index == 1) {
                        context.go('/missions/by-day');
                        return;
                      }
                      if (index == 3) {
                        final settings =
                            context.read<ProfileSettingsBloc>().state;
                        if (!canAccessLeaderboard(settings)) {
                          showProfilePrivacyDialog(
                            context,
                            body: context.l10n.leaderboardPrivateBody,
                            onOpenSettings: () => context.go('/settings'),
                          );
                          return;
                        }
                        context.go('/leaderboard');
                        context
                            .read<LeaderboardBloc>()
                            .add(const LoadLeaderboard());
                        return;
                      }
                      if (index == 4) {
                        context.go('/finance');
                        return;
                      }
                      if (index == 5) {
                        context.go('/settings');
                        return;
                      }
                    },
                    onFabTap: () => context.go('/store'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
