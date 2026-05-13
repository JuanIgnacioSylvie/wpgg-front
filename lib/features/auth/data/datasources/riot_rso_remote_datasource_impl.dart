import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/auth_request_extra.dart';
import '../../../../core/oauth/riot_rso_sign_in_url.dart';
import '../../domain/entities/riot_rso_entities.dart';
import 'riot_rso_remote_datasource.dart';

class RiotRsoRemoteDataSourceImpl implements RiotRsoRemoteDataSource {
  RiotRsoRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  static Options get _publicOptions => Options(
        extra: {
          AuthRequestExtra.skipAuth: true,
          AuthRequestExtra.skipRefresh: true,
        },
      );

  @override
  Future<RiotRsoSignIn> fetchSignIn({
    bool requestRedirect = false,
    String? loginHint,
    String? uiLocales,
  }) async {
    try {
      final qp = riotRsoSignInQueryParameters(
        requestRedirect: requestRedirect,
        loginHint: loginHint,
        uiLocales: uiLocales,
      );
      final res = await _api.get<dynamic>(
        '/riot/rso/sign-in',
        queryParameters: qp.isEmpty ? null : qp,
        options: _publicOptions,
      );
      final data = res.data;
      if (data is! Map) {
        throw const ServerException('Respuesta inválida de sign-in RSO');
      }
      final map = Map<String, dynamic>.from(data);
      final authorizeUrl = map['authorizeUrl'] as String?;
      final state = map['state'] as String?;
      if (authorizeUrl == null ||
          authorizeUrl.isEmpty ||
          state == null ||
          state.isEmpty) {
        throw const ServerException('authorizeUrl o state faltante (RSO)');
      }
      return RiotRsoSignIn(authorizeUrl: authorizeUrl, state: state);
    } on DioException catch (e) {
      throw ServerException(_message(e));
    }
  }

  @override
  Future<RiotRsoTokenBundle> fetchOAuthCallback({
    required String code,
    required String state,
    bool includeUserinfo = false,
  }) async {
    try {
      final qp = <String, dynamic>{
        'code': code,
        'state': state,
      };
      if (includeUserinfo) qp['includeUserinfo'] = 'true';
      final res = await _api.get<dynamic>(
        '/riot/rso/oauth2-callback',
        queryParameters: qp,
        options: _publicOptions,
      );
      return _parseTokenBundle(res.data);
    } on DioException catch (e) {
      throw ServerException(_message(e));
    }
  }

  @override
  Future<RiotRsoTokenBundle> postRefresh({
    required String refreshToken,
    String? scope,
  }) async {
    try {
      final body = <String, dynamic>{'refreshToken': refreshToken};
      if (scope != null && scope.isNotEmpty) body['scope'] = scope;
      final res = await _api.post<dynamic>(
        '/riot/rso/refresh',
        data: body,
        options: _publicOptions,
      );
      return _parseTokenBundle(res.data);
    } on DioException catch (e) {
      throw ServerException(_message(e));
    }
  }

  @override
  Future<RiotRsoUserinfo> postUserinfo({required String accessToken}) async {
    try {
      final res = await _api.post<dynamic>(
        '/riot/rso/userinfo',
        data: {'accessToken': accessToken},
        options: _publicOptions,
      );
      final data = res.data;
      if (data is! Map) {
        throw const ServerException('Respuesta inválida de userinfo RSO');
      }
      final map = Map<String, dynamic>.from(data);
      final sub = map['sub'] as String?;
      if (sub == null || sub.isEmpty) {
        throw const ServerException('sub faltante en userinfo RSO');
      }
      final cpid = map['cpid'] as String?;
      return RiotRsoUserinfo(sub: sub, cpid: cpid);
    } on DioException catch (e) {
      throw ServerException(_message(e));
    }
  }

  RiotRsoTokenBundle _parseTokenBundle(dynamic data) {
    if (data is! Map) {
      throw const ServerException('Respuesta inválida de tokens RSO');
    }
    final map = Map<String, dynamic>.from(data);
    Map<String, dynamic>? claims;
    final rawClaims = map['id_token_claims'] ?? map['idTokenClaims'];
    if (rawClaims is Map) {
      claims = Map<String, dynamic>.from(rawClaims);
    }
    Map<String, dynamic>? userinfo;
    final rawUser = map['userinfo'];
    if (rawUser is Map) {
      userinfo = Map<String, dynamic>.from(rawUser);
    }
    final expires = map['expires_in'] ?? map['expiresIn'];
    return RiotRsoTokenBundle(
      scope: map['scope'] as String?,
      expiresIn: expires is int ? expires : int.tryParse('$expires'),
      tokenType: map['token_type'] as String? ?? map['tokenType'] as String?,
      subSid: map['sub_sid'] as String? ?? map['subSid'] as String?,
      accessToken: map['access_token'] as String? ?? map['accessToken'] as String?,
      idToken: map['id_token'] as String? ?? map['idToken'] as String?,
      refreshToken:
          map['refresh_token'] as String? ?? map['refreshToken'] as String?,
      idTokenClaims: claims,
      userinfo: userinfo,
      raw: map,
    );
  }

  String _message(DioException e) {
    final status = e.response?.statusCode;
    final d = e.response?.data;

    if (d is String && d.trim().startsWith('{')) {
      try {
        final decoded = jsonDecode(d);
        if (decoded is Map) {
          return _messageFromBody(Map<String, dynamic>.from(decoded), status);
        }
      } catch (_) {
        /* cae abajo */
      }
    }
    if (d is Map) {
      return _messageFromBody(Map<String, dynamic>.from(d), status);
    }

    final raw = e.message ?? '';
    if (e.type == DioExceptionType.connectionError ||
        raw.contains('XMLHttpRequest')) {
      return 'No se pudo conectar con el servidor. En el navegador suele ser '
          'CORS, la URL del API (WPGG_BASE_URL) o contenido mixto (HTTPS vs HTTP). '
          'Si usás credenciales, el origen del front debe estar en ALLOWED_ORIGINS del back.';
    }
    return raw.isNotEmpty ? raw : 'Error de red';
  }

  String _messageFromBody(Map<String, dynamic> d, int? status) {
    final err = d['error'];
    final desc = d['error_description'] ?? d['errorDescription'];
    if (err is String && err.isNotEmpty) {
      if (desc is String && desc.isNotEmpty) return '$err: $desc';
      return err;
    }

    final msg = d['message'];
    if (msg is String && msg.isNotEmpty) return msg;
    if (msg is List) {
      final parts = msg.whereType<String>().where((s) => s.isNotEmpty).toList();
      if (parts.isNotEmpty) return parts.join('; ');
    }

    if (status == 503) {
      return 'Riot Sign On no está configurado en el servidor. '
          'En el backend definí RIOT_RSO_CLIENT_ID y RIOT_RSO_REDIRECT_URI '
          '(y el resto de secretos RSO que use tu deploy).';
    }
    if (status != null) {
      return 'Error del servidor (HTTP $status).';
    }
    return 'Error de red';
  }
}
