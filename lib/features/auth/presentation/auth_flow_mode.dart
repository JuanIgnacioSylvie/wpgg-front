/// Estados del flujo de autenticación (login y registro en card compartida).
enum AuthFlowMode {
  login,
  register,
}

AuthFlowMode authFlowModeFromPath(String path) {
  if (path.contains('register')) {
    return AuthFlowMode.register;
  }
  return AuthFlowMode.login;
}
