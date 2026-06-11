import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_fonts.dart';
import '../../../../core/constants/wpgg_brand.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/presentation/web/web_animations.dart';
import '../../../../core/presentation/web/web_colors.dart';
import '../../../../core/presentation/web/web_section_header.dart';
import '../../../../core/presentation/web/web_skeleton.dart';
import '../../data/datasources/wallet_remote_datasource.dart';
import '../bloc/wallet_bloc.dart';
import '../widgets/wpgg_price_widget.dart';

class WebFinancePage extends StatefulWidget {
  const WebFinancePage({super.key});

  @override
  State<WebFinancePage> createState() => _WebFinancePageState();
}

class _WebFinancePageState extends State<WebFinancePage> {
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

  static String _filterForTab(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return 'income';
      case 2:
        return 'expense';
      default:
        return 'all';
    }
  }

  WalletLoaded? _loadedState(WalletState state) {
    return switch (state) {
      WalletLoaded() => state,
      WalletWithdrawSuccess() => WalletLoaded(
          summary: state.summary,
          chart: state.chart,
          transactions: state.transactions,
          filter: state.filter,
        ),
      WalletWithdrawError() => WalletLoaded(
          summary: state.summary,
          chart: state.chart,
          transactions: state.transactions,
          filter: state.filter,
        ),
      WalletWithdrawing() => WalletLoaded(
          summary: state.summary,
          chart: const [],
          transactions: const [],
          filter: 'all',
        ),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    _requestWalletIfVisible();

    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        final loaded = _loadedState(state);
        final walletLoading = loaded == null &&
            (state is WalletLoading || state is WalletInitial);

        final l10n = context.l10n;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WebSectionHeader(
                title: l10n.financeTitle,
                subtitle: l10n.financeSubtitle,
              ),
              const SizedBox(height: 24),
              const WpggPriceWidget(),
              const SizedBox(height: 24),
              if (walletLoading)
                const WebAnimatedSwitcher(
                  child: _ChartSkeleton(key: ValueKey('chart-skeleton')),
                )
              else if (loaded != null)
                WebAnimatedSwitcher(
                  child: _WebMarketChart(
                    key: ValueKey('chart-${loaded.chart.length}'),
                    points: loaded.chart,
                    emptyLabel: l10n.financeNoChartData,
                    title: l10n.financePriceHistory,
                  ),
                ),
              const SizedBox(height: 32),
              if (walletLoading)
                const WebAnimatedSwitcher(
                  child: _WalletSkeleton(key: ValueKey('wallet-skeleton')),
                )
              else if (state is WalletError)
                _WalletError(message: state.message)
              else if (loaded != null)
                _WalletPanel(
                  state: loaded,
                  tabIndex: _tabIndex,
                  onTabChanged: (index) {
                    setState(() => _tabIndex = index);
                    context.read<WalletBloc>().add(
                          ChangeTransactionFilter(_filterForTab(index)),
                        );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _WalletPanel extends StatelessWidget {
  const _WalletPanel({
    required this.state,
    required this.tabIndex,
    required this.onTabChanged,
  });

  final WalletLoaded state;
  final int tabIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WebAnimatedSwitcher(
      child: Column(
        key: ValueKey('wallet-${state.summary.balance}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                Text(
                  l10n.financeYourBalance,
                  style: TextStyle(
                    color: WebColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.summary.balance} WPGG',
                  style: const TextStyle(
                    color: WebColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _FilterTab(
                label: l10n.financeFilterAll,
                selected: tabIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              _FilterTab(
                label: l10n.financeFilterIncome,
                selected: tabIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              _FilterTab(
                label: l10n.financeFilterExpense,
                selected: tabIndex == 2,
                onTap: () => onTabChanged(2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.transactions.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: WebColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: WebColors.borderSubtle),
              ),
              child: Text(
                l10n.financeNoTransactions,
                textAlign: TextAlign.center,
                style: TextStyle(color: WebColors.textSecondary),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: WebColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: WebColors.borderSubtle),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.transactions.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: WebColors.borderSubtle,
                ),
                itemBuilder: (_, i) {
                  final t = state.transactions[i];
                  final positive = t.amount > 0;
                  final color = positive
                      ? WpggBrand.incomeGreen
                      : WpggBrand.expenseRed;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.12),
                      child: Icon(
                        positive
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        color: color,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      t.description,
                      style: const TextStyle(
                        color: WebColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('d MMM, hh:mm a').format(t.createdAt),
                      style: const TextStyle(
                        color: WebColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Text(
                      '${positive ? '+' : ''}${t.amount}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? WebColors.accent.withValues(alpha: 0.12) : WebColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? WebColors.accent : WebColors.borderSubtle,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? WebColors.accent : WebColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletError extends StatelessWidget {
  const _WalletError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WebColors.borderSubtle),
      ),
      child: Text(
        message,
        style: const TextStyle(color: WebColors.textSecondary),
      ),
    );
  }
}

class _WebMarketChart extends StatelessWidget {
  const _WebMarketChart({
    super.key,
    required this.points,
    required this.emptyLabel,
    required this.title,
  });

  final List<MarketChartPoint> points;
  final String emptyLabel;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        color: WebColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WebColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.lexendDeca,
              color: WebColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: points.isEmpty
                ? Center(
                    child: Text(
                      emptyLabel,
                      style: const TextStyle(color: WebColors.textMuted),
                    ),
                  )
                : _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].priceUsd),
    ];
    final minY = points.map((p) => p.priceUsd).reduce((a, b) => a < b ? a : b);
    final maxY = points.map((p) => p.priceUsd).reduce((a, b) => a > b ? a : b);
    final yPadding = (maxY - minY) * 0.1;

    return LineChart(
      LineChartData(
        minY: minY - yPadding,
        maxY: maxY + yPadding,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (_) => const FlLine(
            color: WebColors.borderSubtle,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              getTitlesWidget: (value, _) {
                if (value >= maxY + yPadding || value <= minY - yPadding) {
                  return const SizedBox.shrink();
                }
                return Text(
                  '\$${value.toStringAsFixed(value >= 1 ? 2 : 4)}',
                  style: const TextStyle(
                    color: WebColors.textMuted,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: (points.length / 4).ceilToDouble().clamp(1, 7),
              getTitlesWidget: (value, _) {
                final i = value.round();
                if (i < 0 || i >= points.length) {
                  return const SizedBox.shrink();
                }
                final date = DateTime.tryParse(points[i].date);
                if (date == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('d/M').format(date),
                    style: const TextStyle(
                      color: WebColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => WebColors.surfaceElevated,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                final i = spot.x.round();
                final price = points[i.clamp(0, points.length - 1)].priceUsd;
                return LineTooltipItem(
                  '\$${price.toStringAsFixed(price >= 1 ? 4 : 6)}',
                  const TextStyle(
                    color: WebColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: WebColors.accent,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: WebColors.accent.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartSkeleton extends StatelessWidget {
  const _ChartSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return WebShimmerScope(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: WebColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: WebColors.borderSubtle),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WebSkeletonBox(width: 160, height: 14),
            SizedBox(height: 24),
            WebSkeletonBox(
              width: double.infinity,
              height: 180,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletSkeleton extends StatelessWidget {
  const _WalletSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return WebShimmerScope(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          WebSkeletonBox(
            width: double.infinity,
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              WebSkeletonBox(width: 72, height: 36, borderRadius: BorderRadius.all(Radius.circular(20))),
              SizedBox(width: 8),
              WebSkeletonBox(width: 80, height: 36, borderRadius: BorderRadius.all(Radius.circular(20))),
              SizedBox(width: 8),
              WebSkeletonBox(width: 72, height: 36, borderRadius: BorderRadius.all(Radius.circular(20))),
            ],
          ),
          SizedBox(height: 16),
          WebSkeletonBox(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ],
      ),
    );
  }
}
