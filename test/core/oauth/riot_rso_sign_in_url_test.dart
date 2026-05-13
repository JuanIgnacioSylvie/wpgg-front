import 'package:flutter_test/flutter_test.dart';
import 'package:wpgg_flutter/core/oauth/riot_rso_sign_in_url.dart';

void main() {
  test('buildRiotRsoSignInAbsoluteUrl strips trailing slash and adds query', () {
    expect(
      buildRiotRsoSignInAbsoluteUrl(
        'https://api.example/',
        requestRedirect: true,
        loginHint: 'x',
      ),
      'https://api.example/riot/rso/sign-in?redirect=true&loginHint=x',
    );
  });
}
