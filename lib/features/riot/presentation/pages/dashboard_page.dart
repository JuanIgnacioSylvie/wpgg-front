import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../bloc/riot_bloc.dart';
import '../bloc/riot_event.dart';
import '../bloc/riot_state.dart';
import '../widgets/match_tile.dart';
import '../widgets/ranked_badge.dart';
import '../widgets/stats_header.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DDragonProvider>().ensureLoaded();
      context.read<RiotBloc>().add(const LoadDashboard());
    });
  }

  void _openLinkSheet() {
    final gameName = TextEditingController();
    final tagLine = TextEditingController();
    final region = TextEditingController(text: AppConstants.riotDefaultRegion);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Vincular Riot', style: Theme.of(ctx).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextField(
                controller: gameName,
                decoration: const InputDecoration(labelText: 'Nombre de invocador'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tagLine,
                decoration: const InputDecoration(labelText: 'Tag (#TAG sin #)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: region,
                decoration: const InputDecoration(labelText: 'Región (ej. LA2)'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  context.read<RiotBloc>().add(
                        LinkRiotAccount(
                          gameName: gameName.text.trim(),
                          tagLine: tagLine.text.trim(),
                          region: region.text.trim(),
                        ),
                      );
                  Navigator.pop(ctx);
                },
                child: const Text('Vincular'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              context.go('/login');
            }
          },
        ),
        BlocListener<RiotBloc, RiotState>(
          listenWhen: (prev, curr) => curr is RiotAccountLinked,
          listener: (context, state) {
            context.read<RiotBloc>().add(const LoadDashboard());
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('WPGG', style: AppTextStyles.wallpoetLogo(context, fontSize: 20)),
          actions: [
            IconButton(
              onPressed: themeProvider.toggleTheme,
              icon: Icon(themeProvider.isDark ? Icons.light_mode : Icons.dark_mode),
            ),
            IconButton(
              onPressed: () =>
                  context.read<AuthBloc>().add(const LogoutRequested()),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: BlocBuilder<RiotBloc, RiotState>(
          builder: (context, state) {
            if (state is RiotLoading ||
                state is RiotInitial ||
                state is RiotAccountLinked) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is RiotError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () =>
                            context.read<RiotBloc>().add(const LoadDashboard()),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is RiotNoAccount) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  StatsHeaderEmpty(onLinkTap: _openLinkSheet),
                ],
              );
            }
            if (state is RiotLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<RiotBloc>().add(const RefreshMatchHistory());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    StatsHeader(
                      summoner: state.summoner,
                    ),
                    const SizedBox(height: 16),
                    ...state.rankedEntries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RankedBadge(entry: e),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Últimas partidas',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    ...state.matches.map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: MatchTile(match: m),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
