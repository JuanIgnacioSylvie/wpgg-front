import 'package:flutter/material.dart';

import '../../../../core/config/app_public_config.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/web/turnstile_widget.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../data/datasources/contact_remote_datasource.dart';

class LandingSponsorForm extends StatefulWidget {
  const LandingSponsorForm({super.key});

  @override
  State<LandingSponsorForm> createState() => _LandingSponsorFormState();
}

class _LandingSponsorFormState extends State<LandingSponsorForm> {
  final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  var _submitting = false;
  var _submitted = false;
  String? _turnstileToken;

  bool get _needsTurnstile => AppPublicConfig.turnstileEnabled;

  @override
  void dispose() {
    _company.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || _submitted) return;
    if (!_formKey.currentState!.validate()) return;

    if (_needsTurnstile &&
        (_turnstileToken == null || _turnstileToken!.isEmpty)) {
      WpggSnackBar.show(
        context,
        'Completá la verificación de seguridad antes de enviar.',
        isError: true,
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await sl<ContactRemoteDataSource>().submitSponsorProposal(
        companyName: _company.text.trim(),
        contactEmail: _email.text.trim(),
        message: _message.text.trim(),
        turnstileToken: _turnstileToken,
      );
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitted = true;
      });
      WpggSnackBar.show(
        context,
        '¡Gracias! Recibimos tu propuesta y te vamos a contactar.',
      );
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
      WpggSnackBar.show(
        context,
        'No pudimos enviar tu propuesta. Intentá de nuevo.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: WebColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: WebColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_outline, color: WebColors.online, size: 36),
            const SizedBox(height: 16),
            Text(
              'Propuesta enviada',
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: WebColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gracias por tu interés en apoyar WPGG. Revisamos cada propuesta y te respondemos a la brevedad.',
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                fontSize: 14,
                height: 1.55,
                color: WebColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WebColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _LandingField(
              controller: _company,
              label: 'Empresa o marca',
              hint: 'Tu organización',
              validator: (v) {
                if (v == null || v.trim().length < 2) {
                  return 'Ingresá el nombre de tu empresa o marca';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _LandingField(
              controller: _email,
              label: 'Email de contacto',
              hint: 'hola@tuempresa.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty || !value.contains('@')) {
                  return 'Ingresá un email válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _LandingField(
              controller: _message,
              label: 'Tu propuesta',
              hint:
                  'Contanos qué tipo de colaboración tenés en mente: activación, premios, branding, etc.',
              maxLines: 5,
              validator: (v) {
                if (v == null || v.trim().length < 20) {
                  return 'Contanos un poco más sobre tu propuesta (mín. 20 caracteres)';
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
              label: 'Enviar propuesta',
              isLoading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _LandingField extends StatelessWidget {
  const _LandingField({
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
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
            color: WebColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 14,
            color: WebColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: WebColors.textMuted,
              fontSize: 14,
            ),
            filled: true,
            fillColor: WebColors.surfaceElevated,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: WebColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: WebColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: WebColors.accent, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: WebColors.accent.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
