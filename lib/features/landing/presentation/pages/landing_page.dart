import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../auth/domain/usecases/refresh_token_usecase.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_dot_grid_background.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../widgets/landing_coin_hero.dart';
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
                    label: 'Misiones',
                    onTap: () => _scrollTo(_missionsKey),
                  ),
                  _NavLink(
                    label: 'La Coin',
                    onTap: () => _scrollTo(_coinKey),
                  ),
                  _NavLink(
                    label: 'Sponsors',
                    onTap: () => _scrollTo(_sponsorsKey),
                  ),
                  const SizedBox(width: 8),
                ],
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(
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
                      'Empezar',
                      style: TextStyle(
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
                            'Jugá League of Legends.\nGaná WPGG. Canjeá por RP o retirá.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                            'WPGG es una plataforma de misiones diarias de LoL con recompensas reales. Sin promesas mágicas, sin caja negra: todo respaldado por un pool fijo y verificable on-chain.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                                  label: 'Crear cuenta gratis',
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
                                    'Cómo funciona',
                                    style: TextStyle(
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
                          title: '¿Qué es WPGG?',
                          subtitle:
                              'Win · Play · Get Gold — estadísticas de LoL que te pagan por jugar.',
                          body:
                              'Completás misiones diarias basadas en tu actividad en partidas ranked, acumulás tokens WPGG y los usás en la tienda para gift cards de Riot Points o los retirás a tu wallet. Es un sistema de recompensas pensado para jugadores, no para especuladores.',
                          bullets: const [
                            'Vinculás tu cuenta de Riot de forma segura',
                            'Elegís misiones fáciles, medias o difíciles cada día',
                            'Sumás WPGG al completarlas — sin trucos, sin letra chica escondida',
                          ],
                        ),
                        const SizedBox(height: 56),
                        KeyedSubtree(
                          key: _missionsKey,
                          child: _LandingSection(
                            title: 'Misiones diarias',
                            subtitle: 'Jugá como siempre. Sumá recompensas de verdad.',
                            body:
                                'Cada día tenés un set de misiones: desde cosas simples como jugar una partida, hasta desafíos de rendimiento como superar un KDA o encadenar victorias. Elegís las que te cierran, las completás en ranked y cobrás.',
                            bullets: const [
                              'Fáciles, medias y difíciles — vos elegís el riesgo',
                              'Podés rerollear misiones que no te gusten (con costo en WPGG)',
                              'Las recompensas varían según dificultad — sin inflación infinita',
                            ],
                            accent: WebColors.online,
                          ),
                        ),
                        const SizedBox(height: 56),
                        KeyedSubtree(
                          key: _coinKey,
                          child: _LandingSection(
                            title: 'La WPGG Coin',
                            subtitle: 'Transparencia total. Sin caja negra.',
                            body:
                                'El token WPGG está deployado en Polygon Mainnet y es auditable en PolygonScan. La liquidez está respaldada por un pool fijo en QuickSwap (par WPGG/USDC): es lo que es, no crece mágicamente ni promete retornos infinitos.',
                            bullets: const [
                              'Contrato verificable públicamente on-chain',
                              'Pool fijo en QuickSwap — liquidez real, no promesas',
                              'Podés ver el estado del pool y auditar todo vos mismo',
                            ],
                            highlight: _HighlightCard(
                              icon: Icons.verified_outlined,
                              title: 'Pool fijo, expectativas claras',
                              body:
                                  'El pool de liquidez tiene un tamaño fijo. Eso significa que el sistema es honesto sobre lo que puede entregar: recompensas reales y canjeables, no un esquema para hacerte millonario farmeando partidas.',
                            ),
                          ),
                        ),
                        const SizedBox(height: 56),
                        _LandingSection(
                          title: 'No te vas a hacer rico',
                          subtitle: 'Y lo decimos sin rodeos, porque la honestidad es el proyecto.',
                          body:
                              'WPGG no es un juego de inversión ni un esquema de farming infinito. Nadie se hace rico completando misiones. Es para que compres RP en la tienda con tus tokens, o retires las coins y le compres unas flores a tu novia o te tomes una birra con los pibes.',
                          bullets: const [
                            'Recompensas modestas y reales — alcanzan para RP o un gustito',
                            'Sin promesas de multiplicar plata ni retornos garantizados',
                            'Si buscás especular, este no es tu lugar (y está bien)',
                          ],
                          accent: const Color(0xFFE8A317),
                        ),
                        const SizedBox(height: 56),
                        _LandingSection(
                          title: '¿Qué podés hacer con tus WPGG?',
                          subtitle: 'Usalos en la app o llevátelos afuera.',
                          body: 'Tus tokens tienen utilidad concreta dentro y fuera de WPGG.',
                          bullets: const [
                            'Comprar gift cards de Riot Points en la tienda WPGG',
                            'Retirar WPGG a tu wallet personal en Polygon',
                            'Canjearlos por lo que quieras: birra, flores, lo que se te ocurra',
                          ],
                        ),
                        const SizedBox(height: 56),
                        WebAnimatedAppear(
                          child: _StepsSection(
                            steps: const [
                              (
                                '1',
                                'Creá tu cuenta',
                                'Registrate con email o entrá con tu cuenta de Riot.',
                              ),
                              (
                                '2',
                                'Elegí tus misiones',
                                'Seleccioná el set del día según tu tiempo y skill.',
                              ),
                              (
                                '3',
                                'Jugá ranked',
                                'Las misiones se validan con tus partidas reales.',
                              ),
                              (
                                '4',
                                'Cobrá y canjeá',
                                'Sumá WPGG, comprá RP o retirá a tu wallet.',
                              ),
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
                                '¿Querés apoyar el proyecto?',
                                style: TextStyle(
                                  fontFamily: AppFonts.lexendDeca,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: WebColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Buscamos sponsors y partners que quieran sumarse a una comunidad de jugadores de LoL con un modelo transparente. Si tenés una propuesta de colaboración, activación o branding, escribinos.',
                                style: TextStyle(
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
                                  'Preguntas frecuentes',
                                  style: TextStyle(
                                    fontFamily: AppFonts.lexendDeca,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: WebColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '¿Necesitás saber más sobre misiones, retiros o el token? Tenemos una sección completa de FAQs dentro de la app.',
                                  style: TextStyle(
                                    fontFamily: AppFonts.lexendDeca,
                                    fontSize: 14,
                                    height: 1.55,
                                    color: WebColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () => context.go('/profile/faqs'),
                                  child: Text(
                                    'Ver todas las FAQs →',
                                    style: TextStyle(
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
  const _StepsSection({required this.steps});

  final List<(String, String, String)> steps;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Empezá en 4 pasos',
          style: TextStyle(
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
            Text(
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
              label: 'Términos',
              onTap: () => context.go('/profile/terms'),
            ),
            _FooterLink(
              label: 'FAQs',
              onTap: () => context.go('/profile/faqs'),
            ),
            _FooterLink(
              label: 'Iniciar sesión',
              onTap: () => context.go('/login'),
            ),
            _FooterLink(
              label: 'Registrarse',
              onTap: () => context.go('/register'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'WPGG no está afiliado, asociado ni respaldado por Riot Games, Inc. League of Legends y Riot Games son marcas registradas de Riot Games, Inc.',
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 12,
            height: 1.5,
            color: WebColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '© ${DateTime.now().year} WPGG. Todos los derechos reservados.',
          style: TextStyle(
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
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          fontSize: 13,
          color: WebColors.textSecondary,
        ),
      ),
    );
  }
}
