import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class WalletSummary {
  WalletSummary({
    required this.balance,
    required this.minWithdrawWpgg,
    required this.rerollCostWpgg,
    required this.cancelCostWpgg,
    required this.latestPriceUsd,
  });

  final int balance;
  final int minWithdrawWpgg;
  final int rerollCostWpgg;
  final int cancelCostWpgg;
  final double latestPriceUsd;
}

class WalletTransaction {
  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  final String id;
  final String type;
  final int amount;
  final String description;
  final DateTime createdAt;
}

class MarketChartPoint {
  MarketChartPoint({required this.date, required this.priceUsd});

  final String date;
  final double priceUsd;
}

class WithdrawalResult {
  WithdrawalResult({
    required this.id,
    required this.walletAddress,
    required this.amountWpgg,
    required this.txHash,
    required this.status,
  });

  final String id;
  final String walletAddress;
  final int amountWpgg;
  final String? txHash;
  final String status;
}

abstract class WalletRemoteDataSource {
  Future<WalletSummary> fetchWallet();
  Future<List<WalletTransaction>> fetchTransactions(String filter);
  Future<List<MarketChartPoint>> fetchMarketChart(int days);
  Future<WithdrawalResult> requestWithdrawal({
    required String walletAddress,
    required int amountWpgg,
  });
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  WalletRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<WalletSummary> fetchWallet() async {
    final res = await _client.get<Map<String, dynamic>>('/wallet');
    final data = res.data!;
    return WalletSummary(
      balance: (data['balance'] as num?)?.toInt() ?? 0,
      minWithdrawWpgg: (data['minWithdrawWpgg'] as num?)?.toInt() ?? 1000,
      rerollCostWpgg: (data['rerollCostWpgg'] as num?)?.toInt() ?? 5,
      cancelCostWpgg: (data['cancelCostWpgg'] as num?)?.toInt() ?? 5,
      latestPriceUsd: (data['latestPriceUsd'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  Future<List<WalletTransaction>> fetchTransactions(String filter) async {
    final res = await _client.get<List<dynamic>>(
      '/wallet/transactions',
      queryParameters: {'filter': filter},
    );
    return (res.data ?? []).map((e) {
      final m = e as Map<String, dynamic>;
      return WalletTransaction(
        id: m['id'] as String,
        type: m['type'] as String,
        amount: (m['amount'] as num).toInt(),
        description: m['description'] as String,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );
    }).toList();
  }

  @override
  Future<List<MarketChartPoint>> fetchMarketChart(int days) async {
    final res = await _client.get<Map<String, dynamic>>(
      '/wallet/market-chart',
      queryParameters: {'days': days},
    );
    final points = res.data!['points'] as List<dynamic>? ?? [];
    return points.map((e) {
      final m = e as Map<String, dynamic>;
      return MarketChartPoint(
        date: m['date'] as String,
        priceUsd: (m['priceUsd'] as num).toDouble(),
      );
    }).toList();
  }

  @override
  Future<WithdrawalResult> requestWithdrawal({
    required String walletAddress,
    required int amountWpgg,
  }) async {
    try {
      final res = await _client.post<Map<String, dynamic>>(
        '/withdrawals',
        data: {
          'walletAddress': walletAddress,
          'amountWpgg': amountWpgg,
        },
      );
      final data = res.data!;
      return WithdrawalResult(
        id: data['id'] as String,
        walletAddress: data['walletAddress'] as String,
        amountWpgg: (data['amountWpgg'] as num).toInt(),
        txHash: data['txHash'] as String?,
        status: data['status'] as String,
      );
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body is Map && body['message'] != null) {
        final msg = body['message'];
        if (msg is List) {
          throw Exception(msg.join(', '));
        }
        throw Exception(msg.toString());
      }
      rethrow;
    }
  }
}
