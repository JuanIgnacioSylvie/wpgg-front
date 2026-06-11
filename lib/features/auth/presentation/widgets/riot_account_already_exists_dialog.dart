import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'wpgg_primary_button.dart';

/// Modal: registro/login Riot cuando la cuenta WPGG ya existe (placeholder o vinculada).
Future<void> showRiotAccountAlreadyExistsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          WpggSnackBar.show(
            context,
            context.localizeAuthError(state.message),
            isError: true,
          );
        }
      },
      child: const _RiotAccountAlreadyExistsDialog(),
    ),
  );
}

class _RiotAccountAlreadyExistsDialog extends StatelessWidget {
  const _RiotAccountAlreadyExistsDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Dialog(
      backgroundColor: AuthUiColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.riotAlreadyExistsTitle,
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AuthUiColors.cardText,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.riotAlreadyExistsBody,
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AuthUiColors.cardTextMuted,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: AuthUiColors.cardTextMuted,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            const SizedBox(height: 24),
            WpggPrimaryButton(
              label: l10n.riotAlreadyExistsSignInRiot,
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(
                      const RiotRsoSignInRequested(requestRedirect: true),
                    );
              },
            ),
            const SizedBox(height: 12),
            WpggCancelButton(
              label: l10n.cancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
