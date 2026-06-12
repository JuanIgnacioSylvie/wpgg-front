import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/wpgg_app_bar.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../../../landing/presentation/widgets/public_web_page_shell.dart';
import '../widgets/profile_panel_header.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({
    super.key,
    this.embeddedInPanel = false,
    this.useWebPanelStyle = false,
    this.standaloneWeb = false,
    this.onBack,
  });

  final bool embeddedInPanel;
  final bool useWebPanelStyle;
  final bool standaloneWeb;
  final VoidCallback? onBack;

  @override
  State<FaqsPage> createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  final _expanded = <int>{};

  List<({String question, String answer})> _items(BuildContext context) {
    final l10n = context.l10n;
    return [
      (question: l10n.faqWhatIsWpggQ, answer: l10n.faqWhatIsWpggA),
      (question: l10n.faqHowMissionsWorkQ, answer: l10n.faqHowMissionsWorkA),
      (question: l10n.faqRerollQ, answer: l10n.faqRerollA),
      (question: l10n.faqWithdrawQ, answer: l10n.faqWithdrawA),
      (question: l10n.faqWhatCanIDoQ, answer: l10n.faqWhatCanIDoA),
      (question: l10n.faqTokenPriceQ, answer: l10n.faqTokenPriceA),
      (question: l10n.faqGetRichQ, answer: l10n.faqGetRichA),
      (question: l10n.faqTransparencyQ, answer: l10n.faqTransparencyA),
      (question: l10n.faqCryptoKnowledgeQ, answer: l10n.faqCryptoKnowledgeA),
      (question: l10n.faqLoLAccountQ, answer: l10n.faqLoLAccountA),
      (question: l10n.faqAvailabilityQ, answer: l10n.faqAvailabilityA),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = _items(context);
    final useWeb = widget.useWebPanelStyle || widget.standaloneWeb;

    final faqContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.faqsIntro,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 14,
            height: 1.5,
            color: useWeb
                ? WebColors.textSecondary
                : WpggBrand.white.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(items.length, (index) {
          final item = items[index];
          final isExpanded = _expanded.contains(index);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FaqTile(
              question: item.question,
              answer: item.answer,
              expanded: isExpanded,
              useWebStyle: useWeb,
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expanded.remove(index);
                  } else {
                    _expanded.add(index);
                  }
                });
              },
            ),
          );
        }),
        SizedBox(height: widget.embeddedInPanel ? 24 : 32),
      ],
    );

    final body = widget.standaloneWeb
        ? faqContent
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: faqContent,
          );

    if (widget.standaloneWeb) {
      return PublicWebPageShell(
        title: l10n.faqsTitle,
        child: body,
      );
    }

    if (widget.embeddedInPanel) {
      return Column(
        children: [
          ProfilePanelHeader(
            title: l10n.faqsTitle,
            onBack: widget.onBack,
            useWebStyle: useWeb,
          ),
          Expanded(child: body),
        ],
      );
    }

    final ddragon = context.watch<DDragonProvider>();
    return BlocBuilder<RiotBloc, RiotState>(
      builder: (context, riotState) {
        SummonerEntity? summoner;
        if (riotState is RiotLoaded) {
          summoner = riotState.summoner;
        }
        return WpggGradientScaffold(
          appBar: WpggAppBar(
            title: l10n.faqsTitle,
            showBack: true,
            summoner: summoner,
            ddragon: ddragon,
          ),
          body: body,
        );
      },
    );
  }
}

void openFaqsPage(
  BuildContext context, {
  required bool embeddedInPanel,
  VoidCallback? onOpenInPanel,
}) {
  if (onOpenInPanel != null) {
    onOpenInPanel();
    return;
  }
  if (embeddedInPanel) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => FaqsPage(embeddedInPanel: true),
      ),
    );
    return;
  }
  context.push('/settings/faqs');
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.useWebStyle,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final bool useWebStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background =
        useWebStyle ? WebColors.surfaceElevated : WpggBrand.cardSurface;
    final borderColor = useWebStyle ? WebColors.border : Colors.transparent;
    final questionColor =
        useWebStyle ? WebColors.textPrimary : WpggBrand.cardTextDark;
    final answerColor = useWebStyle
        ? WebColors.textSecondary
        : WpggBrand.cardTextDark.withValues(alpha: 0.7);
    final iconColor = useWebStyle ? WebColors.accent : WpggBrand.primary;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(useWebStyle ? 12 : 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(useWebStyle ? 12 : 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(useWebStyle ? 12 : 20),
            border: useWebStyle
                ? Border.all(color: borderColor)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: questionColor,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: iconColor,
                      size: 24,
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: 12),
                  Text(
                    answer,
                    style: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: answerColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
