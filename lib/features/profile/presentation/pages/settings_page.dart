import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/locale/locale_provider.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../bloc/profile_settings_bloc.dart';
import '../widgets/profile_panel_header.dart';
import 'faqs_page.dart';
import 'terms_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
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
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const LoadNotificationPreference());
    context.read<ProfileSettingsBloc>().add(const LoadProfileSettings());
  }

  void _showLanguagePicker(
    BuildContext context,
    LocaleProvider localeProvider,
  ) {
    final accent = widget.useWebPanelStyle
        ? WebColors.accent
        : WpggBrand.primary;

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final code in LocaleProvider.supportedLanguageCodes)
              ListTile(
                title: Text(
                  context.languageLabelForCode(code),
                  style: const TextStyle(fontFamily: AppFonts.lexendDeca),
                ),
                trailing: localeProvider.languageCode == code
                    ? Icon(Icons.check, color: accent)
                    : null,
                onTap: () {
                  localeProvider.setLocale(Locale(code));
                  Navigator.pop(sheetContext);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await context.read<NotificationsBloc>().unregisterPushToken();
    if (!mounted) return;
    context.read<AuthBloc>().add(const LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final useWeb = widget.useWebPanelStyle;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, curr) => curr is AuthUnauthenticated,
      listener: (context, _) => context.go('/login'),
      child: Column(
        children: [
          if (widget.embeddedInPanel)
            ProfilePanelHeader(
              title: l10n.settingsTitle,
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
                        l10n.settingsTitle,
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
              child: Column(
                children: [
                  _SettingsCard(
                    useWebStyle: useWeb,
                    children: [
                      BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
                        listener: (context, state) {
                          if (state is ProfileSettingsLoaded &&
                              state.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage!)),
                            );
                          }
                        },
                        builder: (context, settingsState) {
                          final isPublic = switch (settingsState) {
                            ProfileSettingsLoaded(:final profilePublic) =>
                              profilePublic,
                            ProfileSettingsLoading() => false,
                            _ => false,
                          };
                          final saving = settingsState is ProfileSettingsLoaded
                              ? settingsState.saving
                              : false;
                          final loading =
                              settingsState is ProfileSettingsLoading ||
                                  settingsState is ProfileSettingsInitial;

                          return _SettingsRow(
                            icon: Icons.public,
                            label: l10n.profilePublicLabel,
                            subtitle: l10n.profilePublicHint,
                            useWebStyle: useWeb,
                            trailing: loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Switch(
                                    value: isPublic,
                                    onChanged: saving
                                        ? null
                                        : (value) => context
                                            .read<ProfileSettingsBloc>()
                                            .add(UpdateProfilePublic(
                                              profilePublic: value,
                                            )),
                                    activeThumbColor: WpggBrand.white,
                                    activeTrackColor: useWeb
                                        ? WebColors.accent
                                        : WpggBrand.primary,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingsCard(
                    useWebStyle: useWeb,
                    children: [
                      BlocConsumer<NotificationsBloc, NotificationsState>(
                        listener: (context, state) {
                          if (state is NotificationsLoaded &&
                              state.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage!)),
                            );
                          }
                        },
                        builder: (context, notifState) {
                          final enabled = switch (notifState) {
                            NotificationsLoading(:final enabled) => enabled,
                            NotificationsLoaded(:final enabled) => enabled,
                            _ => false,
                          };
                          final loading = notifState is NotificationsLoading;
                          return _SettingsRow(
                            icon: Icons.notifications_none,
                            label: l10n.generalNotification,
                            useWebStyle: useWeb,
                            trailing: Switch(
                              value: enabled,
                              onChanged: loading
                                  ? null
                                  : (value) => context
                                      .read<NotificationsBloc>()
                                      .add(ToggleNotifications(enabled: value)),
                              activeThumbColor: WpggBrand.white,
                              activeTrackColor: useWeb
                                  ? WebColors.accent
                                  : WpggBrand.primary,
                            ),
                          );
                        },
                      ),
                      Divider(
                        height: 1,
                        color: useWeb ? WebColors.borderSubtle : null,
                      ),
                      _SettingsRow(
                        icon: Icons.translate,
                        label: l10n.language,
                        useWebStyle: useWeb,
                        trailing: Text(
                          context.languageLabelForCode(
                            localeProvider.languageCode,
                          ),
                          style: TextStyle(
                            fontFamily: AppFonts.lexendDeca,
                            color: useWeb
                                ? WebColors.accent
                                : WpggBrand.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () =>
                            _showLanguagePicker(context, localeProvider),
                      ),
                      Divider(
                        height: 1,
                        color: useWeb ? WebColors.borderSubtle : null,
                      ),
                      _SettingsRow(
                        icon: Icons.account_balance_wallet_outlined,
                        label: l10n.financeTitle,
                        useWebStyle: useWeb,
                        onTap: () => context.go('/finance'),
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
                        color: useWeb ? WebColors.borderSubtle : null,
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: Text(l10n.logOut),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            useWeb ? WebColors.textSecondary : WpggBrand.white,
                        side: BorderSide(
                          color: useWeb
                              ? WebColors.border
                              : WpggBrand.primary,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    this.subtitle,
    this.trailing,
    this.onTap,
    this.useWebStyle = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        useWebStyle ? WebColors.textSecondary : WpggBrand.cardTextDark;
    final labelColor =
        useWebStyle ? WebColors.textPrimary : WpggBrand.cardTextDark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(useWebStyle ? 12 : 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          fontSize: 12,
                          color: useWebStyle
                              ? WebColors.textMuted
                              : WpggBrand.textMuted,
                        ),
                      ),
                    ],
                  ],
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
