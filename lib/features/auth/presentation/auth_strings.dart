/// Textos del flujo auth (español, según mockups).
abstract final class AuthStrings {
  static const String loginSwitchLine = 'Si no tenés una cuenta';
  static const String loginSwitchLink = 'Registrate acá !';

  static const String registerSwitchLine = 'Si ya tenés una cuenta';
  static const String registerSwitchLink = 'Iniciá sesión acá !';

  static const String riotNotFoundTitle = 'Cuenta no encontrada.';
  static const String riotNotFoundBody =
      'No encontramos una cuenta de WPGG vinculada a ese Riot ID. '
      'Registrate primero en WPGG.';
  static const String riotNotFoundRegister = 'Registrate';
  static const String riotNotFoundCancel = 'Cancelar';

  static const String riotAlreadyExistsTitle = 'Ya tenés una cuenta.';
  static const String riotAlreadyExistsBody =
      'Ya existe una cuenta de WPGG vinculada a este Riot ID. '
      'Iniciá sesión con Riot o con tu email.';
  static const String riotAlreadyExistsSignInRiot = 'Iniciar sesión con Riot';
  static const String riotAlreadyExistsCancel = 'Cancelar';

  static const String linkRiotBody =
      'Vinculá tu cuenta de Riot Games para completar tu registro.';

  static const String labelEmail = 'Email';
  static const String hintEmail = 'Ingresá tu correo electrónico';
  static const String labelPassword = 'Contraseña';
  static const String hintPassword = 'Ingresá tu contraseña';
  static const String labelConfirmPassword = 'Confirmar contraseña';
  static const String hintConfirmPassword = 'Confirmá tu contraseña';

  static const String rememberMe = 'Recordarme';
  static const String forgotPassword = '¿Olvidaste tu contraseña?';

  static const String buttonLogin = 'Iniciar sesión';
  static const String buttonRegister = 'Registrate';

  static const String riotFooter = 'o continuá con';

  static const String passwordsMismatch = 'Las contraseñas no coinciden';

  static const String forgotPasswordTitle = '¿Olvidaste tu contraseña?';
  static const String forgotPasswordBody =
      'Ingresá tu email y te enviaremos un enlace para restablecer tu contraseña.';
  static const String forgotPasswordSuccess =
      'Si existe una cuenta con ese email, te enviamos un enlace para restablecer tu contraseña.';
  static const String buttonSendResetLink = 'Enviar enlace';
  static const String backToLogin = 'Volver al inicio de sesión';

  static const String resetPasswordTitle = 'Nueva contraseña';
  static const String resetPasswordBody =
      'Elegí una contraseña nueva para tu cuenta.';
  static const String buttonResetPassword = 'Restablecer contraseña';
  static const String resetPasswordSuccess =
      'Tu contraseña fue actualizada. Ya podés iniciar sesión.';
  static const String resetPasswordInvalidLink =
      'El enlace no es válido o expiró. Pedí uno nuevo desde el inicio de sesión.';

  static const String verifyEmailTitle = 'Confirmá tu email';
  static const String verifyEmailBody =
      'Te enviamos un enlace a tu correo. Abrilo para activar tu cuenta.';
  static const String verifyEmailResent =
      'Si la cuenta existe y no está verificada, reenviamos el enlace.';
  static const String verifyEmailSuccess =
      'Tu email fue confirmado. ¡Bienvenido a WPGG!';
  static const String verifyEmailInvalidLink =
      'El enlace no es válido o expiró. Pedí uno nuevo desde el registro.';
  static const String buttonResendVerification = 'Reenviar enlace';
  static const String turnstileRequired =
      'Completá la verificación de seguridad antes de continuar.';
}
