import 'package:flutter/material.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';

class ProfileBalanceCard extends StatelessWidget {
  const ProfileBalanceCard({
    super.key,
    required this.balanceWpgg,
    required this.balanceUsd,
    this.usdLabelOverride,
    this.useWebStyle = false,
  });

  final int balanceWpgg;
  final double balanceUsd;
  final String? usdLabelOverride;
  final bool useWebStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final usdLabel = usdLabelOverride ??
        (balanceUsd >= 1
            ? '\$${balanceUsd.toStringAsFixed(2)}'
            : balanceUsd >= 0.01
                ? '\$${balanceUsd.toStringAsFixed(4)}'
                : '\$${balanceUsd.toStringAsFixed(6)}');

    if (useWebStyle) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: WebColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: WebColors.borderSubtle),
            boxShadow: [
              BoxShadow(
                color: WebColors.accent.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/wpgg-coin_24x24.png',
                width: 28,
                height: 28,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.balanceLabel,
                    style: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WebColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '$balanceWpgg WPGG',
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WebColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    l10n.balanceUsdEquivalent(usdLabel),
                    style: TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WebColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WpggBrand.primary, width: 1.5),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/wpgg-coin_24x24.png',
            width: 32,
            height: 32,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.balanceLabel,
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: WpggBrand.textMuted,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '$balanceWpgg WPGG',
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: WpggBrand.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  l10n.balanceUsdEquivalent(usdLabel),
                  style: const TextStyle(
                    fontFamily: AppFonts.lexendDeca,
                    color: WpggBrand.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
