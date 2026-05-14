import 'oauth_callback_fragment_capture_stub.dart'
    if (dart.library.html) 'oauth_callback_fragment_capture_html.dart' as impl;

void captureOauthCallbackFragmentAtAppStart() =>
    impl.captureOauthCallbackFragmentAtAppStart();

String? get capturedOauthCallbackFragment => impl.capturedOauthCallbackFragment;

void clearCapturedOauthCallbackFragment() =>
    impl.clearCapturedOauthCallbackFragment();
