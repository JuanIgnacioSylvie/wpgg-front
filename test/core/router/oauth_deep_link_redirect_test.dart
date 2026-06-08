import 'package:flutter_test/flutter_test.dart';
import 'package:wpgg_flutter/core/router/oauth_deep_link_redirect.dart';

void main() {
  test('normalizeOAuthDeepLinkLocation maps wpgg deep link to app path', () {
    expect(
      normalizeOAuthDeepLinkLocation(
        'wpgg://auth/riot-callback?riot_session=abc',
      ),
      '/auth/riot-callback?riot_session=abc',
    );
  });

  test('normalizeOAuthDeepLinkLocation ignores non-wpgg locations', () {
    expect(
      normalizeOAuthDeepLinkLocation('/login'),
      isNull,
    );
  });
}
