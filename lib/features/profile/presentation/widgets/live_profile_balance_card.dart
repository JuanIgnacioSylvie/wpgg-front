import 'package:flutter/material.dart';

import '../../../wallet/data/datasources/dexscreener_datasource.dart';
import 'profile_balance_card.dart';

/// Balance card that values WPGG using the same live DexScreener price as Finance.
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

  @override
  void initState() {
    super.initState();
    _fetchPrice();
  }

  Future<void> _fetchPrice() async {
    try {
      final price = await _dataSource.fetchWpggPrice();
      if (!mounted) return;
      setState(() => _priceUsd = price.priceUsd);
    } catch (_) {
      // Keep USD hidden until price loads.
    }
  }

  double _balanceUsd() {
    final price = _priceUsd;
    if (price == null) return 0;
    return widget.balanceWpgg * price;
  }

  String _usdLabel() {
    final usd = _balanceUsd();
    if (usd <= 0 && _priceUsd == null) return '—';
    if (usd >= 1) return '\$${usd.toStringAsFixed(2)}';
    if (usd >= 0.01) return '\$${usd.toStringAsFixed(4)}';
    return '\$${usd.toStringAsFixed(6)}';
  }

  @override
  Widget build(BuildContext context) {
    return ProfileBalanceCard(
      balanceWpgg: widget.balanceWpgg,
      balanceUsd: _balanceUsd(),
      usdLabelOverride: _usdLabel(),
      useWebStyle: widget.useWebStyle,
    );
  }
}
