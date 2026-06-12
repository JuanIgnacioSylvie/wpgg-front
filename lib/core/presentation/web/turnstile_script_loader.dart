import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

@JS('turnstile')
external JSObject? get _turnstileGlobal;

const _turnstileScriptUrl =
    'https://challenges.cloudflare.com/turnstile/v0/api.js';

Future<void>? _loadFuture;

/// Loads Cloudflare Turnstile only when a captcha widget is shown (not on every page).
Future<void> ensureTurnstileScriptLoaded() {
  return _loadFuture ??= _loadImpl();
}

Future<void> _loadImpl() async {
  if (_turnstileGlobal != null) {
    return;
  }

  final existing = web.document.querySelector(
    'script[data-wpgg-turnstile="1"]',
  );
  if (existing == null) {
    final completer = Completer<void>();
    final script = web.HTMLScriptElement();
    script.src = _turnstileScriptUrl;
    script.async = true;
    script.defer = true;
    script.setAttribute('data-wpgg-turnstile', '1');
    script.onload = ((web.Event _) => completer.complete()).toJS;
    script.onerror = ((web.Event _) {
      if (!completer.isCompleted) {
        completer.completeError(StateError('Turnstile script failed to load'));
      }
    }).toJS;
    web.document.head?.appendChild(script);
    await completer.future;
  }

  for (var i = 0; i < 50; i++) {
    if (_turnstileGlobal != null) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 80));
  }
}
