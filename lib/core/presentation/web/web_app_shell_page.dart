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
  @override
  void initState() {
    super.initState();
    context.read<RiotBloc>().add(const LoadDashboard());
    context.read<DDragonProvider>().ensureLoaded();
  }

  void _openPickMissions() {
    showPickMissionsDialog(context);
  }

  void _onSidebarTap(int branchIndex) {
    widget.navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == widget.navigationShell.currentIndex,
    );
    if (branchIndex == 0) {
      context.read<MissionsBloc>().add(const LoadMissionsHome());
    }
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
                  onAddTap: _openPickMissions,
                ),
                Expanded(
                  child: Column(
                    children: [
                      WebTopBar(
                        summoner: summoner,
                        ddragon: ddragon,
                        sectionTitle: sectionTitle,
                        showAddButton: isDashboard,
                        onAddTap: _openPickMissions,
                      ),
                      Expanded(
                        child: WebDotGridBackground(
                          child: widget.navigationShell,
                        ),
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
