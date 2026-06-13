import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_public_config.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/turnstile_widget.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/wpgg_app_bar.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../landing/data/datasources/contact_remote_datasource.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../widgets/profile_panel_header.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({
    super.key,
    this.embeddedInPanel = false,
    this.useWebPanelStyle = false,
    this.onBack,
  });

  final bool embeddedInPanel;
  final bool useWebPanelStyle;
  final VoidCallback? onBack;

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  var _submitting = false;
  var _submitted = false;
  String? _turnstileToken;

  bool get _needsTurnstile => AppPublicConfig.turnstileEnabled;

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  String? _userEmail(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.email;
    }
    return null;
  }

  Future<void> _submit(BuildContext context) async {
    final l10n = context.l10n;
    final contactEmail = _userEmail(context);
    if (_submitting || _submitted) return;
    if (contactEmail == null || contactEmail.isEmpty) {
      WpggSnackBar.show(context, l10n.supportEmailUnavailable, isError: true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    if (_needsTurnstile &&
        (_turnstileToken == null || _turnstileToken!.isEmpty)) {
      WpggSnackBar.show(
        context,
        l10n.supportTurnstileRequired,
        isError: true,
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await sl<ContactRemoteDataSource>().submitSupportRequest(
        contactEmail: contactEmail,
        subject: _subject.text.trim(),
        message: _message.text.trim(),
        turnstileToken: _turnstileToken,
      );
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitted = true;
      });
      WpggSnackBar.show(context, l10n.supportThanksSnackbar);
    } on ContactException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      resetTurnstileWidget();
      setState(() => _turnstileToken = null);
      WpggSnackBar.show(context, e.message, isError: true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      resetTurnstileWidget();
      setState(() => _turnstileToken = null);
      WpggSnackBar.show(context, l10n.supportSubmitError, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final useWeb = widget.useWebPanelStyle;
    final contactEmail = _userEmail(context);

    final formBody = _submitted
        ? _SupportSuccessState(useWebStyle: useWeb)
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.supportIntro,
                  style: TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    fontSize: 14,
                    height: 1.5,
                    color: useWeb
                        ? WebColors.textSecondary
                        : WpggBrand.white.withValues(alpha: 0.85),
                  ),
                ),
                if (contactEmail != null) ...[
                  const SizedBox(height: 16),
                  _SupportReadonlyField(
                    label: l10n.supportEmailLabel,
                    value: contactEmail,
                    useWebStyle: useWeb,
                  ),
                ],
                const SizedBox(height: 16),
                _SupportField(
                  controller: _subject,
                  label: l10n.supportSubjectLabel,
                  hint: l10n.supportSubjectHint,
                  useWebStyle: useWeb,
                  validator: (v) {
                    if (v == null || v.trim().length < 5) {
                      return l10n.supportSubjectError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _SupportField(
                  controller: _message,
                  label: l10n.supportMessageLabel,
                  hint: l10n.supportMessageHint,
                  useWebStyle: useWeb,
                  maxLines: 5,
                  validator: (v) {
                    if (v == null || v.trim().length < 20) {
                      return l10n.supportMessageError;
                    }
                    return null;
                  },
                ),
                if (_needsTurnstile) ...[
                  const SizedBox(height: 20),
                  TurnstileWidget(
                    siteKey: AppPublicConfig.turnstileSiteKey,
                    onToken: (token) => setState(() => _turnstileToken = token),
                    onExpired: () => setState(() => _turnstileToken = null),
                    onError: () => setState(() => _turnstileToken = null),
                  ),
                ],
                const SizedBox(height: 24),
                WpggPrimaryButton(
                  label: l10n.supportSubmit,
                  isLoading: _submitting,
                  onPressed: _submitting ? null : () => _submit(context),
                ),
              ],
            ),
          );

    if (widget.embeddedInPanel) {
      return Column(
        children: [
          ProfilePanelHeader(
            title: l10n.supportMenuItem,
            onBack: widget.onBack,
            useWebStyle: useWeb,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: formBody,
            ),
          ),
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
            title: l10n.supportMenuItem,
            showBack: true,
            summoner: summoner,
            ddragon: ddragon,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            child: formBody,
          ),
        );
      },
    );
  }
}

void openSupportPage(
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
        builder: (_) => const SupportPage(embeddedInPanel: true),
      ),
    );
    return;
  }
  context.push('/settings/support');
}

class _SupportSuccessState extends StatelessWidget {
  const _SupportSuccessState({required this.useWebStyle});

  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          color: useWebStyle ? WebColors.online : WpggBrand.primary,
          size: 36,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.supportSentTitle,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: useWebStyle ? WebColors.textPrimary : WpggBrand.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.supportSentBody,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 14,
            height: 1.55,
            color: useWebStyle
                ? WebColors.textSecondary
                : WpggBrand.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

class _SupportReadonlyField extends StatelessWidget {
  const _SupportReadonlyField({
    required this.label,
    required this.value,
    required this.useWebStyle,
  });

  final String label;
  final String value;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: useWebStyle ? WebColors.textSecondary : WpggBrand.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: useWebStyle
                ? WebColors.surfaceElevated
                : Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: useWebStyle ? WebColors.border : WpggBrand.primary,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              fontSize: 14,
              color: useWebStyle ? WebColors.textPrimary : WpggBrand.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportField extends StatelessWidget {
  const _SupportField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.useWebStyle,
    this.validator,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool useWebStyle;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: useWebStyle ? WebColors.textSecondary : WpggBrand.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 14,
            color: useWebStyle ? WebColors.textPrimary : WpggBrand.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: useWebStyle ? WebColors.textMuted : WpggBrand.textMuted,
              fontSize: 14,
            ),
            filled: true,
            fillColor: useWebStyle
                ? WebColors.surfaceElevated
                : Colors.black.withValues(alpha: 0.25),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: useWebStyle ? WebColors.border : WpggBrand.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: useWebStyle ? WebColors.border : WpggBrand.primary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: useWebStyle ? WebColors.accent : WpggBrand.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: (useWebStyle ? WebColors.accent : WpggBrand.primary)
                    .withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
