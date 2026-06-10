import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/wpgg_app_bar.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../data/datasources/store_remote_datasource.dart';
import '../../domain/store_catalog.dart';
import '../bloc/store_bloc.dart';
import '../widgets/store_order_history.dart';
import '../widgets/store_product_card.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
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
    final ddragon = context.watch<DDragonProvider>();

    return BlocBuilder<RiotBloc, RiotState>(
      builder: (context, riotState) {
        SummonerEntity? summoner;
        if (riotState is RiotLoaded) {
          summoner = riotState.summoner;
        }

        return WpggGradientScaffold(
          appBar: WpggAppBar(summoner: summoner, ddragon: ddragon),
          body: BlocBuilder<StoreBloc, StoreState>(
            builder: (context, state) {
              final orders = switch (state) {
                StoreLoaded(:final orders) => orders,
                _ => const <StoreOrderResult>[],
              };

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.storeTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: WpggBrand.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.storeSubtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: WpggBrand.white.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final product in StoreCatalog.products) ...[
                      StoreProductCard(product: product),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      l10n.storeOrderHistory,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: WpggBrand.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (state is StoreLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(
                            color: WpggBrand.primary,
                          ),
                        ),
                      )
                    else if (state is StoreError)
                      Text(
                        state.message,
                        style: TextStyle(
                          color: WpggBrand.white.withValues(alpha: 0.75),
                        ),
                      )
                    else
                      StoreOrderHistory(orders: orders),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
