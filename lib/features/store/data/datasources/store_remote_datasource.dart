import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class StoreOrderResult {
  StoreOrderResult({
    required this.id,
    required this.productId,
    required this.productSlug,
    required this.productName,
    required this.rpAmount,
    required this.priceWpgg,
    required this.riotKey,
    required this.createdAt,
  });

  final String id;
  final String productId;
  final String productSlug;
  final String productName;
  final int rpAmount;
  final int priceWpgg;
  final String riotKey;
  final DateTime createdAt;
}

class StorePurchaseResult {
  StorePurchaseResult({
    required this.order,
    required this.balance,
  });

  final StoreOrderResult order;
  final int balance;
}

abstract class StoreRemoteDataSource {
  Future<List<StoreOrderResult>> fetchOrders();
  Future<StorePurchaseResult> purchaseProduct({
    required String productSlug,
    required String idempotencyKey,
  });
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  StoreRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  StoreOrderResult _mapOrder(Map<String, dynamic> m) {
    return StoreOrderResult(
      id: m['id'] as String,
      productId: m['productId'] as String,
      productSlug: m['productSlug'] as String,
      productName: m['productName'] as String,
      rpAmount: (m['rpAmount'] as num).toInt(),
      priceWpgg: (m['priceWpgg'] as num).toInt(),
      riotKey: m['riotKey'] as String,
      createdAt: DateTime.parse(m['createdAt'] as String),
    );
  }

  String _extractError(DioException e) {
    final body = e.response?.data;
    if (body is Map && body['message'] != null) {
      final msg = body['message'];
      if (msg is List) {
        return msg.join(', ');
      }
      return msg.toString();
    }
    return e.message ?? 'Error';
  }

  @override
  Future<List<StoreOrderResult>> fetchOrders() async {
    final res = await _client.get<Map<String, dynamic>>('/store/orders');
    final orders = res.data?['orders'] as List<dynamic>? ?? [];
    return orders
        .map((e) => _mapOrder(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<StorePurchaseResult> purchaseProduct({
    required String productSlug,
    required String idempotencyKey,
  }) async {
    try {
      final res = await _client.post<Map<String, dynamic>>(
        '/store/products/$productSlug/purchase',
        options: Options(headers: {'Idempotency-Key': idempotencyKey}),
      );
      final data = res.data!;
      return StorePurchaseResult(
        order: _mapOrder(data['order'] as Map<String, dynamic>),
        balance: (data['balance'] as num).toInt(),
      );
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }
}
