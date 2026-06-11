import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/locale/locale_provider.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../../../core/presentation/wpgg_profile_avatar.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../../../wallet/data/datasources/wallet_remote_datasource.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import 'faqs_page.dart';
import 'terms_page.dart';
import '../widgets/profile_panel_header.dart';
import '../widgets/withdraw_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    this.embeddedInPanel = false,
    this.useWebPanelStyle = false,
    this.onClose,
    this.onOpenFaqs,
    this.onOpenTerms,
  });

  final bool embeddedInPanel;
  final bool useWebPanelStyle;
  final VoidCallback? onClose;
  final VoidCallback? onOpenFaqs;
  final VoidCallback? onOpenTerms;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  static const _appBarAvatarSize = 40.0;
  static const _profileAvatarSize = 112.0;
  static const _webProfileAvatarSize = 80.0;

  late final AnimationController _entranceController;
  late final Animation<double> _scaleAnimation;
  late final Animation<Alignment> _alignmentAnimation;
  var _animateFromAppBar = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnimation = Tween<double>(
      begin: _appBarAvatarSize / _profileAvatarSize,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));
    _alignmentAnimation = AlignmentTween(
      begin: const Alignment(-0.92, -1.05),
      end: const Alignment(0, -0.42),
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    context.read<WalletBloc>().add(const LoadWallet());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.embeddedInPanel) {
        _entranceController.value = 1;
        return;
      }
      final from = GoRouterState.of(context).uri.queryParameters['from'];
      _animateFromAppBar = from == 'appbar';
      if (_animateFromAppBar) {
        _entranceController.forward();
      } else {
        _entranceController.value = 1;
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  WalletSummary? _summary(WalletState state) {
    return switch (state) {
      WalletLoaded(:final summary) => summary,
      WalletWithdrawing(:final summary) => summary,
      WalletWithdrawSuccess(:final summary) => summary,
      WalletWithdrawError(:final summary) => summary,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final ddragon = Provider.of<DDragonProvider>(context);
    final useWeb = widget.useWebPanelStyle;

    return BlocListener<WalletBloc, WalletState>(
      listenWhen: (prev, curr) =>
          curr is WalletWithdrawSuccess || curr is WalletWithdrawError,
      listener: (context, state) {
        if (state is WalletWithdrawSuccess) {
          WpggSnackBar.show(context, l10n.withdrawSuccess);
        } else if (state is WalletWithdrawError) {
          WpggSnackBar.show(
            context,
            state.message.contains('Exception')
                ? l10n.withdrawError
                : state.message,
            isError: true,
          );
        }
        context.read<WalletBloc>().add(const LoadWallet());
      },
      child: BlocBuilder<RiotBloc, RiotState>(
        builder: (context, riotState) {
          SummonerEntity? summoner;
          if (riotState is RiotLoaded) {
            summoner = riotState.summoner;
          }

          return BlocBuilder<WalletBloc, WalletState>(
            builder: (context, walletState) {
              final riotLoading =
                  riotState is RiotInitial || riotState is RiotLoading;
              final walletLoading = walletState is WalletInitial ||
                  walletState is WalletLoading;
              final showSkeleton = riotLoading || walletLoading;

              final summary = _summary(walletState);
              final balance = summary?.balance ?? 0;
              final minWithdraw = summary?.minWithdrawWpgg ?? 1000;
              final withdrawing = walletState is WalletWithdrawing;

              final avatarSize =
                  useWeb ? _webProfileAvatarSize : _profileAvatarSize;
              final avatarWidget = summoner != null
                  ? WpggProfileAvatar(
                      summoner: summoner,
                      ddragon: ddragon,
                      size: avatarSize,
                      enableHero:
                          !widget.embeddedInPanel && _animateFromAppBar,
                    )
                  : CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor:
                          useWeb ? WebColors.surfaceElevated : WpggBrand.primary,
                      child: Icon(
                        Icons.person,
                        color: useWeb ? WebColors.textSecondary : WpggBrand.white,
                        size: avatarSize * 0.4,
                      ),
                    );

              return Column(
                children: [
                  if (widget.embeddedInPanel)
                    ProfilePanelHeader(
                      title: l10n.myProfile,
                      onClose: widget.onClose,
                      useWebStyle: useWeb,
                    )
                  else
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => context.go('/home'),
                              icon: Image.asset(
                                'assets/icons/arrow_left.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                l10n.myProfile,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: AppFonts.lexendDeca,
                                  color: WpggBrand.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        widget.embeddedInPanel ? 24 : 120,
                      ),
                      child: WebAnimatedSwitcher(
                        child: showSkeleton
                            ? ProfileSkeleton(
                                key: const ValueKey('profile-skeleton'),
                                useWebStyle: useWeb,
                              )
                            : Column(
                                key: const ValueKey('profile-content'),
                                children: [
                          if (useWeb)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 20),
                              child: Column(
                                children: [
                                  avatarWidget,
                                  if (summoner != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      summoner.gameName,
                                      style: const TextStyle(
                                        fontFamily: AppFonts.lexendDeca,
                                        color: WebColors.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (summoner.tagLine.isNotEmpty)
                                      Text(
                                        '#${summoner.tagLine}',
                                        style: const TextStyle(
                                          fontFamily: AppFonts.lexendDeca,
                                          color: WebColors.textMuted,
                                          fontSize: 13,
                                        ),
                                      ),
                                  ],
                                ],
                              ),
                            )
                          else ...[
                            SizedBox(
                              height: 200,
                              child: AnimatedBuilder(
                                animation: _entranceController,
                                builder: (context, child) {
                                  return AlignTransition(
                                    alignment: _alignmentAnimation,
                                    child: ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: avatarWidget,
                              ),
                            ),
                            if (summoner != null) ...[
                              Text(
                                summoner.gameName,
                                style: TextStyle(
                                  fontFamily: AppFonts.lexendDeca,
                                  color: widget.embeddedInPanel
                                      ? WpggBrand.cardTextDark
                                      : WpggBrand.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: _BalancePill(
                                  balance: balance,
                                  useWebStyle: useWeb,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _WithdrawPill(
                                  loading: withdrawing,
                                  enabled: balance >= minWithdraw,
                                  useWebStyle: useWeb,
                                  onTap: () => showWithdrawDialog(
                                    context,
                                    balance: balance,
                                    minWithdrawWpgg: minWithdraw,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          _SettingsCard(
                            useWebStyle: useWeb,
                            children: [
                              _SettingsRow(
                                icon: Icons.notifications_none,
                                label: l10n.generalNotification,
                                useWebStyle: useWeb,
                                trailing: Switch(
                                  value: true,
                                  onChanged: null,
                                  activeThumbColor: WpggBrand.white,
                                  activeTrackColor: useWeb
                                      ? WebColors.accent
                                      : WpggBrand.primary,
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: useWeb
                                    ? WebColors.borderSubtle
                                    : null,
                              ),
                              _SettingsRow(
                                icon: Icons.translate,
                                label: l10n.language,
                                useWebStyle: useWeb,
                                trailing: Text(
                                  localeProvider.isSpanish
                                      ? l10n.languageSpanish
                                      : l10n.languageEnglish,
                                  style: TextStyle(
                                    fontFamily: AppFonts.lexendDeca,
                                    color: useWeb
                                        ? WebColors.accent
                                        : WpggBrand.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  if (localeProvider.isSpanish) {
                                    localeProvider.setEnglish();
                                  } else {
                                    localeProvider.setSpanish();
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _SettingsCard(
                            useWebStyle: useWeb,
                            children: [
                              _SettingsRow(
                                icon: Icons.quiz_outlined,
                                label: l10n.faqsMenuItem,
                                useWebStyle: useWeb,
                                onTap: () => openFaqsPage(
                                  context,
                                  embeddedInPanel: widget.embeddedInPanel,
                                  onOpenInPanel: widget.onOpenFaqs,
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: useWeb
                                    ? WebColors.borderSubtle
                                    : null,
                              ),
                              _SettingsRow(
                                icon: Icons.support_agent_outlined,
                                label: l10n.helpSupport,
                                useWebStyle: useWeb,
                              ),
                              Divider(
                                height: 1,
                                color: useWeb
                                    ? WebColors.borderSubtle
                                    : null,
                              ),
                              _SettingsRow(
                                icon: Icons.chat_bubble_outline,
                                label: l10n.contactUs,
                                useWebStyle: useWeb,
                              ),
                              Divider(
                                height: 1,
                                color: useWeb
                                    ? WebColors.borderSubtle
                                    : null,
                              ),
                              _SettingsRow(
                                icon: Icons.description_outlined,
                                label: l10n.termsAndConditionsTitle,
                                useWebStyle: useWeb,
                                onTap: () => openTermsPage(
                                  context,
                                  embeddedInPanel: widget.embeddedInPanel,
                                  onOpenInPanel: widget.onOpenTerms,
                                ),
                              ),
                            ],
                          ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _BalancePill extends StatelessWidget {
  const _BalancePill({
    required this.balance,
    this.useWebStyle = false,
  });

  final int balance;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    if (useWebStyle) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: WebColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: WebColors.borderSubtle),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/wpgg-coin_24x24.png',
              width: 20,
              height: 20,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.balanceLabel,
                    style: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WebColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '$balance WPGG',
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WebColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: WpggBrand.primary, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/wpgg-coin_24x24.png',
            width: 22,
            height: 22,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 8),
          Text(
            '$balance',
            style: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: WpggBrand.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WithdrawPill extends StatelessWidget {
  const _WithdrawPill({
    required this.onTap,
    required this.enabled,
    required this.loading,
    this.useWebStyle = false,
  });

  final VoidCallback onTap;
  final bool enabled;
  final bool loading;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final borderRadius =
        BorderRadius.circular(useWebStyle ? 12 : 28);
    final borderColor = useWebStyle
        ? (enabled ? WebColors.accent : WebColors.borderSubtle)
        : (enabled ? WpggBrand.primary : WpggBrand.textMuted);
    final labelColor = useWebStyle
        ? (enabled ? WebColors.accent : WebColors.textMuted)
        : (enabled ? WpggBrand.primary : WpggBrand.textMuted);
    final backgroundColor = useWebStyle
        ? (enabled
            ? WebColors.accent.withValues(alpha: 0.1)
            : WebColors.surfaceElevated)
        : Colors.black.withValues(alpha: 0.35);
    final progressColor =
        useWebStyle ? WebColors.accent : WpggBrand.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled && !loading ? onTap : null,
        borderRadius: borderRadius,
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: useWebStyle ? 14 : 16,
            vertical: useWebStyle ? 18 : 12,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: progressColor,
                    ),
                  )
                : Text(
                    l10n.withdraw,
                    style: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: labelColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.children,
    this.useWebStyle = false,
  });

  final List<Widget> children;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: useWebStyle ? WebColors.surfaceElevated : WpggBrand.cardSurface,
        borderRadius: BorderRadius.circular(useWebStyle ? 12 : 20),
        border: useWebStyle
            ? Border.all(color: WebColors.borderSubtle)
            : null,
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.useWebStyle = false,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        useWebStyle ? WebColors.textSecondary : WpggBrand.cardTextDark;
    final labelColor =
        useWebStyle ? WebColors.textPrimary : WpggBrand.cardTextDark;
    final borderRadius = BorderRadius.circular(useWebStyle ? 12 : 20);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
