import 'dart:convert';

/// Normalizes API list payloads across mobile and web (Dio may return String on web).
List<dynamic> parseJsonList(dynamic data) {
  if (data is List) return data;
  if (data is String) {
    final decoded = jsonDecode(data);
    if (decoded is List) return decoded;
  }
  if (data is Map) {
    final nested = data['items'] ?? data['data'];
    if (nested is List) return nested;
  }
  try {
    final normalized = jsonDecode(jsonEncode(data));
    if (normalized is List) return normalized;
  } catch (_) {}
  return const [];
}

/// Coerces JS interop / loosely typed JSON values into a Dart map.
Map<String, dynamic>? parseJsonMap(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    try {
      return Map<String, dynamic>.from(value);
    } catch (_) {}
  }
  try {
    final normalized = jsonDecode(jsonEncode(value));
    if (normalized is Map<String, dynamic>) return normalized;
    if (normalized is Map) return Map<String, dynamic>.from(normalized);
  } catch (_) {}
  return null;
}
