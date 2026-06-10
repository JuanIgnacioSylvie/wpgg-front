import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../data/datasources/dexscreener_datasource.dart';
import '../../data/models/wpgg_token_price.dart';

/// Live WPGG token price from DexScreener with 60s auto-refresh.
class WpggPriceWidget extends StatefulWidget {
  const WpggPriceWidget({
    super.key,
    this.compact = false,
    this.showMarketStats = false,
  });

  /// Compact layout for mobile finance header.
  final bool compact;

  /// Shows 24h volume and pool liquidity (web finance).
  final bool showMarketStats;

  @override
  State<WpggPriceWidget> createState() => _WpggPriceWidgetState();
}

class _WpggPriceWidgetState extends State<WpggPriceWidget> {
  static const _refreshInterval = Duration(seconds: 60);

  final _dataSource = DexScreenerDataSource();
  Timer? _timer;

  WpggTokenPrice? _price;
  var _initialLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_fetchPrice());
    _timer = Timer.periodic(_refreshInterval, (_) => _fetchPrice());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchPrice() async {
    try {
      final price = await _dataSource.fetchWpggPrice();
      if (!mounted) return;
      setState(() {
        _price = price;
        _initialLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _initialLoading = false);
    }
  }

  static String formatPriceUsd(double price) {
    if (price >= 1) {
      return '\$${price.toStringAsFixed(2)} USD';
    }
    if (price >= 0.01) {
      return '\$${price.toStringAsFixed(4)} USD';
    }
    return '\$${price.toStringAsFixed(6)} USD';
  }

  static String formatPercent(double value) {
    final sign = value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  static String formatCompactUsd(double value) {
    if (value >= 1_000_000) {
      return '\$${(value / 1_000_000).toStringAsFixed(2)}M';
    }
    if (value >= 1_000) {
      return '\$${(value / 1_000).toStringAsFixed(1)}K';
    }
    return NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoading && _price == null) {
      return _PriceShimmer(compact: widget.compact);
    }

    final price = _price;
    if (price == null) {
      return const SizedBox.shrink();
    }

    if (widget.compact) {
      return _CompactPrice(price: price);
    }

    return _ExpandedPrice(
      price: price,
      showMarketStats: widget.showMarketStats,
    );
  }
}

class _CompactPrice extends StatelessWidget {
  const _CompactPrice({required this.price});

  final WpggTokenPrice price;

  @override
  Widget build(BuildContext context) {
    final changeColor = price.priceChangeH24 >= 0
        ? WpggBrand.incomeGreen
        : WpggBrand.expenseRed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _WpggPriceWidgetState.formatPriceUsd(price.priceUsd),
            style: const TextStyle(
              color: WpggBrand.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _WpggPriceWidgetState.formatPercent(price.priceChangeH24),
          style: TextStyle(
            color: changeColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ExpandedPrice extends StatelessWidget {
  const _ExpandedPrice({
    required this.price,
    required this.showMarketStats,
  });

  final WpggTokenPrice price;
  final bool showMarketStats;

  @override
  Widget build(BuildContext context) {
    final changeColor = price.priceChangeH24 >= 0
        ? WebColors.online
        : const Color(0xFFEF476F);
    final changeIcon = price.priceChangeH24 >= 0
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WebColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: WebColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.monetization_on_rounded,
                  color: WebColors.accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'WPGG',
                style: TextStyle(
                  color: WebColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(changeIcon, size: 16, color: changeColor),
                    const SizedBox(width: 4),
                    Text(
                      _WpggPriceWidgetState.formatPercent(price.priceChangeH24),
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _WpggPriceWidgetState.formatPriceUsd(price.priceUsd),
            style: const TextStyle(
              color: WebColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Precio en USD · actualizado cada 60s',
            style: TextStyle(
              color: WebColors.textMuted,
              fontSize: 12,
            ),
          ),
          if (showMarketStats) ...[
            const SizedBox(height: 24),
            const Divider(color: WebColors.borderSubtle, height: 1),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'Volumen 24h',
                    value: _WpggPriceWidgetState.formatCompactUsd(
                      price.volumeH24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatTile(
                    label: 'Liquidez',
                    value: _WpggPriceWidgetState.formatCompactUsd(
                      price.liquidityUsd,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: WebColors.textMuted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: WebColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PriceShimmer extends StatelessWidget {
  const _PriceShimmer({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return WebShimmerScope(
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: const [
                WebSkeletonBox(width: 120, height: 28, borderRadius: BorderRadius.all(Radius.circular(20))),
                SizedBox(height: 6),
                WebSkeletonBox(width: 48, height: 14),
              ],
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: WebColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: WebColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      WebSkeletonBox(width: 40, height: 40, borderRadius: BorderRadius.all(Radius.circular(10))),
                      SizedBox(width: 12),
                      WebSkeletonBox(width: 56, height: 18),
                      Spacer(),
                      WebSkeletonBox(width: 72, height: 24, borderRadius: BorderRadius.all(Radius.circular(20))),
                    ],
                  ),
                  SizedBox(height: 24),
                  WebSkeletonBox(width: 200, height: 36),
                  SizedBox(height: 8),
                  WebSkeletonBox(width: 180, height: 12),
                ],
              ),
            ),
    );
  }
}
