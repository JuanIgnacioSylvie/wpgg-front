import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../missions/presentation/widgets/web_mission_card.dart';
import '../../../missions/presentation/widgets/web_mission_welcome_card.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../bloc/user_profile_bloc.dart';
import '../widgets/live_profile_balance_card.dart';
import '../widgets/profile_privacy_blocked.dart';

class WebUserProfilePage extends StatelessWidget {
  const WebUserProfilePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<UserProfileBloc>()..add(LoadUserProfile(userId)),
      child: const _WebUserProfileBody(),
    );
  }
}

class _WebUserProfileBody extends StatelessWidget {
  const _WebUserProfileBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ddragon = context.watch<DDragonProvider>();

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileLoading) {
          return const Center(
            child: WebDashboardSkeleton(key: ValueKey('user-profile-skeleton')),
          );
        }
        if (state is UserProfileAccessDenied) {
          if (state.code == 'PRIVATE_VIEWER') {
            return ProfilePrivacyBlocked(
              useWebStyle: true,
              onOpenSettings: WebShellScope.openSettingsHandler(context),
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
            child: Text(
              l10n.errorGeneric,
              style: const TextStyle(color: WebColors.textSecondary),
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
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
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

/// Opens the viewed user's profile in the same layout as the web dashboard.
Future<void> showWebUserProfileDialog(
  BuildContext context, {
  required String userId,
}) {
  return showWebDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 960, minHeight: 520),
        decoration: BoxDecoration(
          color: WebColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WebColors.border),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Navigator.of(ctx).pop(),
                icon: const Icon(Icons.close, color: WebColors.textSecondary),
              ),
            ),
            Expanded(
              child: WebUserProfilePage(userId: userId),
            ),
          ],
        ),
      ),
    ),
  );
}
