import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../locale/locale_provider.dart';
import '../../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../../../features/profile/presentation/pages/faqs_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/profile/presentation/pages/terms_page.dart';
import '../../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../../features/wallet/presentation/bloc/wallet_bloc.dart';
import 'web_animations.dart';
import 'web_colors.dart';
import 'web_motion.dart';

enum _WebProfilePanel { profile, faqs, terms }

Future<void> showWebProfileDialog(BuildContext context) {
  return showWebDialog<void>(
    context: context,
    builder: (ctx) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<RiotBloc>()),
        BlocProvider.value(value: context.read<WalletBloc>()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: context.read<DDragonProvider>(),
          ),
          ChangeNotifierProvider.value(
            value: context.read<LocaleProvider>(),
          ),
        ],
        child: const _WebProfileDialog(),
      ),
    ),
  );
}

class _WebProfileDialog extends StatefulWidget {
  const _WebProfileDialog();

  @override
  State<_WebProfileDialog> createState() => _WebProfileDialogState();
}

class _WebProfileDialogState extends State<_WebProfileDialog> {
  _WebProfilePanel _panel = _WebProfilePanel.profile;

  void _showProfile() => setState(() => _panel = _WebProfilePanel.profile);

  void _showFaqs() => setState(() => _panel = _WebProfilePanel.faqs);

  void _showTerms() => setState(() => _panel = _WebProfilePanel.terms);

  @override
  Widget build(BuildContext context) {
    final isLegal = _panel != _WebProfilePanel.profile;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: AnimatedContainer(
          duration: WebMotion.resolve(context, WebMotion.normal),
          curve: WebMotion.curve,
          constraints: BoxConstraints(
            maxWidth: isLegal ? 520 : 440,
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
            child: AnimatedSwitcher(
              duration: WebMotion.resolve(context, WebMotion.normal),
              switchInCurve: WebMotion.curve,
              switchOutCurve: WebMotion.curve,
              transitionBuilder: (child, animation) {
                return WebFadeSlideTransition(
                  animation: animation,
                  child: child,
                );
              },
              child: switch (_panel) {
                _WebProfilePanel.profile => ProfilePage(
                    key: const ValueKey('profile'),
                    embeddedInPanel: true,
                    onClose: () => Navigator.of(context).pop(),
                    onOpenFaqs: _showFaqs,
                    onOpenTerms: _showTerms,
                  ),
                _WebProfilePanel.faqs => FaqsPage(
                    key: const ValueKey('faqs'),
                    embeddedInPanel: true,
                    useWebPanelStyle: true,
                    onBack: _showProfile,
                  ),
                _WebProfilePanel.terms => TermsPage(
                    key: const ValueKey('terms'),
                    embeddedInPanel: true,
                    useWebPanelStyle: true,
                    onBack: _showProfile,
                  ),
              },
            ),
          ),
        ),
    );
  }
}
