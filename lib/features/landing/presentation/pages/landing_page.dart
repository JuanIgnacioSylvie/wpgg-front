import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_dot_grid_background.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../auth/domain/usecases/refresh_token_usecase.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../wallet/data/datasources/dexscreener_datasource.dart';
import '../widgets/landing_coin_hero.dart';
import '../widgets/landing_language_menu.dart';
import '../widgets/landing_sponsor_form.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scroll = ScrollController();
  final _missionsKey = GlobalKey();
  final _coinKey = GlobalKey();
  final _sponsorsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeRedirectSession());
  }

  Future<void> _maybeRedirectSession() async {
    final storage = sl<SecureStorage>();
    final token = await storage.getAccessToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      context.go('/home');
      return;
    }
    final refreshed = await sl<RefreshTokenUseCase>()();
    if (!mounted) return;
    refreshed.fold((_) {}, (_) => context.go('/home'));
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final maxContent = MediaQuery.sizeOf(context).width.clamp(0, 1080).toDouble();

    return Scaffold(
      backgroundColor: WebColors.background,
      body: WebDotGridBackground(
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: WebColors.topBar.withValues(alpha: 0.92),
              surfaceTintColor: Colors.transparent,
              toolbarHeight: WebColors.shellHeaderHeight,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/wpgg-coin_32x32.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'WPGG',
                    style: TextStyle(
                      fontFamily: AppFonts.wallpoet,
                      fontSize: 18,
                      color: WebColors.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              actions: [
                if (MediaQuery.sizeOf(context).width >= 720) ...[
                  _NavLink(
                    label: l10n.landingNavMissions,
                    onTap: () => _scrollTo(_missionsKey),
                  ),
                  _NavLink(
                    label: l10n.landingNavCoin,
                    onTap: () => _scrollTo(_coinKey),
                  ),
                  _NavLink(
                    label: l10n.landingNavSponsors,
                    onTap: () => _scrollTo(_sponsorsKey),
                  ),
                  const SizedBox(width: 8),
                ],
                const LandingLanguageMenu(),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    l10n.landingNavLogin,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: WebColors.textSecondary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilledButton(
                    onPressed: () => context.go('/register'),
                    style: FilledButton.styleFrom(
                      backgroundColor: WebColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(96, 34),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Text(
                      l10n.landingNavGetStarted,
                      style: const TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContent),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 48),
                        const Center(child: LandingCoinHero()),
                        const SizedBox(height: 32),
                        WebAnimatedAppear(
                          staggerIndex: 1,
                          child: Text(
                            l10n.landingHeroTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppFonts.lexendDeca,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                              color: WebColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        WebAnimatedAppear(
                          staggerIndex: 2,
                          child: Text(
                            l10n.landingHeroSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppFonts.lexendDeca,
                              fontSize: 16,
                              height: 1.6,
                              color: WebColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        WebAnimatedAppear(
                          staggerIndex: 3,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: 200,
                                child: WpggPrimaryButton(
                                  label: l10n.landingCtaCreateAccount,
                                  onPressed: () => context.go('/register'),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: OutlinedButton(
                                  onPressed: () => _scrollTo(_missionsKey),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(44),
                                    side: const BorderSide(
                                      color: WebColors.border,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.landingCtaHowItWorks,
                                    style: const TextStyle(
                                      fontFamily: AppFonts.lexendDeca,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: WebColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 72),
                        _LandingSection(
                          title: l10n.landingWhatTitle,
                          subtitle: l10n.landingWhatSubtitle(WpggBrand.tagline),
                          body: l10n.landingWhatBody,
                          bullets: [
                            l10n.landingWhatBullet1,
                            l10n.landingWhatBullet2,
                            l10n.landingWhatBullet3,
                          ],
                        ),
                        const SizedBox(height: 56),
                        KeyedSubtree(
                          key: _missionsKey,
                          child: _LandingSection(
                            title: l10n.landingMissionsTitle,
                            subtitle: l10n.landingMissionsSubtitle,
                            body: l10n.landingMissionsBody,
                            bullets: [
                              l10n.landingMissionsBullet1,
                              l10n.landingMissionsBullet2,
                              l10n.landingMissionsBullet3,
                            ],
                            accent: WebColors.online,
                          ),
                        ),
                        const SizedBox(height: 56),
                        KeyedSubtree(
                          key: _coinKey,
                          child: _LandingSection(
                            title: l10n.landingCoinTitle,
                            subtitle: l10n.landingCoinSubtitle,
                            body: l10n.landingCoinBody,
                            bullets: [
                              l10n.landingCoinBullet1,
                              l10n.landingCoinBullet2,
                              l10n.landingCoinBullet3,
                            ],
                            highlight: _HighlightCard(
                              icon: Icons.verified_outlined,
                              title: l10n.landingCoinHighlightTitle,
                              body: l10n.landingCoinHighlightBody,
                            ),
                          ),
                        ),
                        const SizedBox(height: 56),
                        _LandingSection(
                          title: l10n.landingNotRichTitle,
                          subtitle: l10n.landingNotRichSubtitle,
                          body: l10n.landingNotRichBody,
                          bullets: [
                            l10n.landingNotRichBullet1,
                            l10n.landingNotRichBullet2,
                            l10n.landingNotRichBullet3,
                          ],
                          accent: const Color(0xFFE8A317),
                        ),
                        const SizedBox(height: 56),
                        _LandingSection(
                          title: l10n.landingUseTitle,
                          subtitle: l10n.landingUseSubtitle,
                          body: l10n.landingUseBody,
                          bullets: [
                            l10n.landingUseBullet1,
                            l10n.landingUseBullet2,
                            l10n.landingUseBullet3,
                          ],
                        ),
                        const SizedBox(height: 56),
                        WebAnimatedAppear(
                          child: _StepsSection(
                            title: l10n.landingStepsTitle,
                            steps: [
                              ('1', l10n.landingStep1Title, l10n.landingStep1Body),
                              ('2', l10n.landingStep2Title, l10n.landingStep2Body),
                              ('3', l10n.landingStep3Title, l10n.landingStep3Body),
                              ('4', l10n.landingStep4Title, l10n.landingStep4Body),
                            ],
                          ),
                        ),
                        const SizedBox(height: 72),
                        KeyedSubtree(
                          key: _sponsorsKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.landingSponsorsTitle,
                                style: const TextStyle(
                                  fontFamily: AppFonts.lexendDeca,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: WebColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.landingSponsorsBody,
                                style: const TextStyle(
                                  fontFamily: AppFonts.lexendDeca,
                                  fontSize: 15,
                                  height: 1.6,
                                  color: WebColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 28),
                              const LandingSponsorForm(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 56),
                        WebAnimatedAppear(
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: WebColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: WebColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.landingFaqTitle,
                                  style: const TextStyle(
                                    fontFamily: AppFonts.lexendDeca,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: WebColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.landingFaqBody,
                                  style: const TextStyle(
                                    fontFamily: AppFonts.lexendDeca,
                                    fontSize: 14,
                                    height: 1.55,
                                    color: WebColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () => context.go('/faqs'),
                                  child: Text(
                                    l10n.landingFaqLink,
                                    style: const TextStyle(
                                      fontFamily: AppFonts.lexendDeca,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: WebColors.accent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 56),
                        const _LandingFooter(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: WebColors.textSecondary,
        ),
      ),
    );
  }
}

class _LandingSection extends StatelessWidget {
  const _LandingSection({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.bullets,
    this.accent,
    this.highlight,
  });

  final String title;
  final String subtitle;
  final String body;
  final List<String> bullets;
  final Color? accent;
  final Widget? highlight;

  @override
  Widget build(BuildContext context) {
    final bulletColor = accent ?? WebColors.accent;

    return WebAnimatedAppear(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: WebColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: bulletColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            body,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 15,
              height: 1.65,
              color: WebColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: bulletColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      b,
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        fontSize: 14,
                        height: 1.5,
                        color: WebColors.textPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (highlight != null) ...[
            const SizedBox(height: 20),
            highlight!,
          ],
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WebColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: WebColors.accent.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: WebColors.accent, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: WebColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    fontSize: 14,
                    height: 1.55,
                    color: WebColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepsSection extends StatelessWidget {
  const _StepsSection({required this.title, required this.steps});

  final String title;
  final List<(String, String, String)> steps;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: WebColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < steps.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    Expanded(child: _StepCard(step: steps[i])),
                  ],
                ],
              );
            }
            return Column(
              children: [
                for (final step in steps) ...[
                  _StepCard(step: step),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step});

  final (String, String, String) step;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WebColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.$1,
            style: TextStyle(
              fontFamily: AppFonts.wallpoet,
              fontSize: 28,
              color: WebColors.accent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step.$2,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: WebColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            step.$3,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 13,
              height: 1.5,
              color: WebColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LandingFooter extends StatelessWidget {
  const _LandingFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: WebColors.border, height: 1),
        const SizedBox(height: 28),
        Row(
          children: [
            Image.asset(
              'assets/images/wpgg-coin_32x32.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              'WPGG',
              style: TextStyle(
                fontFamily: AppFonts.wallpoet,
                fontSize: 16,
                color: WebColors.textPrimary,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: [
            _FooterLink(
              label: l10n.landingFooterTerms,
              onTap: () => context.go('/terms'),
            ),
            _FooterLink(
              label: l10n.landingFooterFaqs,
              onTap: () => context.go('/faqs'),
            ),
            _FooterLink(
              label: l10n.landingFooterLogin,
              onTap: () => context.go('/login'),
            ),
            _FooterLink(
              label: l10n.landingFooterRegister,
              onTap: () => context.go('/register'),
            ),
            _FooterLink(
              label: l10n.landingFooterCoinMarketCap,
              uri: Uri.parse(DexScreenerDataSource.wpggCoinMarketCapUrl),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          l10n.landingFooterDisclaimer,
          style: const TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 12,
            height: 1.5,
            color: WebColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.landingFooterCopyright(DateTime.now().year),
          style: const TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 12,
            color: WebColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    this.onTap,
    this.uri,
  }) : assert(onTap != null || uri != null);

  final String label;
  final VoidCallback? onTap;
  final Uri? uri;

  static final _labelStyle = TextStyle(
    fontFamily: AppFonts.lexendDeca,
    fontSize: 13,
    color: WebColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(label, style: _labelStyle);

    if (uri != null) {
      return Link(
        uri: uri!,
        target: LinkTarget.blank,
        builder: (context, followLink) => InkWell(
          onTap: followLink,
          child: labelWidget,
        ),
      );
    }

    return InkWell(onTap: onTap, child: labelWidget);
  }
}
