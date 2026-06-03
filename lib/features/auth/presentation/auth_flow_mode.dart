/// Estados del flujo de autenticación (misma pantalla, distinto contenido).
enum AuthFlowMode {
  login,
  register,
  riotNoAccount,
  linkRiot,
}

AuthFlowMode authFlowModeFromPath(String path) {
  if (path.contains('riot-no-account')) {
    return AuthFlowMode.riotNoAccount;
  }
  if (path.contains('link-riot')) {
    return AuthFlowMode.linkRiot;
  }
  if (path.contains('register')) {
    return AuthFlowMode.register;
  }
  return AuthFlowMode.login;
}
