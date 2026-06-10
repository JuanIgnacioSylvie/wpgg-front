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
  final builder = (BuildContext ctx) {
    final l10n = ctx.l10n;
    final order = result.order;

    return AlertDialog(
      backgroundColor: isWeb ? WebColors.surfaceElevated : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isWeb
            ? const BorderSide(color: WebColors.border)
            : BorderSide.none,
      ),
      title: Text(
        l10n.storePurchaseSuccessTitle,
        style: TextStyle(
          fontFamily: AppFonts.lexendDeca,
          color: isWeb ? WebColors.textPrimary : Colors.black87,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.storePurchaseSuccessBody(order.rpAmount),
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: isWeb ? WebColors.textSecondary : Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.storeYourKey,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: isWeb ? WebColors.textMuted : Colors.black45,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            order.riotKey,
            style: TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: isWeb ? WebColors.textPrimary : WpggBrand.primary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        WpggCancelButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: order.riotKey));
            WpggSnackBar.show(ctx, l10n.storeKeyCopied);
          },
          label: l10n.storeCopyKey,
        ),
        WpggPrimaryButton(
          onPressed: () => Navigator.pop(ctx),
          label: l10n.storeDone,
        ),
      ],
    );
  };

  if (isWeb) {
    return showWebDialog<void>(context: context, builder: builder);
  }
  return showDialog<void>(context: context, builder: builder);
}
