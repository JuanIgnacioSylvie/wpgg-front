import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/wpgg_app_bar.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_state.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({
    super.key,
    this.embeddedInPanel = false,
  });

  final bool embeddedInPanel;

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
    final ddragon = context.watch<DDragonProvider>();

    final body = SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        widget.embeddedInPanel ? 24 : 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.faqsIntro,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 14,
              height: 1.5,
              color: widget.embeddedInPanel
                  ? WpggBrand.cardTextDark.withValues(alpha: 0.7)
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
                embeddedInPanel: widget.embeddedInPanel,
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
        ],
      ),
    );

    if (widget.embeddedInPanel) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: WpggBrand.cardTextDark,
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.faqsTitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WpggBrand.cardTextDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: body),
        ],
      );
    }

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

void openFaqsPage(BuildContext context, {required bool embeddedInPanel}) {
  if (embeddedInPanel) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => FaqsPage(embeddedInPanel: true),
      ),
    );
    return;
  }
  context.push('/profile/faqs');
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.embeddedInPanel,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final bool embeddedInPanel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: WpggBrand.cardSurface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
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
                      style: const TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: WpggBrand.cardTextDark,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: WpggBrand.primary,
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
                    color: WpggBrand.cardTextDark.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
