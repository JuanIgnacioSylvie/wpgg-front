import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class ContactRemoteDataSource {
  ContactRemoteDataSource(this._api);

  final ApiClient _api;

  Future<void> submitSponsorProposal({
    required String companyName,
    required String contactEmail,
    required String message,
    String? turnstileToken,
  }) async {
    try {
      final data = <String, dynamic>{
        'companyName': companyName,
        'contactEmail': contactEmail,
        'message': message,
      };
      if (turnstileToken != null && turnstileToken.isNotEmpty) {
        data['turnstileToken'] = turnstileToken;
      }
      await _api.post<void>('/contact/sponsor', data: data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      if (status == 400 && body is Map && body['message'] != null) {
        final msg = body['message'];
        if (msg is List && msg.isNotEmpty) {
          throw ContactException(msg.first.toString());
        }
        if (msg is String) {
          throw ContactException(msg);
        }
      }
      throw ContactException(
        'No pudimos enviar tu propuesta. Intentá de nuevo en unos minutos.',
      );
    }
  }
}

class ContactException implements Exception {
  ContactException(this.message);

  final String message;

  @override
  String toString() => message;
}
