import '../auth_flow_mode.dart';
import 'auth_flow_page.dart';

/// Alias de ruta `/register`.
class RegisterPage extends AuthFlowPage {
  const RegisterPage({super.key})
      : super(initialMode: AuthFlowMode.register);
}
