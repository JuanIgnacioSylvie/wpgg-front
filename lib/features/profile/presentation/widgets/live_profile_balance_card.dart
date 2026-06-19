import 'package:flutter/material.dart';

import '../../../../core/presentation/web/web_skeleton.dart';
import '../../../wallet/data/datasources/dexscreener_datasource.dart';
import '../../../wallet/domain/wpgg_balance_usd.dart';
import '../../../wallet/presentation/widgets/live_wpgg_price_scope.dart';
import 'profile_balance_card.dart';

/// Balance card valued with the same live price chain as Finance.
class LiveProfileBalanceCard extends StatefulWidget {
  const LiveProfileBalanceCard({
    super.key,
    required this.balanceWpgg,
    this.useWebStyle = false,
  });

  final int balanceWpgg;
  final bool useWebStyle;

  @override
  State<LiveProfileBalanceCard> createState() => _LiveProfileBalanceCardState();
}

class _LiveProfileBalanceCardState extends State<LiveProfileBalanceCard> {
  final _dataSource = DexScreenerDataSource();
  double? _priceUsd;
  bool _fetchScheduled = false;
  bool _priceFetchComplete = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (LiveWpggPriceScope.of(context) != null) {
      _priceFetchComplete = true;
      return;
    }
    if (_fetchScheduled) return;
    _fetchScheduled = true;
    _fetchPrice();
  }

  Future<void> _fetchPrice() async {
    try {
      final price = await _dataSource.fetchWpggPrice();
      if (!mounted) return;
      setState(() {
        _priceUsd = price.priceUsd;
        _priceFetchComplete = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _priceFetchComplete = true);
    }
  }

  double? _resolvedPriceUsd(BuildContext context) {
    return LiveWpggPriceScope.of(context) ?? _priceUsd;
  }

  double _balanceUsd(BuildContext context) {
    final price = _resolvedPriceUsd(context);
    if (price == null) return 0;
    return wpggBalanceToUsd(widget.balanceWpgg, price);
  }

  String _usdLabel(BuildContext context) {
    final price = _resolvedPriceUsd(context);
    if (price == null) return '—';
    return formatWpggUsdAmount(_balanceUsd(context));
  }

  bool _showSkeleton(BuildContext context) {
    if (!widget.useWebStyle) return false;
    if (_resolvedPriceUsd(context) != null) return false;
    return !_priceFetchComplete;
  }

  @override
  Widget build(BuildContext context) {
    if (_showSkeleton(context)) {
      return const WebShimmerScope(
        child: ProfileBalanceCardSkeleton(),
      );
    }

    return ProfileBalanceCard(
      balanceWpgg: widget.balanceWpgg,
      balanceUsd: _balanceUsd(context),
      usdLabelOverride: _usdLabel(context),
      useWebStyle: widget.useWebStyle,
    );
  }
}
