import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/missions/presentation/bloc/missions_bloc.dart';
import '../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../features/riot/presentation/bloc/riot_event.dart';
import '../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../router/app_router.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final navIndex = wpggNavIndexForLocation(location);

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: WpggBottomNav(
        currentIndex: navIndex,
        onTap: (index) {
          final branch = shellBranchIndexForNav(index);
          widget.navigationShell.goBranch(branch);
          if (index == 0) {
            context.read<MissionsBloc>().add(const LoadMissionsHome());
          }
        },
        onFabTap: () => context.push('/missions/pick'),
      ),
    );
  }
}
