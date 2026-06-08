import 'riot_rso_mobile_auth_result.dart';
import 'riot_rso_mobile_auth_stub.dart'
    if (dart.library.io) 'riot_rso_mobile_auth_io.dart' as impl;

export 'riot_rso_mobile_auth_result.dart';

Future<RiotRsoMobileAuthResult> authenticateRiotRsoMobile(String signInUrl) =>
    impl.authenticateRiotRsoMobile(signInUrl);
