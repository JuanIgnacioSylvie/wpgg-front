import 'package:flutter_test/flutter_test.dart';

import 'package:wpgg_flutter/core/oauth/riot_rso_fragment_parser.dart';

void main() {
  test('parse query-style fragment', () {
    final r = parseRiotRsoFragment(
      'access_token=at&token_type=Bearer&expires_in=3600&scope=s&id_token=id&refresh_token=rt',
    );
    expect(r.hasOAuthError, false);
    expect(r.tokens?.accessToken, 'at');
    expect(r.tokens?.idToken, 'id');
    expect(r.tokens?.refreshToken, 'rt');
    expect(r.tokens?.tokenType, 'Bearer');
    expect(r.tokens?.expiresIn, 3600);
    expect(r.tokens?.scope, 's');
  });

  test('parse JSON fragment', () {
    final r = parseRiotRsoFragment(
      '{"access_token":"a","refresh_token":"r","token_type":"Bearer","expires_in":60}',
    );
    expect(r.tokens?.accessToken, 'a');
    expect(r.tokens?.refreshToken, 'r');
  });

  test('oauth error in fragment', () {
    final r = parseRiotRsoFragment('error=access_denied&error_description=no');
    expect(r.hasOAuthError, true);
    expect(r.oauthError, 'access_denied');
    expect(r.oauthErrorDescription, 'no');
  });

  test('empty fragment', () {
    final r = parseRiotRsoFragment('');
    expect(r.tokens, isNull);
    expect(r.hasOAuthError, false);
  });
}
