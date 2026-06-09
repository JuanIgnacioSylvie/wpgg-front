import 'package:dio/dio.dart';

String networkErrorMessage(
  Object error, {
  String fallback = 'Error de red',
}) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      final msg = data['message'];
      if (msg is String) return msg;
      if (msg is List) return msg.join(', ');
    }
    final message = error.message;
    if (message != null && message.isNotEmpty) {
      return message;
    }
  }
  final text = error.toString();
  if (text.startsWith('Exception: ')) {
    return text.substring('Exception: '.length);
  }
  return fallback;
}
