import 'dart:js_interop';

import 'package:go_router/go_router.dart';

import '../presentation/web/web_seo.dart';

@JS('wpggNotifyRouteChange')
external void _wpggNotifyRouteChange(JSString path);

void initVercelAnalytics(GoRouter router) {
  void onRouteChange() {
    final path = router.routeInformationProvider.value.uri.path;
    updateWebSeoForRoute(path);
    _notify(path);
  }

  router.routeInformationProvider.addListener(onRouteChange);
  onRouteChange();
}

void _notify(String path) {
  try {
    _wpggNotifyRouteChange(path.toJS);
  } catch (_) {
    // Analytics script only exists on Vercel deployments with Web Analytics enabled.
  }
}
