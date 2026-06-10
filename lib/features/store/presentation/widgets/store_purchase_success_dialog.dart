import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../../../core/presentation/wpgg_snackbar.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../data/datasources/store_remote_datasource.dart';

Future<void> showStorePurchaseSuccessDialog(
  BuildContext context,
  StorePurchaseResult result,
) {
  final isWeb = WebShellScope.isActive(context);

  Widget builder(BuildContext dialogContext) {
    final l10n = dialogContext.l10n;
    final order = result.order;

    void close() => Navigator.of(dialogContext).pop();

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                l10n.storePurchaseSuccessTitle,
                style: TextStyle(
                  fontFamily: AppFonts.lexendDeca,
                  fontSize: isWeb ? 17 : 18,
                  fontWeight: FontWeight.w700,
                  color: isWeb
                      ? WebColors.textPrimary
                      : WpggBrand.cardTextDark,
                  height: 1.25,
                ),
              ),
            ),
            IconButton(
              onPressed: close,
              icon: Icon(
                Icons.close,
                color: isWeb
                    ? WebColors.textSecondary
                    : WpggBrand.textMuted,
                size: isWeb ? 20 : 22,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
        SizedBox(height: isWeb ? 10 : 12),
        Text(
          l10n.storePurchaseSuccessBody(order.rpAmount),
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isWeb ? WebColors.textSecondary : WpggBrand.cardTextDark,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.storeYourKey,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: isWeb ? WebColors.textMuted : WpggBrand.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        SelectableText(
          order.riotKey,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: isWeb ? WebColors.accent : WpggBrand.primary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: isWeb ? 20 : 24),
        if (isWeb)
          Row(
            children: [
              Expanded(
                child: WpggCancelButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: order.riotKey));
                    WpggSnackBar.show(dialogContext, l10n.storeKeyCopied);
                  },
                  label: l10n.storeCopyKey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WpggPrimaryButton(
                  onPressed: close,
                  label: l10n.storeDone,
                ),
              ),
            ],
          )
        else ...[
          WpggCancelButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: order.riotKey));
              WpggSnackBar.show(dialogContext, l10n.storeKeyCopied);
            },
            label: l10n.storeCopyKey,
          ),
          const SizedBox(height: 12),
          WpggPrimaryButton(
            onPressed: close,
            label: l10n.storeDone,
          ),
        ],
      ],
    );

    if (isWeb) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: DecoratedBox(
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
              child: content,
            ),
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: WpggBrand.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 16, 24),
        child: content,
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
    useRootNavigator: false,
    barrierDismissible: false,
    builder: builder,
  );
}
