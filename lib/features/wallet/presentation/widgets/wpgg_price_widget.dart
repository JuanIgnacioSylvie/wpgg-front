import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../data/datasources/dexscreener_datasource.dart';
import '../../data/models/wpgg_token_price.dart';

/// Live WPGG token price (DexScreener → CoinGecko → GeckoTerminal) with 60s refresh.
class WpggPriceWidget extends StatefulWidget {
  const WpggPriceWidget({
    super.key,
    this.compact = false,
  });

  /// Compact layout for mobile finance header.
  final bool compact;

  static const _wpggCoinAsset = 'assets/images/wpgg-coin_32x32.png';
  static const _wpggCoinSize = 28.0;

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

    return _ExpandedPrice(price: price);
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
        const SizedBox(height: 4),
        const _GeckoTerminalLink(
          style: _GeckoTerminalLinkStyle.compact,
        ),
      ],
    );
  }
}

class _ExpandedPrice extends StatelessWidget {
  const _ExpandedPrice({required this.price});

  final WpggTokenPrice price;

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
              Image.asset(
                WpggPriceWidget._wpggCoinAsset,
                width: WpggPriceWidget._wpggCoinSize,
                height: WpggPriceWidget._wpggCoinSize,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(width: 10),
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
          Text(
            context.l10n.tokenPriceUpdatedHint,
            style: TextStyle(
              color: WebColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          const _GeckoTerminalLink(
            style: _GeckoTerminalLinkStyle.expanded,
          ),
        ],
      ),
    );
  }
}

enum _GeckoTerminalLinkStyle { compact, expanded }

class _GeckoTerminalLink extends StatelessWidget {
  const _GeckoTerminalLink({required this.style});

  final _GeckoTerminalLinkStyle style;

  Future<void> _open() async {
    final uri = Uri.parse(DexScreenerDataSource.wpggGeckoTerminalUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.viewOnGeckoTerminal;
    final isCompact = style == _GeckoTerminalLinkStyle.compact;

    return InkWell(
      onTap: _open,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.open_in_new_rounded,
              size: isCompact ? 12 : 14,
              color: isCompact ? WpggBrand.white.withValues(alpha: 0.75) : WebColors.accent,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isCompact ? WpggBrand.white.withValues(alpha: 0.75) : WebColors.accent,
                fontSize: isCompact ? 11 : 13,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: isCompact
                    ? WpggBrand.white.withValues(alpha: 0.5)
                    : WebColors.accent.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
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
                      WebSkeletonBox(
                        width: WpggPriceWidget._wpggCoinSize,
                        height: WpggPriceWidget._wpggCoinSize,
                        borderRadius: BorderRadius.all(Radius.circular(WpggPriceWidget._wpggCoinSize / 2)),
                      ),
                      SizedBox(width: 10),
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
