import 'dart:js_interop';

import 'package:web/web.dart' as web;

const _origin = 'https://wpgg.lol';

const _privatePrefixes = [
  '/home',
  '/missions',
  '/finance',
  '/store',
  '/leaderboard',
  '/settings',
  '/auth',
  '/splash',
  '/forgot-password',
  '/reset-password',
  '/users',
];

class _RouteSeo {
  const _RouteSeo({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

const _defaultSeo = _RouteSeo(
  title: 'WPGG — Misiones diarias de LoL, tokens transparentes y recompensas reales',
  description:
      'Jugá League of Legends, completá misiones diarias y ganá WPGG. '
      'Canjeá por RP, retirá a tu wallet o usalos como quieras. '
      'Pool fijo, contrato verificable on-chain. Sin promesas mágicas.',
);

const _routeSeo = <String, _RouteSeo>{
  '/login': _RouteSeo(
    title: 'Iniciar sesión — WPGG',
    description:
        'Ingresá a WPGG para completar misiones diarias de League of Legends y ganar tokens WPGG.',
  ),
  '/register': _RouteSeo(
    title: 'Crear cuenta — WPGG',
    description:
        'Registrate en WPGG gratis. Completá misiones de LoL, ganá tokens y canjealos por RP o retiralos.',
  ),
  '/faqs': _RouteSeo(
    title: 'Preguntas frecuentes — WPGG',
    description:
        'Respuestas sobre misiones, tokens WPGG, retiros, canje de RP y cómo funciona la plataforma.',
  ),
  '/terms': _RouteSeo(
    title: 'Términos y condiciones — WPGG',
    description:
        'Términos de uso de WPGG, la plataforma de misiones diarias de League of Legends.',
  ),
};

@JS('wpggApplySeo')
external void _wpggApplySeo(JSString path);

String _normalizePath(String path) {
  if (path.isEmpty || path == '/') return '/';
  return path.replaceAll(RegExp(r'/+$'), '');
}

bool _isPrivatePath(String path) {
  for (final prefix in _privatePrefixes) {
    if (path == prefix || path.startsWith('$prefix/')) return true;
  }
  return false;
}

void _setMeta(String name, String content) {
  final existing = web.document.querySelector('meta[name="$name"]');
  if (existing != null) {
    existing.setAttribute('content', content);
    return;
  }
  final meta = web.document.createElement('meta') as web.HTMLMetaElement;
  meta.name = name;
  meta.content = content;
  web.document.head?.appendChild(meta);
}

void _setProperty(String property, String content) {
  final existing = web.document.querySelector('meta[property="$property"]');
  if (existing != null) {
    existing.setAttribute('content', content);
  }
}

void _setCanonical(String href) {
  final existing = web.document.querySelector('link[rel="canonical"]');
  if (existing != null) {
    existing.setAttribute('href', href);
  }
}

void updateWebSeoForRoute(String path) {
  try {
    _wpggApplySeo(path.toJS);
    return;
  } catch (_) {
    // Fallback when index.html bootstrap is unavailable (local dev).
  }

  final normalized = _normalizePath(path);
  final seo = _routeSeo[normalized] ?? _defaultSeo;
  final canonical = '$_origin${normalized == '/' ? '/' : normalized}';
  final robots = _isPrivatePath(normalized)
      ? 'noindex, nofollow'
      : 'index, follow, max-image-preview:large';

  web.document.title = seo.title;
  _setMeta('description', seo.description);
  _setMeta('robots', robots);
  _setCanonical(canonical);
  _setProperty('og:url', canonical);
  _setProperty('og:title', seo.title);
  _setProperty('og:description', seo.description);
  _setMeta('twitter:title', seo.title);
  _setMeta('twitter:description', seo.description);
}
