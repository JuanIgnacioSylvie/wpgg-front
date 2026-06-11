import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../domain/entities/store_product.dart';
import 'store_purchase_dialog.dart';

class WebStoreProductCard extends StatefulWidget {
  const WebStoreProductCard({
    super.key,
    required this.product,
  });

  final StoreProduct product;

  @override
  State<WebStoreProductCard> createState() => _WebStoreProductCardState();
}

class _WebStoreProductCardState extends State<WebStoreProductCard> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final product = widget.product;
    final priceLabel = NumberFormat.decimalPattern().format(product.priceWpgg);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 280,
        decoration: BoxDecoration(
          color: _hovered ? WebColors.surfaceElevated : WebColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? WebColors.border : WebColors.borderSubtle,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.asset(
                  product.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: WebColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: WebColors.border),
                    ),
                    child: Text(
                      '${product.rpAmount} RP',
                      style: const TextStyle(
                        fontFamily: AppFonts.lexendDeca,
                        color: WebColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WebColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.regionLabel,
                    style: const TextStyle(
                      fontFamily: AppFonts.lexendDeca,
                      color: WebColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/wpgg-coin_24x24.png',
                        width: 20,
                        height: 20,
                        filterQuality: FilterQuality.high,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$priceLabel WPGG',
                        style: const TextStyle(
                          fontFamily: AppFonts.lexendDeca,
                          color: WebColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: WpggPrimaryButton(
                      onPressed: () => showStorePurchaseDialog(product),
                      label: l10n.storeBuy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
