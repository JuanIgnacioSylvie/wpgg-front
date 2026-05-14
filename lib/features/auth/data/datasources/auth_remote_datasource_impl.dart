import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<AuthRemoteSession> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final res = await _api.post<dynamic>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'rememberMe': rememberMe,
        },
      );
      return _parseAuthSession(res.data, fallbackEmail: email);
    } on DioException catch (e) {
      throw AuthException(_message(e));
    }
  }

  @override
  Future<AuthRemoteSession> register({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _api.post<dynamic>(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
        },
      );
      return _parseAuthSession(res.data, fallbackEmail: email);
    } on DioException catch (e) {
      throw AuthException(_message(e));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _api.post<dynamic>('/auth/logout');
    } on DioException catch (e) {
      throw ServerException(_message(e));
    }
  }

  @override
  Future<AuthRemoteSession> refresh({String? refreshToken}) async {
    try {
      final body = <String, dynamic>{};
      if (refreshToken != null && refreshToken.isNotEmpty) {
        body['refreshToken'] = refreshToken;
      }
      final res = await _api.post<dynamic>(
        '/auth/refresh',
        data: body.isEmpty ? const <String, dynamic>{} : body,
      );
      return _parseAuthSession(res.data);
    } on DioException catch (e) {
      throw AuthException(_message(e, forRefresh: true));
    }
  }

  AuthRemoteSession _parseAuthSession(
    dynamic data, {
    String? fallbackEmail,
  }) {
    if (data is! Map) {
      throw const AuthException('Respuesta inválida del servidor');
    }
    final map = Map<String, dynamic>.from(data);
    final token = map['accessToken'] as String?;
    if (token == null || token.isEmpty) {
      throw const AuthException('Token no recibido');
    }
    final refresh = map['refreshToken'] as String? ?? map['refresh_token'] as String?;
    final refreshOut =
        refresh != null && refresh.isNotEmpty ? refresh : null;

    final user = map['user'];
    if (user is Map) {
      final u = Map<String, dynamic>.from(user);
      return (
        user: UserModel.fromAuthJson(u),
        accessToken: token,
        refreshToken: refreshOut,
      );
    }
    final fromJwt = _userFromAccessToken(token, fallbackEmail: fallbackEmail);
    return (
      user: fromJwt,
      accessToken: token,
      refreshToken: refreshOut,
    );
  }

  /// Backend que solo devuelve `accessToken`: leemos claims del JWT (sin verificar firma).
  UserModel _userFromAccessToken(String token, {String? fallbackEmail}) {
    try {
      final claims = _decodeJwtPayload(token);
      final id = _stringClaim(claims, 'sub') ??
          _stringClaim(claims, 'userId') ??
          _stringClaim(claims, 'id') ??
          '';
      final email = _stringClaim(claims, 'email') ??
          fallbackEmail ??
          '';
      if (id.isEmpty && email.isEmpty) {
        throw const AuthException('Token sin identidad de usuario');
      }
      return UserModel(id: id.isEmpty ? email : id, email: email);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('No se pudo leer el usuario del token');
    }
  }

  static Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const AuthException('Token inválido');
    }
    var payload = parts[1];
    switch (payload.length % 4) {
      case 2:
        payload += '==';
        break;
      case 3:
        payload += '=';
        break;
    }
    final jsonStr = utf8.decode(base64Url.decode(payload));
    final decoded = jsonDecode(jsonStr);
    if (decoded is! Map) {
      throw const AuthException('Token inválido');
    }
    return Map<String, dynamic>.from(decoded);
  }

  static String? _stringClaim(Map<String, dynamic> claims, String key) {
    final v = claims[key];
    if (v == null) return null;
    if (v is String) return v.isEmpty ? null : v;
    if (v is num) return v.toString();
    return null;
  }

  String _message(DioException e, {bool forRefresh = false}) {
    final d = e.response?.data;
    if (d is Map && d['message'] is String) return d['message'] as String;
    final raw = e.message ?? '';
    if (e.type == DioExceptionType.connectionError ||
        raw.contains('XMLHttpRequest')) {
      return 'No se pudo conectar con el servidor. En el navegador suele ser '
          'CORS, la URL del API (WPGG_BASE_URL) o contenido mixto (HTTPS vs HTTP). '
          'Revisá la pestaña Red en las herramientas de desarrollador.';
    }
    if (forRefresh &&
        kIsWeb &&
        e.response?.statusCode == 401 &&
        (d is! Map || d['message'] is! String)) {
      return 'Sesión no renovada (401 en /auth/refresh). Sin cookie enviada, '
          'el back necesita `refreshToken` en el body (guardado tras login/refresh) '
          'o Set-Cookie con SameSite=None en el API. Revisá Red → cabeceras y cuerpo.';
    }
    return raw.isNotEmpty ? raw : 'Error de red';
  }
}
