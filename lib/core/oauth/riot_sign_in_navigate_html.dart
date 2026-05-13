// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

/// Navegación documento real (no XHR). `package:web` no la usamos acá: en dart2js
/// conviene `dart:html` para forzar el mismo comportamiento que un link normal.
Future<void> openRiotRsoSignInUrl(String url) async {
  html.window.location.href = url;
}
