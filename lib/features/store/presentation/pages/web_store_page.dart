import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../data/datasources/store_remote_datasource.dart';
import '../../domain/store_catalog.dart';
import '../bloc/store_bloc.dart';
import '../widgets/store_order_history.dart';
import '../widgets/web_store_product_card.dart';

class WebStorePage extends StatefulWidget {
  const WebStorePage({super.key});

  @override
  State<WebStorePage> createState() => _WebStorePageState();
}

class _WebStorePageState extends State<WebStorePage> {
  var _walletRequested = false;
  var _ordersRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _requestDataIfVisible();
  }

  void _requestDataIfVisible() {
    final route = ModalRoute.of(context);
    if (route == null || !route.isCurrent) return;

    if (!_walletRequested) {
      _walletRequested = true;
      context.read<WalletBloc>().add(const LoadWallet());
    }
    if (!_ordersRequested) {
      _ordersRequested = true;
      context.read<StoreBloc>().add(const LoadStoreOrders());
    }
  }

  @override
  Widget build(BuildContext context) {
    _requestDataIfVisible();
    final l10n = context.l10n;

    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        final orders = switch (state) {
          StoreLoaded(:final orders) => orders,
          _ => const <StoreOrderResult>[],
        };

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WebSectionHeader(
                title: l10n.storeTitle,
                count: StoreCatalog.products.length,
                subtitle: l10n.storeSubtitle,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  for (final product in StoreCatalog.products)
                    WebStoreProductCard(product: product),
                ],
              ),
              const SizedBox(height: 40),
              WebSectionHeader(title: l10n.storeOrderHistory),
              const SizedBox(height: 16),
              if (state is StoreLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(color: WebColors.accent),
                  ),
                )
              else if (state is StoreError)
                Text(
                  state.message,
                  style: const TextStyle(color: WebColors.textSecondary),
                )
              else
                StoreOrderHistory(orders: orders),
            ],
          ),
        );
      },
    );
  }
}
