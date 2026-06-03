import '../auth_flow_mode.dart';
import 'auth_flow_page.dart';

/// Alias de ruta `/login`.
class LoginPage extends AuthFlowPage {
  const LoginPage({super.key})
      : super(initialMode: AuthFlowMode.login);
}
