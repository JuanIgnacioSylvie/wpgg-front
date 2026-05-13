import 'navigate_browser_stub.dart'
    if (dart.library.html) 'navigate_browser_web.dart' as impl;

void navigateBrowserTo(String url) => impl.navigateBrowserTo(url);
