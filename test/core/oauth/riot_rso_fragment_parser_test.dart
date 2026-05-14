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

  test('parseRiotRsoCallbackUri prefers fragment when query has no error', () {
    final u = Uri.parse(
      'https://example.com/callback?access_token=query&refresh_token=r2'
      '#access_token=frag&refresh_token=r1',
    );
    final r = parseRiotRsoCallbackUri(u);
    expect(r.tokens?.accessToken, 'frag');
    expect(r.tokens?.refreshToken, 'r1');
    expect(r.sessionFromCookiesOnly, false);
  });

  test('parseRiotRsoCallbackUri query error takes precedence over fragment', () {
    final u = Uri.parse(
      'https://example.com/callback?error=rso_no_subject&error_description=sub'
      '#access_token=frag&refresh_token=r1',
    );
    final r = parseRiotRsoCallbackUri(u);
    expect(r.hasOAuthError, true);
    expect(r.oauthError, 'rso_no_subject');
    expect(r.oauthErrorDescription, 'sub');
    expect(r.tokens, isNull);
  });

  test('parseRiotRsoCallbackUri riot_session code', () {
    final u = Uri.parse(
      'https://example.com/auth/riot-callback?riot_session=abc123',
    );
    final r = parseRiotRsoCallbackUri(u);
    expect(r.hasRiotSessionCode, true);
    expect(r.riotSessionCode, 'abc123');
    expect(r.sessionFromCookiesOnly, false);
    expect(r.tokens, isNull);
  });

  test('parseRiotRsoCallbackUri error beats riot_session', () {
    final u = Uri.parse(
      'https://example.com/c?error=denied&riot_session=x',
    );
    final r = parseRiotRsoCallbackUri(u);
    expect(r.hasOAuthError, true);
    expect(r.hasRiotSessionCode, false);
  });

  test('parseRiotRsoCallbackUri cookie session when fragment empty', () {
    final u = Uri.parse(
      'https://example.com/callback?access_token=q&refresh_token=rq',
    );
    final r = parseRiotRsoCallbackUri(u);
    expect(r.tokens, isNull);
    expect(r.hasOAuthError, false);
    expect(r.sessionFromCookiesOnly, true);
  });

  test('parseRiotRsoCallbackUri clean URL is cookie session', () {
    final u = Uri.parse('https://example.com/auth/riot-callback');
    final r = parseRiotRsoCallbackUri(u);
    expect(r.sessionFromCookiesOnly, true);
    expect(r.hasOAuthError, false);
    expect(r.tokens, isNull);
  });
}
