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

  test('buildRiotRsoSignUpAbsoluteUrl uses sign-up path', () {
    expect(
      buildRiotRsoSignUpAbsoluteUrl(
        'https://api.example/',
        requestRedirect: true,
      ),
      'https://api.example/riot/rso/sign-up?redirect=true',
    );
  });

  test('buildRiotRsoSignInAbsoluteUrl adds platform=mobile', () {
    expect(
      buildRiotRsoSignInAbsoluteUrl(
        'https://api.example',
        requestRedirect: true,
        mobilePlatform: true,
      ),
      'https://api.example/riot/rso/sign-in?redirect=true&platform=mobile',
    );
  });
}
