import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/widgets/wpgg_card_elevation.dart';
import '../../../auth/presentation/widgets/wpgg_primary_button.dart';
import '../../domain/entities/store_product.dart';
import 'store_purchase_dialog.dart';

class StoreProductCard extends StatelessWidget {
  const StoreProductCard({
    super.key,
    required this.product,
  });

  final StoreProduct product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final priceLabel = NumberFormat.decimalPattern().format(product.priceWpgg);

    return Container(
      margin: EdgeInsets.zero,
      decoration: WpggCardElevation.enhance(
        BoxDecoration(
          color: WpggBrand.cardSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        baseColor: WpggBrand.cardSurface,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.asset(
              product.imageAsset,
              fit: BoxFit.cover,
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
                    color: WpggBrand.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${product.rpAmount} RP',
                    style: const TextStyle(
                      color: WpggBrand.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.regionLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/wpgg-coin_24x24.png',
                      width: 22,
                      height: 22,
                      filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$priceLabel WPGG',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: WpggPrimaryButton(
                    onPressed: () => showStorePurchaseDialog(context, product),
                    label: l10n.storeBuy,
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
