import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../domain/store_catalog.dart';
import '../widgets/web_store_product_card.dart';

class WebStorePage extends StatefulWidget {
  const WebStorePage({super.key});

  @override
  State<WebStorePage> createState() => _WebStorePageState();
}

class _WebStorePageState extends State<WebStorePage> {
  var _walletRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _requestWalletIfVisible();
  }

  void _requestWalletIfVisible() {
    if (_walletRequested) return;
    final route = ModalRoute.of(context);
    if (route == null || !route.isCurrent) return;
    _walletRequested = true;
    context.read<WalletBloc>().add(const LoadWallet());
  }

  @override
  Widget build(BuildContext context) {
    _requestWalletIfVisible();
    final l10n = context.l10n;

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
        ],
      ),
    );
  }
}
