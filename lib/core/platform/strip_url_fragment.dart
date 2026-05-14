import 'strip_url_fragment_stub.dart'
    if (dart.library.html) 'strip_url_fragment_web.dart' as impl;

void stripUrlFragment() => impl.stripUrlFragment();

void stripOAuthReturnUrl() => impl.stripOAuthReturnUrl();
