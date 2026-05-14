// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

void stripUrlFragment() {
  final loc = html.window.location;
  html.window.history.replaceState(null, '', '${loc.pathname}${loc.search}');
}

/// Tras procesar el redirect OAuth: quita `?query` y `#fragment` del historial.
void stripOAuthReturnUrl() {
  final loc = html.window.location;
  html.window.history.replaceState(null, '', loc.pathname);
}
