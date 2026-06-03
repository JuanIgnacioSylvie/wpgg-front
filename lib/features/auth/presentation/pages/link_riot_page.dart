import '../auth_flow_mode.dart';
import 'auth_flow_page.dart';

/// Alias de ruta `/auth/link-riot`.
class LinkRiotPage extends AuthFlowPage {
  const LinkRiotPage({super.key})
      : super(initialMode: AuthFlowMode.linkRiot);
}
