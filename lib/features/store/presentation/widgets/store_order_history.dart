import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_shell_scope.dart';
import '../../data/datasources/store_remote_datasource.dart';

class StoreOrderHistory extends StatelessWidget {
  const StoreOrderHistory({
    super.key,
    required this.orders,
  });

  final List<StoreOrderResult> orders;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isWeb = WebShellScope.isActive(context);

    if (orders.isEmpty) {
      return Text(
        l10n.storeNoOrders,
        style: TextStyle(
          fontFamily: isWeb ? AppFonts.lexendDeca : null,
          color: isWeb
              ? WebColors.textMuted
              : WpggBrand.white.withValues(alpha: 0.7),
          fontSize: 13,
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < orders.length; i++) ...[
          _OrderTile(order: orders[i], isWeb: isWeb),
          if (i < orders.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({
    required this.order,
    required this.isWeb,
  });

  final StoreOrderResult order;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().add_Hm().format(order.createdAt.toLocal());
    final price = NumberFormat.decimalPattern().format(order.priceWpgg);

    if (isWeb) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: WebColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: WebColors.borderSubtle),
        ),
        child: _OrderContent(
          order: order,
          date: date,
          price: price,
          titleColor: WebColors.textPrimary,
          subtitleColor: WebColors.textSecondary,
          keyColor: WebColors.textPrimary,
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: _OrderContent(
          order: order,
          date: date,
          price: price,
          titleColor: Colors.black87,
          subtitleColor: Colors.black54,
          keyColor: Colors.black87,
        ),
      ),
    );
  }
}

class _OrderContent extends StatelessWidget {
  const _OrderContent({
    required this.order,
    required this.date,
    required this.price,
    required this.titleColor,
    required this.subtitleColor,
    required this.keyColor,
  });

  final StoreOrderResult order;
  final String date;
  final String price;
  final Color titleColor;
  final Color subtitleColor;
  final Color keyColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${order.rpAmount} RP · $price WPGG',
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: titleColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: subtitleColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        SelectableText(
          order.riotKey,
          style: TextStyle(
            fontFamily: AppFonts.lexendDeca,
            color: keyColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
