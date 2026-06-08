import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_event.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../../../riot/presentation/widgets/riot_link_sheet.dart';
import '../../../riot/presentation/widgets/stats_header.dart';
import '../bloc/missions_bloc.dart';
import '../widgets/pick_missions_dialog.dart';
import '../widgets/web_mission_card.dart';

class WebDashboardPage extends StatefulWidget {
  const WebDashboardPage({super.key});

  @override
  State<WebDashboardPage> createState() => _WebDashboardPageState();
}

class _WebDashboardPageState extends State<WebDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<MissionsBloc>().add(const LoadMissionsHome());
  }

  void _openPickMissions() {
    showPickMissionsDialog(context);
  }

  bool _canAddMore(MissionsHomeData home) {
    final activeCount =
        (home.primary != null ? 1 : 0) + home.secondary.length;
    return activeCount < 3;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<RiotBloc, RiotState>(
          listenWhen: (prev, curr) => curr is RiotAccountLinked,
          listener: (context, _) {
            context.read<RiotBloc>().add(const LoadDashboard());
            context.read<MissionsBloc>().add(const LoadMissionsHome());
          },
        ),
      ],
      child: BlocBuilder<RiotBloc, RiotState>(
        builder: (context, riotState) {
          if (riotState is RiotLoading ||
              riotState is RiotInitial ||
              riotState is RiotAccountLinked) {
            return const Center(
              child: CircularProgressIndicator(color: WebColors.accent),
            );
          }

          if (riotState is RiotNoAccount) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: StatsHeaderEmpty(
                  onLinkTap: () => showRiotLinkSheet(context),
                ),
              ),
            );
          }

          if (riotState is RiotError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    riotState.message,
                    style: const TextStyle(color: WebColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        context.read<RiotBloc>().add(const LoadDashboard()),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          return BlocBuilder<MissionsBloc, MissionsState>(
            builder: (context, state) {
              if (state.homeStatus == MissionsLoadStatus.loading ||
                  state.homeStatus == MissionsLoadStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(color: WebColors.accent),
                );
              }

              if (state.homeStatus == MissionsLoadStatus.error) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.homeError ?? l10n.errorLoadingMissions,
                        style: const TextStyle(color: WebColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context
                            .read<MissionsBloc>()
                            .add(const LoadMissionsHome()),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              final home = state.home;
              if (home == null) return const SizedBox.shrink();

              final canAdd = _canAddMore(home);
              final onAdd = WebShellScope.addMissionHandler(context) ??
                  _openPickMissions;

              return RefreshIndicator(
                color: WebColors.accent,
                backgroundColor: WebColors.surface,
                onRefresh: () async {
                  context.read<MissionsBloc>().add(const LoadMissionsHome());
                  await context.read<MissionsBloc>().stream.firstWhere(
                        (s) =>
                            s.homeStatus == MissionsLoadStatus.loaded ||
                            s.homeStatus == MissionsLoadStatus.error,
                      );
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        title: l10n.inProgress,
                        subtitle: l10n.missionDayResets(
                          home.missionDate,
                          home.missionDayTimezone,
                        ),
                        count: (home.primary != null ? 1 : 0) +
                            home.secondary.length,
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          if (home.primary != null)
                            WebMissionCard(
                              mission: home.primary,
                              endsInSeconds: home.endsInSeconds,
                            ),
                          ...home.secondary.map(
                            (m) => WebMissionCard(mission: m),
                          ),
                          if (canAdd)
                            WebMissionCard.empty(onTap: onAdd),
                        ],
                      ),
                      if (home.primary == null && home.secondary.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            l10n.noActiveMissions,
                            style: const TextStyle(
                              color: WebColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      const SizedBox(height: 48),
                      _SectionHeader(
                        title: 'Misiones pasadas',
                        count: home.past.length,
                      ),
                      const SizedBox(height: 20),
                      if (home.past.isEmpty)
                        Text(
                          l10n.completedMissionsPlaceholder,
                          style: const TextStyle(
                            color: WebColors.textMuted,
                            fontSize: 13,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: home.past
                              .map(
                                (m) => WebMissionCard(
                                  mission: m,
                                  variant: WebMissionCardVariant.past,
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.count,
  });

  final String title;
  final String? subtitle;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: WebColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: WebColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: WebColors.border),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: WebColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(width: 12),
          Text(
            subtitle!,
            style: const TextStyle(
              color: WebColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
