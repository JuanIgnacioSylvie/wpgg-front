import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../data/datasources/store_remote_datasource.dart';

Future<void> showStorePurchaseSuccessDialog(
  BuildContext context,
  StorePurchaseResult result,
) {
  final isWeb = WebShellScope.isActive(context);

  Widget builder(BuildContext ctx) {
    final l10n = ctx.l10n;
    final order = result.order;

    return Dialog(
      backgroundColor: WpggBrand.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
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
                  child: Text(
                    l10n.storePurchaseSuccessTitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: WpggBrand.cardTextDark,
                      height: 1.25,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.of(ctx, rootNavigator: true).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: WpggBrand.textMuted,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.storePurchaseSuccessBody(order.rpAmount),
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: WpggBrand.cardTextDark,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.storeYourKey,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WpggBrand.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            SelectableText(
              order.riotKey,
              style: const TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: WpggBrand.primary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),
            WpggCancelButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: order.riotKey));
                WpggSnackBar.show(ctx, l10n.storeKeyCopied);
              },
              label: l10n.storeCopyKey,
            ),
            const SizedBox(height: 12),
            WpggPrimaryButton(
              onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
              label: l10n.storeDone,
            ),
          ],
        ),
      ),
    );
  }

  if (isWeb) {
    return showWebDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: builder,
    );
  }
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: builder,
  );
}
