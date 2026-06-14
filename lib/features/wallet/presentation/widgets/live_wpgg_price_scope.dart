import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/datasources/dexscreener_datasource.dart';

/// Provides the live WPGG/USD price (DexScreener → GeckoTerminal) to descendants.
class LiveWpggPriceScope extends StatefulWidget {
  const LiveWpggPriceScope({
    super.key,
    required this.child,
    this.refreshInterval = const Duration(seconds: 60),
  });

  final Widget child;
  final Duration refreshInterval;

  static double? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_LiveWpggPriceInherited>()
        ?.priceUsd;
  }

  @override
  State<LiveWpggPriceScope> createState() => _LiveWpggPriceScopeState();
}

class _LiveWpggPriceScopeState extends State<LiveWpggPriceScope> {
  final _dataSource = DexScreenerDataSource();

  Timer? _timer;
  double? _priceUsd;

  @override
  void initState() {
    super.initState();
    unawaited(_fetchPrice());
    _timer = Timer.periodic(widget.refreshInterval, (_) => _fetchPrice());
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
      if (_priceUsd == price.priceUsd) return;
      setState(() => _priceUsd = price.priceUsd);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return _LiveWpggPriceInherited(
      priceUsd: _priceUsd,
      child: widget.child,
    );
  }
}

class _LiveWpggPriceInherited extends InheritedWidget {
  const _LiveWpggPriceInherited({
    required this.priceUsd,
    required super.child,
  });

  final double? priceUsd;

  @override
  bool updateShouldNotify(_LiveWpggPriceInherited oldWidget) {
    return oldWidget.priceUsd != priceUsd;
  }
}
