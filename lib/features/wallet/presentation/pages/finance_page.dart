import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/presentation/wpgg_app_bar.dart';
import '../../../../core/presentation/wpgg_gradient_scaffold.dart';
import '../../../ddragon/presentation/providers/ddragon_provider.dart';
import '../../../riot/domain/entities/summoner_entity.dart';
import '../../../riot/presentation/bloc/riot_bloc.dart';
import '../../../riot/presentation/bloc/riot_state.dart';
import '../../data/datasources/wallet_remote_datasource.dart';
import '../bloc/wallet_bloc.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  var _tabIndex = 0;
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

  String get _filter {
    switch (_tabIndex) {
      case 1:
        return 'income';
      case 2:
        return 'expense';
      default:
        return 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    _requestWalletIfVisible();
    final ddragon = context.watch<DDragonProvider>();
    return BlocBuilder<RiotBloc, RiotState>(
      builder: (context, riotState) {
        SummonerEntity? summoner;
        if (riotState is RiotLoaded) {
          summoner = riotState.summoner;
        }
        return WpggGradientScaffold(
          appBar: WpggAppBar(summoner: summoner, ddragon: ddragon),
          body: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: WpggBrand.primary),
                );
              }
              if (state is WalletError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: WpggBrand.white),
                  ),
                );
              }
              if (state is! WalletLoaded) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                color: WpggBrand.primary,
                                size: 48,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'WPGG',
                                style: TextStyle(
                                  color: WpggBrand.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '\$ ${state.summary.latestPriceUsd.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: WpggBrand.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.summary.balance} WPGG',
                            style: const TextStyle(
                              color: WpggBrand.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: _Chart(points: state.chart),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: WpggBrand.cardSurface,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _Tab(
                                label: 'All Transactions',
                                selected: _tabIndex == 0,
                                onTap: () {
                                  setState(() => _tabIndex = 0);
                                  context.read<WalletBloc>().add(
                                        ChangeTransactionFilter(_filter),
                                      );
                                },
                              ),
                              _Tab(
                                label: 'Income',
                                selected: _tabIndex == 1,
                                onTap: () {
                                  setState(() => _tabIndex = 1);
                                  context.read<WalletBloc>().add(
                                        const ChangeTransactionFilter('income'),
                                      );
                                },
                              ),
                              _Tab(
                                label: 'Expense',
                                selected: _tabIndex == 2,
                                onTap: () {
                                  setState(() => _tabIndex = 2);
                                  context.read<WalletBloc>().add(
                                        const ChangeTransactionFilter('expense'),
                                      );
                                },
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: state.transactions.length,
                              itemBuilder: (_, i) {
                                final t = state.transactions[i];
                                final positive = t.amount > 0;
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: positive
                                        ? WpggBrand.incomeGreen.withValues(
                                            alpha: 0.15,
                                          )
                                        : WpggBrand.expenseRed.withValues(
                                            alpha: 0.15,
                                          ),
                                    child: Icon(
                                      positive
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: positive
                                          ? WpggBrand.incomeGreen
                                          : WpggBrand.expenseRed,
                                    ),
                                  ),
                                  title: Text(
                                    t.description,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('d MMM, hh:mm a')
                                        .format(t.createdAt),
                                  ),
                                  trailing: Text(
                                    '${positive ? '+' : ''}${t.amount}',
                                    style: TextStyle(
                                      color: positive
                                          ? WpggBrand.incomeGreen
                                          : WpggBrand.expenseRed,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.points});

  final List<MarketChartPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Center(
        child: Text('No chart data', style: TextStyle(color: WpggBrand.white)),
      );
    }
    final spots = <FlSpot>[];
    for (var i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), points[i].priceUsd));
    }
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: WpggBrand.primary,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: WpggBrand.primary.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? WpggBrand.primary : Colors.black45,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 80,
            color: selected ? WpggBrand.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
