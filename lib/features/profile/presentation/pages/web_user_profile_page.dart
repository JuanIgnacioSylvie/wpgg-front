import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../../core/presentation/widgets/wpgg_summoner_identity_labels.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../missions/presentation/widgets/web_mission_card.dart';
import '../../../missions/presentation/widgets/web_mission_welcome_card.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../wallet/presentation/widgets/live_wpgg_price_scope.dart';
import '../bloc/user_profile_bloc.dart';
import '../widgets/live_profile_balance_card.dart';
import '../widgets/profile_panel_header.dart';
import '../widgets/profile_privacy_blocked.dart';
import '../widgets/public_profile_stats_row.dart';

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
          create: (_) => sl<UserProfileBloc>()..add(LoadUserProfile(userId)),
        ),
      ],
      child: LiveWpggPriceScope(
        child: ChangeNotifierProvider<DDragonProvider>.value(
          value: ddragon,
          child: _WebUserProfileDialog(
            userId: userId,
            onOpenSettings: openSettings,
          ),
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
    final width = MediaQuery.sizeOf(context).width;
    final horizontalInset = width < 600 ? 12.0 : width < 960 ? 24.0 : 48.0;
    final verticalInset = width < 600 ? 12.0 : 24.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontalInset,
        vertical: verticalInset,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth.clamp(320.0, 960.0);
          final maxH = constraints.maxHeight.clamp(420.0, 720.0);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            constraints: BoxConstraints(
              minWidth: 320,
              maxWidth: maxW,
              minHeight: 420,
              maxHeight: maxH,
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
                        UserProfileLoaded(:final profile) => profile.gameName,
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
          );
        },
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
    final compact = MediaQuery.sizeOf(context).width < 640;
    final hPad = compact ? 16.0 : 32.0;

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
          padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (compact)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WpggProfileAvatar(
                      summoner: summoner,
                      ddragon: ddragon,
                      size: 72,
                      enableHero: false,
                    ),
                    const SizedBox(height: 12),
                    WpggSummonerIdentityLabels(
                      gameName: profile.gameName,
                      tagLine: profile.tagLine,
                      region: profile.region,
                      useWebStyle: true,
                      showTagAndServer: true,
                      nameStyle: const TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        color: WebColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      tagLineStyle: const TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        color: WebColors.textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    WpggProfileAvatar(
                      summoner: summoner,
                      ddragon: ddragon,
                      size: 72,
                      enableHero: false,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: WpggSummonerIdentityLabels(
                        gameName: profile.gameName,
                        tagLine: profile.tagLine,
                        region: profile.region,
                        useWebStyle: true,
                        showTagAndServer: true,
                        nameStyle: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: WebColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        tagLineStyle: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: WebColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              PublicProfileStatsRow(profile: profile, useWebStyle: true),
              const SizedBox(height: 20),
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
                  l10n.passMissionsPlaceholder,
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
