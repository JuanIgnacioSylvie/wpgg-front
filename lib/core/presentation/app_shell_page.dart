import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/missions/presentation/bloc/missions_bloc.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../features/riot/presentation/bloc/riot_event.dart';
import '../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../constants/wpgg_brand.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final navIndex = wpggNavIndexForLocation(location);

    return Container(
      decoration: const BoxDecoration(gradient: WpggBrand.scaffoldGradient),
      child: Stack(
        children: [
          Positioned.fill(child: widget.navigationShell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WpggBottomNav(
              currentIndex: navIndex,
              onTap: (index) {
                if (index == 0) {
                  context.go('/home');
                  context.read<MissionsBloc>().add(const LoadMissionsHome());
                  return;
                }
                if (index == 1) {
                  context.go('/missions/by-day');
                  return;
                }
                if (index == 3) {
                  context.go('/finance');
                  return;
                }
                if (index == 4) {
                  context.go('/profile');
                  return;
                }
              },
              onFabTap: () => context.go('/store'),
            ),
          ),
        ],
      ),
    );
  }
}
