import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../locale/locale_provider.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/ddragon/presentation/providers/ddragon_provider.dart';
import '../../../features/profile/presentation/bloc/profile_settings_bloc.dart';
import '../../../features/profile/presentation/pages/faqs_page.dart';
import '../../../features/profile/presentation/pages/settings_page.dart';
import '../../../features/profile/presentation/pages/support_page.dart';
import '../../../features/profile/presentation/pages/terms_page.dart';
import '../../../features/notifications/presentation/bloc/notifications_bloc.dart';
import 'web_animations.dart';
import 'web_colors.dart';
import 'web_motion.dart';

enum _WebSettingsPanel { settings, faqs, support, terms }

Future<void> showWebSettingsDialog(BuildContext context) {
  return showWebDialog<void>(
    context: context,
    builder: (ctx) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<AuthBloc>()),
        BlocProvider.value(value: context.read<ProfileSettingsBloc>()),
        BlocProvider.value(value: context.read<NotificationsBloc>()),
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
        child: const _WebSettingsDialog(),
      ),
    ),
  );
}

class _WebSettingsDialog extends StatefulWidget {
  const _WebSettingsDialog();

  @override
  State<_WebSettingsDialog> createState() => _WebSettingsDialogState();
}

class _WebSettingsDialogState extends State<_WebSettingsDialog> {
  _WebSettingsPanel _panel = _WebSettingsPanel.settings;

  void _showSettings() => setState(() => _panel = _WebSettingsPanel.settings);

  void _showFaqs() => setState(() => _panel = _WebSettingsPanel.faqs);

  void _showSupport() => setState(() => _panel = _WebSettingsPanel.support);

  void _showTerms() => setState(() => _panel = _WebSettingsPanel.terms);

  @override
  Widget build(BuildContext context) {
    final isLegal = _panel != _WebSettingsPanel.settings;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: AnimatedContainer(
        duration: WebMotion.resolve(context, WebMotion.normal),
        curve: WebMotion.curve,
        constraints: BoxConstraints(
          minWidth: isLegal ? 480 : 440,
          maxWidth: isLegal ? 520 : 480,
          minHeight: 560,
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
              _WebSettingsPanel.settings => SettingsPage(
                  key: const ValueKey('settings'),
                  embeddedInPanel: true,
                  useWebPanelStyle: true,
                  onClose: () => Navigator.of(context).pop(),
                  onOpenFaqs: _showFaqs,
                  onOpenSupport: _showSupport,
                  onOpenTerms: _showTerms,
                ),
              _WebSettingsPanel.faqs => FaqsPage(
                  key: const ValueKey('faqs'),
                  embeddedInPanel: true,
                  useWebPanelStyle: true,
                  onBack: _showSettings,
                ),
              _WebSettingsPanel.support => SupportPage(
                  key: const ValueKey('support'),
                  embeddedInPanel: true,
                  useWebPanelStyle: true,
                  onBack: _showSettings,
                ),
              _WebSettingsPanel.terms => TermsPage(
                  key: const ValueKey('terms'),
                  embeddedInPanel: true,
                  useWebPanelStyle: true,
                  onBack: _showSettings,
                ),
            },
          ),
        ),
      ),
    );
  }
}
