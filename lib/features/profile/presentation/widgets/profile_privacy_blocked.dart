import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';

class ProfilePrivacyBlocked extends StatelessWidget {
  const ProfilePrivacyBlocked({
    super.key,
    this.useWebStyle = false,
    this.onOpenSettings,
  });

  final bool useWebStyle;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final titleColor =
        useWebStyle ? WebColors.textPrimary : WpggBrand.white;
    final bodyColor =
        useWebStyle ? WebColors.textSecondary : WpggBrand.textMuted;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 48,
              color: useWebStyle ? WebColors.textMuted : WpggBrand.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.profilePrivateViewerTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: titleColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.profilePrivateViewerBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.lexendDeca,
                color: bodyColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onOpenSettings ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                    }
                    context.go('/settings');
                  },
              style: FilledButton.styleFrom(
                backgroundColor:
                    useWebStyle ? WebColors.accent : WpggBrand.primary,
              ),
              child: Text(l10n.profileOpenSettings),
            ),
          ],
        ),
      ),
    );
  }
}
