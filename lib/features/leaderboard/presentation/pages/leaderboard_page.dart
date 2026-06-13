import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../../core/presentation/widgets/wpgg_summoner_identity_labels.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../profile/data/datasources/profile_remote_datasource.dart';
import '../../../profile/presentation/bloc/profile_settings_bloc.dart';
import '../../../profile/presentation/pages/web_user_profile_page.dart';
import '../../../profile/presentation/profile_leaderboard_access.dart';
import '../../../profile/presentation/widgets/profile_privacy_blocked.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../bloc/leaderboard_bloc.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key, this.useWebStyle = false});

  final bool useWebStyle;

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileSettingsBloc>().add(const LoadProfileSettings());
  }

  void _reloadLeaderboard() {
    context.read<LeaderboardBloc>().add(const LoadLeaderboard());
  }

  void _openSettings() {
    if (widget.useWebStyle) {
      final openSettings = WebShellScope.openSettingsHandler(context);
      if (openSettings != null) {
        openSettings();
        return;
      }
    }
    context.go('/settings');
  }

  void _openProfile(LeaderboardEntry entry) {
    if (widget.useWebStyle) {
      showWebUserProfileDialog(
        context,
        userId: entry.userId,
        onOpenSettings: WebShellScope.openSettingsHandler(context),
      );
      return;
    }
    context.push('/users/${entry.userId}');
  }

  Widget _blockedView() {
    return ProfilePrivacyBlocked(
      useWebStyle: widget.useWebStyle,
      onOpenSettings: _openSettings,
      body: context.l10n.leaderboardPrivateBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ddragon = context.watch<DDragonProvider>();
    final useWeb = widget.useWebStyle;

    return BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
      listenWhen: (prev, curr) =>
          prev is ProfileSettingsLoaded &&
              curr is ProfileSettingsLoaded
          ? prev.profilePublic != curr.profilePublic
          : curr is ProfileSettingsLoaded,
      listener: (context, state) {
        if (canAccessLeaderboard(state)) {
          _reloadLeaderboard();
        }
      },
      builder: (context, settingsState) {
        if (settingsState is ProfileSettingsLoading ||
            settingsState is ProfileSettingsInitial) {
          final loading = const Center(
            child: CircularProgressIndicator(color: WpggBrand.primary),
          );
          if (useWeb) return loading;
          return WpggGradientScaffold(body: loading);
        }

        if (!canAccessLeaderboard(settingsState)) {
          if (useWeb) return _blockedView();
          return WpggGradientScaffold(body: _blockedView());
        }

        final body = BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardInitial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _reloadLeaderboard();
              });
            }
            if (state is LeaderboardLoading) {
              return const Center(
                child: CircularProgressIndicator(color: WpggBrand.primary),
              );
            }
            if (state is LeaderboardError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.errorGeneric,
                      style: TextStyle(
                        color:
                            useWeb ? WebColors.textSecondary : WpggBrand.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _reloadLeaderboard,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              );
            }
            if (state is! LeaderboardLoaded || state.entries.isEmpty) {
              return Center(
                child: Text(
                  l10n.leaderboardEmpty,
                  style: TextStyle(
                    color: useWeb ? WebColors.textMuted : WpggBrand.textMuted,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(16, 16, 16, useWeb ? 24 : 100),
              itemCount: state.entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = state.entries[index];
                final summoner = SummonerEntity(
                  gameName: entry.gameName,
                  tagLine: entry.tagLine,
                  region: entry.region,
                  profileIconId: entry.profileIconId,
                  puuid: '',
                  summonerLevel: 0,
                );

                return _LeaderboardRow(
                  entry: entry,
                  summoner: summoner,
                  ddragon: ddragon,
                  useWebStyle: useWeb,
                  onTap: () => _openProfile(entry),
                );
              },
            );
          },
        );

        if (useWeb) {
          return body;
        }

        return WpggGradientScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    l10n.leaderboardTitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WpggBrand.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.entry,
    required this.summoner,
    required this.ddragon,
    required this.onTap,
    this.useWebStyle = false,
  });

  final LeaderboardEntry entry;
  final SummonerEntity summoner;
  final DDragonProvider? ddragon;
  final VoidCallback onTap;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        useWebStyle ? WebColors.surfaceElevated : WpggBrand.cardSurface;
    final textColor =
        useWebStyle ? WebColors.textPrimary : WpggBrand.cardTextDark;
    final mutedColor =
        useWebStyle ? WebColors.textMuted : WpggBrand.textMuted;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(useWebStyle ? 12 : 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(useWebStyle ? 12 : 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '#${entry.rank}',
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: mutedColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              WpggProfileAvatar(
                summoner: summoner,
                ddragon: ddragon,
                size: 40,
                enableHero: false,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WpggSummonerIdentityLabels(
                  gameName: entry.gameName,
                  tagLine: entry.tagLine,
                  region: entry.region,
                  useWebStyle: useWebStyle,
                  nameStyle: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  tagLineStyle: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: mutedColor,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/wpgg-coin_24x24.png',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${entry.balanceWpgg}',
                    style: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
