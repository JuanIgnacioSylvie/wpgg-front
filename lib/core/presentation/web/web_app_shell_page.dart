import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../../../features/missions/presentation/bloc/missions_bloc.dart';
import '../../../features/missions/presentation/widgets/pick_missions_dialog.dart';
import '../../../features/riot/domain/entities/summoner_entity.dart';
import '../../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../../features/riot/presentation/bloc/riot_event.dart';
import '../../../features/riot/presentation/bloc/riot_state.dart';
import 'web_dot_grid_background.dart';
import 'web_profile_panel.dart';
import 'web_shell_scope.dart';
import 'web_sidebar.dart';
import 'web_top_bar.dart';

class WebAppShellPage extends StatefulWidget {
  const WebAppShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<WebAppShellPage> createState() => _WebAppShellPageState();
}

class _WebAppShellPageState extends State<WebAppShellPage> {
  var _profilePanelOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<RiotBloc>().add(const LoadDashboard());
    context.read<DDragonProvider>().ensureLoaded();
    context.read<MissionsBloc>().add(const LoadMissionsHome());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final location = GoRouterState.of(context).uri.path;
      if (location.startsWith('/profile')) {
        setState(() => _profilePanelOpen = true);
        if (widget.navigationShell.currentIndex == 3) {
          widget.navigationShell.goBranch(0, initialLocation: true);
        }
      }
    });
  }

  void _openPickMissions() {
    showPickMissionsDialog(context);
  }

  void _onSidebarTap(int branchIndex) {
    setState(() => _profilePanelOpen = false);
    widget.navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == widget.navigationShell.currentIndex,
    );
    if (branchIndex == 0) {
      context.read<MissionsBloc>().add(const LoadMissionsHome());
    }
  }

  void _openProfilePanel() {
    setState(() => _profilePanelOpen = true);
  }

  void _closeProfilePanel() {
    setState(() => _profilePanelOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final sidebarIndex = webSidebarIndexForLocation(location);
    final sectionTitle = webSectionTitleForLocation(location);
    final isDashboard = sidebarIndex == 0;

    return WebShellScope(
      onAddMission: _openPickMissions,
      child: BlocBuilder<RiotBloc, RiotState>(
        builder: (context, riotState) {
          SummonerEntity? summoner;
          if (riotState is RiotLoaded) {
            summoner = riotState.summoner;
          }

          final ddragon = context.watch<DDragonProvider>();

          return Material(
            color: Colors.black,
            child: Row(
              children: [
                WebSidebar(
                  currentIndex: sidebarIndex,
                  onTap: _onSidebarTap,
                  onProfileTap: _openProfilePanel,
                  profileSelected: _profilePanelOpen,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          BlocBuilder<MissionsBloc, MissionsState>(
                            buildWhen: (prev, curr) =>
                                prev.home?.endsInSeconds !=
                                    curr.home?.endsInSeconds ||
                                prev.home != curr.home,
                            builder: (context, missionsState) {
                              final home = missionsState.home;
                              final endsIn =
                                  isDashboard ? home?.endsInSeconds : null;
                              final activeCount = home == null
                                  ? 0
                                  : (home.primary != null ? 1 : 0) +
                                      home.secondary.length;

                              return WebTopBar(
                                summoner: summoner,
                                ddragon: ddragon,
                                sectionTitle: sectionTitle,
                                showAddButton: isDashboard,
                                addButtonEnabled: activeCount < 3,
                                showDayCountdown: isDashboard &&
                                    endsIn != null &&
                                    endsIn > 0,
                                dayEndsInSeconds: endsIn,
                                onAddTap: _openPickMissions,
                                onProfileTap: _openProfilePanel,
                              );
                            },
                          ),
                          Expanded(
                            child: WebDotGridBackground(
                              child: widget.navigationShell,
                            ),
                          ),
                        ],
                      ),
                      if (_profilePanelOpen)
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: WebProfilePanel(onClose: _closeProfilePanel),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
