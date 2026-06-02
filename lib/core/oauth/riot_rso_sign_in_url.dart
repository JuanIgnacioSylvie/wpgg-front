/// Armado de URLs de Riot Sign On.
///
/// En **web**, el flujo debe usar [buildRiotRsoSignInAbsoluteUrl] /
/// [buildRiotRsoSignUpAbsoluteUrl] y navegación de documento (`window.location`),
/// no `fetch`/XHR, para que un **302** del API hacia Riot `/authorize` lo siga
/// el navegador sin CORS.
library;

/// Incluye los mismos parámetros que [RiotRsoRemoteDataSourceImpl.fetchSignIn].
Map<String, dynamic> riotRsoSignInQueryParameters({
  bool requestRedirect = false,
  String? loginHint,
  String? uiLocales,
}) {
  final qp = <String, dynamic>{};
  if (requestRedirect) qp['redirect'] = 'true';
  if (loginHint != null && loginHint.isNotEmpty) {
    qp['loginHint'] = loginHint;
  }
  if (uiLocales != null && uiLocales.isNotEmpty) {
    qp['uiLocales'] = uiLocales;
  }
  return qp;
}

String _buildRiotRsoAbsoluteUrl(
  String apiBaseUrl,
  String path, {
  bool requestRedirect = false,
  String? loginHint,
  String? uiLocales,
}) {
  final qp = riotRsoSignInQueryParameters(
    requestRedirect: requestRedirect,
    loginHint: loginHint,
    uiLocales: uiLocales,
  );
  final base = apiBaseUrl.trim().replaceAll(RegExp(r'/+$'), '');
  return Uri.parse('$base$path')
      .replace(
        queryParameters: qp.isEmpty
            ? null
            : qp.map((k, v) => MapEntry(k, '$v')),
      )
      .toString();
}

/// URL absoluta del sign-in RSO (navegación documento; el navegador sigue 302 a Riot).
String buildRiotRsoSignInAbsoluteUrl(
  String apiBaseUrl, {
  bool requestRedirect = false,
  String? loginHint,
  String? uiLocales,
}) =>
    _buildRiotRsoAbsoluteUrl(
      apiBaseUrl,
      '/riot/rso/sign-in',
      requestRedirect: requestRedirect,
      loginHint: loginHint,
      uiLocales: uiLocales,
    );

/// URL absoluta del sign-up RSO (`intent=register` en el state OAuth del back).
String buildRiotRsoSignUpAbsoluteUrl(
  String apiBaseUrl, {
  bool requestRedirect = false,
  String? loginHint,
  String? uiLocales,
}) =>
    _buildRiotRsoAbsoluteUrl(
      apiBaseUrl,
      '/riot/rso/sign-up',
      requestRedirect: requestRedirect,
      loginHint: loginHint,
      uiLocales: uiLocales,
    );
