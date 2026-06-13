import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../missions/presentation/widgets/web_mission_card.dart';
import '../../../missions/presentation/widgets/web_mission_welcome_card.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../bloc/user_profile_bloc.dart';
import '../widgets/live_profile_balance_card.dart';
import '../widgets/profile_panel_header.dart';
import '../widgets/profile_privacy_blocked.dart';

/// Opens the viewed user's profile in the same layout as the web dashboard.
Future<void> showWebUserProfileDialog(
  BuildContext context, {
  required String userId,
  VoidCallback? onOpenSettings,
}) {
  final ddragon = context.read<DDragonProvider>();
  final openSettings = onOpenSettings;

  return showWebDialog<void>(
    context: context,
    builder: (ctx) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<UserProfileBloc>()
            ..add(LoadUserProfile(userId)),
        ),
      ],
      child: ChangeNotifierProvider<DDragonProvider>.value(
        value: ddragon,
        child: _WebUserProfileDialog(
          userId: userId,
          onOpenSettings: openSettings,
        ),
      ),
    ),
  );
}

class _WebUserProfileDialog extends StatelessWidget {
  const _WebUserProfileDialog({
    required this.userId,
    this.onOpenSettings,
  });

  final String userId;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(
          minWidth: 640,
          maxWidth: 960,
          minHeight: 520,
          maxHeight: 720,
        ),
        decoration: BoxDecoration(
          color: WebColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WebColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (context, state) {
                  final title = switch (state) {
                    UserProfileLoaded(:final profile) =>
                      profile.tagLine.isNotEmpty
                          ? '${profile.gameName}#${profile.tagLine}'
                          : profile.gameName,
                    _ => context.l10n.profile,
                  };
                  return ProfilePanelHeader(
                    title: title,
                    onClose: () => Navigator.of(context).pop(),
                    useWebStyle: true,
                  );
                },
              ),
              const Divider(height: 1, color: WebColors.borderSubtle),
              Expanded(
                child: _WebUserProfileContent(
                  userId: userId,
                  onOpenSettings: onOpenSettings,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebUserProfileContent extends StatelessWidget {
  const _WebUserProfileContent({
    required this.userId,
    this.onOpenSettings,
  });

  final String userId;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ddragon = context.watch<DDragonProvider>();

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(color: WebColors.accent),
          );
        }
        if (state is UserProfileAccessDenied) {
          if (state.code == 'PRIVATE_VIEWER') {
            return ProfilePrivacyBlocked(
              useWebStyle: true,
              onOpenSettings: onOpenSettings,
            );
          }
          return Center(
            child: Text(
              l10n.profileNotPublic,
              style: const TextStyle(color: WebColors.textSecondary),
            ),
          );
        }
        if (state is UserProfileError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.errorGeneric,
                  style: const TextStyle(color: WebColors.textSecondary),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context
                      .read<UserProfileBloc>()
                      .add(LoadUserProfile(userId)),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }
        if (state is! UserProfileLoaded) {
          return const SizedBox.shrink();
        }

        final profile = state.profile;
        final summoner = SummonerEntity(
          gameName: profile.gameName,
          tagLine: profile.tagLine,
          region: profile.region,
          profileIconId: profile.profileIconId,
          puuid: '',
          summonerLevel: 0,
        );

        final activeMissions = [
          if (profile.primary != null) profile.primary!,
          ...profile.secondary,
        ];
        final inProgressCount =
            (profile.welcome != null ? 1 : 0) + activeMissions.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  WpggProfileAvatar(
                    summoner: summoner,
                    ddragon: ddragon,
                    size: 64,
                    enableHero: false,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.gameName,
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: WebColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (profile.tagLine.isNotEmpty)
                        Text(
                          '#${profile.tagLine}',
                          style: const TextStyle(
                            fontFamily: AppFonts.lexendDeca,
                            color: WebColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              LiveProfileBalanceCard(
                balanceWpgg: profile.balanceWpgg,
                useWebStyle: true,
              ),
              const SizedBox(height: 32),
              WebSectionHeader(
                title: l10n.inProgress,
                count: inProgressCount,
              ),
              const SizedBox(height: 20),
              if (profile.welcome != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: WebMissionWelcomeCard(mission: profile.welcome!),
                ),
              if (activeMissions.isEmpty && profile.welcome == null)
                Text(
                  l10n.noActiveMissions,
                  style: const TextStyle(
                    color: WebColors.textMuted,
                    fontSize: 13,
                  ),
                )
              else
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    for (final m in activeMissions) WebMissionCard(mission: m),
                  ],
                ),
              const SizedBox(height: 48),
              WebSectionHeader(
                title: l10n.passMissions,
                count: profile.past.length,
              ),
              const SizedBox(height: 20),
              if (profile.past.isEmpty)
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
                  children: [
                    for (final m in profile.past) WebMissionCard(mission: m),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
