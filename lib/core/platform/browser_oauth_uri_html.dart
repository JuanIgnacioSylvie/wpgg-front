// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'oauth_callback_fragment_capture.dart';

/// URL del documento para OAuth: [PathUrlStrategy] puede borrar el `#` al sincronizar historial;
/// si el fragmento ya vació, se usa el respaldo capturado en [captureOauthCallbackFragmentAtAppStart].
Uri browserOAuthLocationUri() {
  final href = html.window.location.href;
  var u = Uri.parse(href);
  if (u.fragment.isEmpty) {
    final held = capturedOauthCallbackFragment;
    if (held != null && held.isNotEmpty) {
      u = u.replace(fragment: held);
    }
  }
  return u;
}
