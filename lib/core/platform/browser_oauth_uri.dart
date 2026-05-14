import 'browser_oauth_uri_stub.dart'
    if (dart.library.html) 'browser_oauth_uri_html.dart' as impl;

/// En web, preferir esto sobre [Uri.base] para OAuth en el fragmento (`#access_token=…`).
Uri browserOAuthLocationUri() => impl.browserOAuthLocationUri();
