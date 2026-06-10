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
import '../../domain/store_catalog.dart';
import '../widgets/store_product_card.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
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
    final ddragon = context.watch<DDragonProvider>();

    return BlocBuilder<RiotBloc, RiotState>(
      builder: (context, riotState) {
        SummonerEntity? summoner;
        if (riotState is RiotLoaded) {
          summoner = riotState.summoner;
        }

        return WpggGradientScaffold(
          appBar: WpggAppBar(summoner: summoner, ddragon: ddragon),
          body: SingleChildScrollView(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
