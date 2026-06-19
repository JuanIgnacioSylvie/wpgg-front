import 'package:web/web.dart' as web;

/// True for search/social crawlers and audit tools (Lighthouse, PageSpeed).
bool isWebCrawler() {
  final ua = web.window.navigator.userAgent.toLowerCase();
  const bots = [
    'googlebot',
    'google-inspectiontool',
    'bingbot',
    'slurp',
    'duckduckbot',
    'baiduspider',
    'yandexbot',
    'facebookexternalhit',
    'twitterbot',
    'linkedinbot',
    'lighthouse',
    'pagespeed',
    'chrome-lighthouse',
    'headlesschrome',
  ];
  for (final bot in bots) {
    if (ua.contains(bot)) return true;
  }
  return false;
}
