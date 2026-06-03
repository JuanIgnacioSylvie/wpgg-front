import '../auth_flow_mode.dart';
import 'auth_flow_page.dart';

/// Alias de ruta `/auth/riot-no-account`.
class RiotRsoNoAccountPage extends AuthFlowPage {
  const RiotRsoNoAccountPage({super.key, super.riotLinkPendingCode})
      : super(initialMode: AuthFlowMode.riotNoAccount);
}
