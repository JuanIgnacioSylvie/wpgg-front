import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../../core/presentation/widgets/wpgg_summoner_identity_labels.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../missions/presentation/widgets/mission_primary_card.dart';
import '../../../missions/presentation/widgets/mission_secondary_card.dart';
import '../../../missions/presentation/widgets/mission_tertiary_card.dart';
import '../../../missions/presentation/widgets/mission_welcome_card.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../wallet/presentation/widgets/live_wpgg_price_scope.dart';
import '../bloc/user_profile_bloc.dart';
import '../widgets/live_profile_balance_card.dart';
import '../widgets/profile_privacy_blocked.dart';
import '../widgets/public_profile_stats_row.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({
    super.key,
    required this.userId,
    this.useWebStyle = false,
  });

  final String userId;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    return LiveWpggPriceScope(
      child: BlocProvider(
        create: (_) =>
            sl<UserProfileBloc>()..add(LoadUserProfile(userId)),
        child: _UserProfileView(useWebStyle: useWebStyle),
      ),
    );
  }
}

class _UserProfileView extends StatelessWidget {
  const _UserProfileView({this.useWebStyle = false});

  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ddragon = context.watch<DDragonProvider>();

    final content = BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(color: WpggBrand.primary),
          );
        }
        if (state is UserProfileAccessDenied) {
          if (state.code == 'PRIVATE_VIEWER') {
            return ProfilePrivacyBlocked(useWebStyle: useWebStyle);
          }
          return Center(
            child: Text(
              l10n.profileNotPublic,
              style: TextStyle(
                color: useWebStyle ? WebColors.textSecondary : WpggBrand.white,
              ),
            ),
          );
        }
        if (state is UserProfileError) {
          return Center(
            child: Text(
              l10n.errorGeneric,
              style: TextStyle(
                color: useWebStyle ? WebColors.textSecondary : WpggBrand.white,
              ),
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

        return ListView(
          padding: EdgeInsets.fromLTRB(0, 16, 0, useWebStyle ? 24 : 32),
          children: [
            Center(
              child: Column(
                children: [
                  WpggProfileAvatar(
                    summoner: summoner,
                    ddragon: ddragon,
                    size: useWebStyle ? 80 : 96,
                    enableHero: false,
                  ),
                  const SizedBox(height: 12),
                  WpggSummonerIdentityLabels(
                    gameName: profile.gameName,
                    tagLine: profile.tagLine,
                    region: profile.region,
                    useWebStyle: useWebStyle,
                    showTagAndServer: true,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    nameStyle: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: useWebStyle
                          ? WebColors.textPrimary
                          : WpggBrand.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PublicProfileStatsRow(
                profile: profile,
                useWebStyle: useWebStyle,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LiveProfileBalanceCard(
                balanceWpgg: profile.balanceWpgg,
                useWebStyle: useWebStyle,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.inProgress,
                style: TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  color: useWebStyle
                      ? WebColors.textPrimary
                      : WpggBrand.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (profile.welcome != null)
              MissionWelcomeCard(mission: profile.welcome!),
            if (activeMissions.isEmpty && profile.welcome == null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.noActiveMissions,
                  style: TextStyle(
                    color: useWebStyle
                        ? WebColors.textMuted
                        : WpggBrand.textMuted,
                  ),
                ),
              )
            else ...[
              if (profile.primary != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MissionPrimaryCard(
                    mission: profile.primary!,
                  ),
                ),
              if (profile.secondary.isNotEmpty)
                SizedBox(
                  height: 148,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: profile.secondary.length,
                    itemBuilder: (_, i) => MissionSecondaryCard(
                      mission: profile.secondary[i],
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    l10n.passMissions,
                    style: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: useWebStyle
                          ? WebColors.textPrimary
                          : WpggBrand.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: WpggBrand.primary,
                    child: Text(
                      '${profile.past.length}',
                      style: const TextStyle(
                        color: WpggBrand.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (profile.past.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.completedMissionsPlaceholder,
                  style: TextStyle(
                    color: useWebStyle
                        ? WebColors.textMuted
                        : WpggBrand.textMuted,
                  ),
                ),
              )
            else
              ...profile.past.map(
                (m) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: MissionTertiaryCard(mission: m),
                ),
              ),
          ],
        );
      },
    );

    if (useWebStyle) {
      return content;
    }

    return WpggGradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Image.asset(
            'assets/icons/arrow_left.png',
            width: 24,
            height: 24,
          ),
        ),
        title: Text(
          l10n.profile,
          style: const TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: WpggBrand.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: content,
    );
  }
}
