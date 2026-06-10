import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/auth_ui_colors.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../auth_strings.dart';
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
          WpggSnackBar.show(context, state.message, isError: true);
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthStrings.riotAlreadyExistsTitle,
                        style: TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AuthUiColors.cardText,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        AuthStrings.riotAlreadyExistsBody,
                        style: TextStyle(
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
              label: AuthStrings.riotAlreadyExistsSignInRiot,
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(
                      const RiotRsoSignInRequested(requestRedirect: true),
                    );
              },
            ),
            const SizedBox(height: 12),
            WpggCancelButton(
              label: AuthStrings.riotAlreadyExistsCancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
