import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/locale/locale_provider.dart';
import '../../../../core/presentation/wpgg_app_bar.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../../data/terms_content.dart';
import '../widgets/legal_document_body.dart';
import '../widgets/profile_panel_header.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({
    super.key,
    this.embeddedInPanel = false,
    this.useWebPanelStyle = false,
    this.onBack,
  });

  final bool embeddedInPanel;
  final bool useWebPanelStyle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSpanish = Provider.of<LocaleProvider>(context).isSpanish;
    final sections = TermsContent.sectionsForLocale(isSpanish);

    final body = LegalDocumentBody(
      subtitle: TermsContent.subtitleForLocale(isSpanish),
      lastUpdated: TermsContent.lastUpdatedForLocale(isSpanish),
      sections: sections,
      useWebStyle: useWebPanelStyle,
      bottomPadding: embeddedInPanel ? 24 : 32,
    );

    if (embeddedInPanel) {
      return Column(
        children: [
          ProfilePanelHeader(
            title: l10n.termsAndConditionsTitle,
            onBack: onBack,
            useWebStyle: useWebPanelStyle,
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
            title: l10n.termsAndConditionsTitle,
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

void openTermsPage(
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
        builder: (_) => TermsPage(embeddedInPanel: true),
      ),
    );
    return;
  }
  context.push('/profile/terms');
}
