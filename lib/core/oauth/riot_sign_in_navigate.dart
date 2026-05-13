import 'riot_sign_in_navigate_stub.dart'
    if (dart.library.io) 'riot_sign_in_navigate_io.dart'
    if (dart.library.html) 'riot_sign_in_navigate_html.dart'
    if (dart.library.js_interop) 'riot_sign_in_navigate_web.dart'
    as impl;

Future<void> openRiotRsoSignInUrl(String url) => impl.openRiotRsoSignInUrl(url);
