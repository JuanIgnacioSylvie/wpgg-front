// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get hello => '¡Hola!';

  @override
  String get profile => 'Perfil';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get language => 'Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Francés';

  @override
  String get languagePortuguese => 'Portugués';

  @override
  String get retry => 'Reintentar';

  @override
  String get welcomeMissionBadge => 'MISIÓN DE REGALO';

  @override
  String get welcomeMissionSection => 'Misión de regalo';

  @override
  String get inProgress => 'En progreso';

  @override
  String missionDayResets(String date, String timezone) {
    return 'Día de misión $date · reinicia 00:00 $timezone';
  }

  @override
  String dayEndsIn(String time) {
    return 'Día termina en: $time';
  }

  @override
  String get noActiveMissions =>
      'No tenés misiones activas. ¡Elegí hasta 3 para hoy!';

  @override
  String get pickMissions => 'Elegir misiones';

  @override
  String get passMissions => 'Misiones pasadas';

  @override
  String get completedMissionsPlaceholder =>
      'Las misiones completadas aparecerán acá.';

  @override
  String get noMissionsForDay => 'No hay misiones para este día.';

  @override
  String get noMissionsForFilter => 'Ninguna misión coincide con este filtro.';

  @override
  String get errorLoadingMissions => 'Error al cargar misiones';

  @override
  String get missionsByDays => 'Misiones por día';

  @override
  String get errorGeneric => 'Error';

  @override
  String get filterAll => 'Todas';

  @override
  String get filterToDo => 'Por hacer';

  @override
  String get filterInProgress => 'En progreso';

  @override
  String get filterCompleted => 'Completadas';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Media';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get statusCompleted => 'Completada';

  @override
  String get statusIncomplete => 'Incompleta';

  @override
  String get statusInProgress => 'En progreso';

  @override
  String get statusToDo => 'Por hacer';

  @override
  String endsIn(String time) {
    return 'Termina en: $time';
  }

  @override
  String get pickMissionsTitle => 'Elegir misiones';

  @override
  String get errorLoadingOffers => 'Error al cargar ofertas';

  @override
  String selectedMissionsCount(int count, int max, int maxHard) {
    return 'Seleccionadas $count/$max (máx. $maxHard difícil)';
  }

  @override
  String get rerollMissionTitle => '¿Cambiar misión?';

  @override
  String rerollMissionBody(int cost) {
    return 'Esto costará $cost WPGG de tu saldo.';
  }

  @override
  String missionSpendBalanceHint(int balance) {
    return 'Saldo actual: $balance WPGG';
  }

  @override
  String get missionInsufficientBalance =>
      'No tenés suficiente WPGG para esta acción';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reroll => 'Cambiar';

  @override
  String get cancelMissionTitle => '¿Eliminar misión?';

  @override
  String cancelMissionBody(int cost) {
    return 'Esto costará $cost WPGG de tu saldo.';
  }

  @override
  String get deleteMission => 'Eliminar';

  @override
  String get dropToDeleteMission => 'Soltá acá para eliminar';

  @override
  String summonerLevel(int level) {
    return 'Nivel $level';
  }

  @override
  String get linkRiotPrompt =>
      'Vinculá tu cuenta de Riot para ver estadísticas.';

  @override
  String get linkRiotAfterLoginPrompt =>
      'No pudimos vincular tu cuenta de LoL automáticamente. Completá los datos de tu invocador para ver estadísticas.';

  @override
  String get linkRiotButton => 'Vincular cuenta de Riot';

  @override
  String get completeRiotLinkButton => 'Completar vinculación manual';

  @override
  String get linkRiotSheetTitle => 'Vincular Riot';

  @override
  String get linkRiotSheetAction => 'Vincular';

  @override
  String get summonerNameLabel => 'Nombre de invocador';

  @override
  String get tagLabel => 'Tag (#TAG sin #)';

  @override
  String get regionLabel => 'Región (ej. LA2)';

  @override
  String get myProfile => 'Mi perfil';

  @override
  String get withdraw => 'RETIRAR';

  @override
  String get generalNotification => 'Notificación general';

  @override
  String get helpSupport => 'Ayuda y soporte';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsAndConditionsTitle => 'Términos y Condiciones';

  @override
  String get withdrawTitle => 'Retirar WPGG';

  @override
  String withdrawMinHint(int amount) {
    return 'El retiro mínimo es $amount WPGG';
  }

  @override
  String get walletAddressLabel => 'Dirección de wallet Polygon';

  @override
  String get walletAddressRequired => 'La dirección es obligatoria';

  @override
  String get walletAddressInvalid =>
      'Ingresá una dirección Polygon válida (0x...)';

  @override
  String get withdrawAmountLabel => 'Monto (WPGG)';

  @override
  String get withdrawAmountInvalid => 'Ingresá un monto válido';

  @override
  String get withdrawInsufficientBalance => 'Saldo insuficiente';

  @override
  String get withdrawSuccess => 'Retiro enviado correctamente';

  @override
  String get withdrawError =>
      'No se pudo completar el retiro. Intentá de nuevo.';

  @override
  String get pageUnavailableTitle => 'Esta página no está disponible';

  @override
  String get pageUnavailableBody =>
      'Estamos trabajando en ello. Volvé a intentar más tarde.';

  @override
  String get faqsMenuItem => 'Preguntas frecuentes';

  @override
  String get faqsTitle => 'Preguntas frecuentes';

  @override
  String get faqsIntro =>
      'Todo lo que necesitás saber sobre WPGG: misiones, recompensas, retiros y más.';

  @override
  String get faqWhatIsWpggQ => '¿Qué es WPGG?';

  @override
  String get faqWhatIsWpggA =>
      'WPGG es una plataforma de estadísticas de League of Legends que te recompensa por jugar. Completás misiones diarias, acumulás tokens WPGG y podés canjearlos por gift cards de Riot Points u otros premios reales.';

  @override
  String get faqHowMissionsWorkQ => '¿Cómo funcionan las misiones?';

  @override
  String get faqHowMissionsWorkA =>
      'Cada día tenés un set de misiones disponibles: fáciles, medias y difíciles. Las fáciles son cosas simples como jugar una partida o ganar con un campeón específico. Las medias y difíciles implican mejor rendimiento: superar cierto KDA, hacer X cantidad de asistencias, ganar seguidas, etc. Completás la misión, sumás tokens. Así de simple.';

  @override
  String get faqRerollQ => '¿Puedo rerollear misiones?';

  @override
  String get faqRerollA =>
      'Sí. Si una misión no te conviene o no podés completarla, tenés rerolls disponibles por día para cambiarla por otra aleatoria del mismo tier.';

  @override
  String get faqWithdrawQ => '¿Cómo retiro mis WPGG a la wallet?';

  @override
  String get faqWithdrawA =>
      'Para poder retirar necesitás acumular un mínimo de 1.000 WPGG. Una vez que llegás, podés iniciar el retiro desde la sección de finanzas. Los tokens se transfieren a tu wallet en la red de Polygon. Necesitás tener una wallet compatible (como MetaMask) y cubrir el gas fee de la transacción, que en Polygon es prácticamente nada.';

  @override
  String get faqWhatCanIDoQ => '¿Qué puedo hacer con los WPGG?';

  @override
  String get faqWhatCanIDoA =>
      'Por ahora podés canjearlos en la tienda de la app por gift cards de Riot Points. La idea es que con lo que acumulás en semanas de juego normal puedas comprarte una skin, invitarle algo a tu novia o tomarle unas cervezas a los pibes. No es para hacerse millonario — es un premio real por lo que ya hacés.';

  @override
  String get faqTokenPriceQ => '¿Cuánto vale un WPGG en plata?';

  @override
  String get faqTokenPriceA =>
      'El token cotiza en el mercado, así que el precio varía. Pero la app no está pensada para que especules con él: está pensada para que lo uses. El valor real está en el canje por productos concretos.';

  @override
  String get faqGetRichQ => '¿WPGG me va a hacer rico?';

  @override
  String get faqGetRichA =>
      'No. Y lo decimos sin rodeos porque la transparencia es parte del proyecto. WPGG no es un esquema de inversión ni un juego de especulación. Es un sistema de recompensas respaldado por un pool de liquidez fijo en QuickSwap (WPGG/USDC). El pool es lo que es — no crece mágicamente, no hay promesas de retornos. Lo que ganás jugando tiene un valor real y canjeable, pero no esperés multiplicar plata acá.';

  @override
  String get faqTransparencyQ => '¿Es seguro? ¿El proyecto es transparente?';

  @override
  String get faqTransparencyA =>
      'Sí. El contrato del token WPGG está deployado en Polygon Mainnet y es verificable públicamente en PolygonScan. El pool de liquidez está en QuickSwap. Todo lo que respalda el sistema está on-chain y cualquiera puede auditarlo. No hay caja negra.';

  @override
  String get faqCryptoKnowledgeQ =>
      '¿Necesito saber de cripto para usar la app?';

  @override
  String get faqCryptoKnowledgeA =>
      'Para jugar misiones y acumular WPGG, no necesitás saber nada de cripto. La complejidad aparece recién cuando querés retirar a tu wallet — y aun así el proceso está guiado paso a paso dentro de la app.';

  @override
  String get faqLoLAccountQ => '¿Con qué cuenta de LoL me conecto?';

  @override
  String get faqLoLAccountA =>
      'La app usa Riot Sign On (el sistema oficial de Riot Games), así que iniciás sesión con tu cuenta de Riot directamente. No necesitás darnos tu contraseña ni nada por el estilo — es el mismo OAuth que usan apps como op.gg o u.gg.';

  @override
  String get faqAvailabilityQ => '¿La app está disponible para iOS y Android?';

  @override
  String get faqAvailabilityA =>
      'Actualmente está en desarrollo activo. Más info sobre disponibilidad próximamente.';

  @override
  String get storeTitle => 'Tienda';

  @override
  String get storeSubtitle => 'Canjeá tus WPGG por gift cards de Riot.';

  @override
  String get storeBuy => 'Comprar';

  @override
  String get storePurchaseTitle => 'Confirmar compra';

  @override
  String storePurchaseBody(int cost, String product) {
    return 'Vas a gastar $cost WPGG por $product.';
  }

  @override
  String get storeComingSoon => 'Las compras estarán disponibles muy pronto.';

  @override
  String get storeOrderHistory => 'Tus compras';

  @override
  String get storeNoOrders => 'Todavía no compraste nada en la tienda.';

  @override
  String get storePurchaseSuccessTitle => '¡Compra exitosa!';

  @override
  String storePurchaseSuccessBody(int rp) {
    return 'Tu gift card de $rp RP ya está lista. Guardá la key en un lugar seguro.';
  }

  @override
  String get storeYourKey => 'Tu Riot Key';

  @override
  String get storeCopyKey => 'Copiar key';

  @override
  String get storeKeyCopied => 'Key copiada al portapapeles';

  @override
  String get storeDone => 'Listo';

  @override
  String get storeOutOfStock => 'No hay stock disponible para este producto.';

  @override
  String get storePurchaseError =>
      'No se pudo completar la compra. Intentá de nuevo.';

  @override
  String get transactionProcessingAcceptMission => 'Aceptando misión…';

  @override
  String get transactionProcessingRerollMission => 'Cambiando misión…';

  @override
  String get transactionProcessingCancelMission => 'Eliminando misión…';

  @override
  String get transactionProcessingPurchase => 'Procesando compra…';

  @override
  String get transactionSuccessAcceptMission => 'Misión aceptada';

  @override
  String get transactionSuccessRerollMission => 'Misión cambiada';

  @override
  String get transactionSuccessCancelMission => 'Misión eliminada';

  @override
  String get transactionFailedGeneric =>
      'No se pudo completar la acción. Intentá de nuevo.';

  @override
  String get viewOnGeckoTerminal => 'Ver en GeckoTerminal';

  @override
  String get authLoginSwitchLine => 'Si no tenés una cuenta';

  @override
  String get authLoginSwitchLink => 'Registrate acá !';

  @override
  String get authRegisterSwitchLine => 'Si ya tenés una cuenta';

  @override
  String get authRegisterSwitchLink => 'Iniciá sesión acá !';

  @override
  String get authSwitchLinkPrefix => 'Podés ';

  @override
  String get riotNotFoundTitle => 'Cuenta no encontrada.';

  @override
  String get riotNotFoundBody =>
      'No encontramos una cuenta de WPGG vinculada a ese Riot ID. Registrate primero en WPGG.';

  @override
  String get riotNotFoundRegister => 'Registrate';

  @override
  String get riotAlreadyExistsTitle => 'Ya tenés una cuenta.';

  @override
  String get riotAlreadyExistsBody =>
      'Ya existe una cuenta de WPGG vinculada a este Riot ID. Iniciá sesión con Riot o con tu email.';

  @override
  String get riotAlreadyExistsSignInRiot => 'Iniciar sesión con Riot';

  @override
  String get linkRiotBody =>
      'Vinculá tu cuenta de Riot Games para completar tu registro.';

  @override
  String get authLabelEmail => 'Email';

  @override
  String get authHintEmail => 'Ingresá tu correo electrónico';

  @override
  String get authLabelPassword => 'Contraseña';

  @override
  String get authHintPassword => 'Ingresá tu contraseña';

  @override
  String get authLabelConfirmPassword => 'Confirmar contraseña';

  @override
  String get authHintConfirmPassword => 'Confirmá tu contraseña';

  @override
  String get authRememberMe => 'Recordarme';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authButtonLogin => 'Iniciar sesión';

  @override
  String get authButtonRegister => 'Registrate';

  @override
  String get authRiotFooter => 'o continuá con';

  @override
  String get authPasswordsMismatch => 'Las contraseñas no coinciden';

  @override
  String get authForgotPasswordBody =>
      'Ingresá tu email y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get authForgotPasswordSuccess =>
      'Si existe una cuenta con ese email, te enviamos un enlace para restablecer tu contraseña.';

  @override
  String get authButtonSendResetLink => 'Enviar enlace';

  @override
  String get authBackToLogin => 'Volver al inicio de sesión';

  @override
  String get authResetPasswordTitle => 'Nueva contraseña';

  @override
  String get authResetPasswordBody =>
      'Elegí una contraseña nueva para tu cuenta.';

  @override
  String get authButtonResetPassword => 'Restablecer contraseña';

  @override
  String get authResetPasswordSuccess =>
      'Tu contraseña fue actualizada. Ya podés iniciar sesión.';

  @override
  String get authResetPasswordInvalidLink =>
      'El enlace no es válido o expiró. Pedí uno nuevo desde el inicio de sesión.';

  @override
  String get authVerifyEmailTitle => 'Confirmá tu email';

  @override
  String get authVerifyEmailBody =>
      'Te enviamos un enlace a tu correo. Abrilo para activar tu cuenta.';

  @override
  String get authVerifyEmailResent =>
      'Si la cuenta existe y no está verificada, reenviamos el enlace.';

  @override
  String get authVerifyEmailSuccess =>
      'Tu email fue confirmado. ¡Bienvenido a WPGG!';

  @override
  String get authVerifyEmailInvalidLink =>
      'El enlace no es válido o expiró. Pedí uno nuevo desde el registro.';

  @override
  String get authButtonResendVerification => 'Reenviar enlace';

  @override
  String get authTurnstileRequired =>
      'Completá la verificación de seguridad antes de continuar.';

  @override
  String get authVerifyEmailConfirming => 'Confirmando tu email…';

  @override
  String get riotLoginCompleted => 'Login Riot completado';

  @override
  String get riotCallbackTitle => 'Riot';

  @override
  String get riotGoToDashboard => 'Ir al panel';

  @override
  String get riotGoToLogin => 'Ir al inicio de sesión';

  @override
  String get riotSessionTokensInUrl =>
      'Sesión iniciada con Riot (tokens en la URL).';

  @override
  String get riotSessionCookies => 'Sesión iniciada con Riot (cookies).';

  @override
  String get riotSessionUpdated =>
      'Cuenta Riot autenticada; sesión de la app actualizada.';

  @override
  String get riotSessionViaExchange => 'Sesión WPGG vía canje Riot.';

  @override
  String get riotIdentityError =>
      'El servidor no pudo obtener tu identidad de Riot. Probá iniciar sesión de nuevo.';

  @override
  String riotIdentityErrorWithDesc(String desc) {
    return 'El servidor no pudo obtener tu identidad de Riot: $desc';
  }

  @override
  String get riotNoSessionAfterLogin =>
      'No se recibió sesión tras el login con Riot.';

  @override
  String get financeTitle => 'Finanzas';

  @override
  String get financeSubtitle => 'Precio del token y movimientos de tu wallet';

  @override
  String get financeYourBalance => 'Tu balance';

  @override
  String get balanceLabel => 'Saldo';

  @override
  String get financeFilterAll => 'Todos';

  @override
  String get financeFilterAllTransactions => 'Todas las transacciones';

  @override
  String get financeFilterIncome => 'Ingresos';

  @override
  String get financeFilterExpense => 'Gastos';

  @override
  String get financePriceHistory => 'Historial de precio (7 días)';

  @override
  String get financeNoChartData => 'Sin datos del gráfico';

  @override
  String get financeNoTransactions => 'Sin movimientos';

  @override
  String get tokenPriceUpdatedHint => 'Precio en USD · actualizado cada 60s';

  @override
  String get navDashboard => 'Panel';

  @override
  String get navNotifications => 'Notificaciones';

  @override
  String get notificationsInboxEmpty => 'Aún no hay notificaciones';

  @override
  String get notificationsMarkAllRead => 'Marcar todas como leídas';

  @override
  String get notificationsDelete => 'Eliminar notificación';

  @override
  String get notificationsClearAll => 'Borrar todas';

  @override
  String get sidebarExpandMenu => 'Expandir menú';

  @override
  String get sidebarCollapse => 'Colapsar';

  @override
  String get addMissionButton => 'Agregar';

  @override
  String matchChampionFallback(int id) {
    return 'Campeón $id';
  }

  @override
  String get matchWin => 'Victoria';

  @override
  String get matchLoss => 'Derrota';

  @override
  String get timeAgoJustNow => 'hace instantes';

  @override
  String timeAgoMinutes(int count) {
    return 'hace $count min';
  }

  @override
  String timeAgoHours(int count) {
    return 'hace $count h';
  }

  @override
  String timeAgoDays(int count) {
    return 'hace $count d';
  }

  @override
  String rankedWinrate(String percent) {
    return 'Winrate $percent%';
  }

  @override
  String get queueRankedSolo => 'Solo/Duo';

  @override
  String get queueRankedFlex => 'Flex 5v5';

  @override
  String get queueRankedTft => 'TFT Clasificatoria';

  @override
  String get queueArena => 'Arena';

  @override
  String get queueAram => 'ARAM';

  @override
  String get queueNormal => 'Normal';

  @override
  String get landingNavMissions => 'Misiones';

  @override
  String get landingNavCoin => 'La Coin';

  @override
  String get landingNavSponsors => 'Sponsors';

  @override
  String get landingNavLogin => 'Iniciar sesión';

  @override
  String get landingNavGetStarted => 'Empezar';

  @override
  String get landingHeroTitle =>
      'Jugá League of Legends.\nGaná WPGG. Canjeá por RP o retirá.';

  @override
  String get landingHeroSubtitle =>
      'WPGG es una plataforma de misiones diarias de LoL con recompensas reales. Sin promesas mágicas, sin caja negra: todo respaldado por un pool fijo y verificable on-chain.';

  @override
  String get landingCtaCreateAccount => 'Crear cuenta gratis';

  @override
  String get landingCtaHowItWorks => 'Cómo funciona';

  @override
  String get landingWhatTitle => '¿Qué es WPGG?';

  @override
  String landingWhatSubtitle(String tagline) {
    return '$tagline — estadísticas de LoL que te pagan por jugar.';
  }

  @override
  String get landingWhatBody =>
      'Completás misiones diarias basadas en tu actividad en partidas ranked, acumulás tokens WPGG y los usás en la tienda para gift cards de Riot Points o los retirás a tu wallet. Es un sistema de recompensas pensado para jugadores, no para especuladores.';

  @override
  String get landingWhatBullet1 => 'Vinculás tu cuenta de Riot de forma segura';

  @override
  String get landingWhatBullet2 =>
      'Elegís misiones fáciles, medias o difíciles cada día';

  @override
  String get landingWhatBullet3 =>
      'Sumás WPGG al completarlas — sin trucos, sin letra chica escondida';

  @override
  String get landingMissionsTitle => 'Misiones diarias';

  @override
  String get landingMissionsSubtitle =>
      'Jugá como siempre. Sumá recompensas de verdad.';

  @override
  String get landingMissionsBody =>
      'Cada día tenés un set de misiones: desde cosas simples como jugar una partida, hasta desafíos de rendimiento como superar un KDA o encadenar victorias. Elegís las que te cierran, las completás en ranked y cobrás.';

  @override
  String get landingMissionsBullet1 =>
      'Fáciles, medias y difíciles — vos elegís el riesgo';

  @override
  String get landingMissionsBullet2 =>
      'Podés rerollear misiones que no te gusten (con costo en WPGG)';

  @override
  String get landingMissionsBullet3 =>
      'Las recompensas varían según dificultad — sin inflación infinita';

  @override
  String get landingCoinTitle => 'La WPGG Coin';

  @override
  String get landingCoinSubtitle => 'Transparencia total. Sin caja negra.';

  @override
  String get landingCoinBody =>
      'El token WPGG está deployado en Polygon Mainnet y es auditable en PolygonScan. La liquidez está respaldada por un pool fijo en QuickSwap (par WPGG/USDC): es lo que es, no crece mágicamente ni promete retornos infinitos.';

  @override
  String get landingCoinBullet1 => 'Contrato verificable públicamente on-chain';

  @override
  String get landingCoinBullet2 =>
      'Pool fijo en QuickSwap — liquidez real, no promesas';

  @override
  String get landingCoinBullet3 =>
      'Podés ver el estado del pool y auditar todo vos mismo';

  @override
  String get landingCoinHighlightTitle => 'Pool fijo, expectativas claras';

  @override
  String get landingCoinHighlightBody =>
      'El pool de liquidez tiene un tamaño fijo. Eso significa que el sistema es honesto sobre lo que puede entregar: recompensas reales y canjeables, no un esquema para hacerte millonario farmeando partidas.';

  @override
  String get landingNotRichTitle => 'No te vas a hacer rico';

  @override
  String get landingNotRichSubtitle =>
      'Y lo decimos sin rodeos, porque la honestidad es el proyecto.';

  @override
  String get landingNotRichBody =>
      'WPGG no es un juego de inversión ni un esquema de farming infinito. Nadie se hace rico completando misiones. Es para que compres RP en la tienda con tus tokens, o retires las coins y le compres unas flores a tu novia o te tomes una birra con los pibes.';

  @override
  String get landingNotRichBullet1 =>
      'Recompensas modestas y reales — alcanzan para RP o un gustito';

  @override
  String get landingNotRichBullet2 =>
      'Sin promesas de multiplicar plata ni retornos garantizados';

  @override
  String get landingNotRichBullet3 =>
      'Si buscás especular, este no es tu lugar (y está bien)';

  @override
  String get landingUseTitle => '¿Qué podés hacer con tus WPGG?';

  @override
  String get landingUseSubtitle => 'Usalos en la app o llevátelos afuera.';

  @override
  String get landingUseBody =>
      'Tus tokens tienen utilidad concreta dentro y fuera de WPGG.';

  @override
  String get landingUseBullet1 =>
      'Comprar gift cards de Riot Points en la tienda WPGG';

  @override
  String get landingUseBullet2 =>
      'Retirar WPGG a tu wallet personal en Polygon';

  @override
  String get landingUseBullet3 =>
      'Canjearlos por lo que quieras: birra, flores, lo que se te ocurra';

  @override
  String get landingStepsTitle => 'Empezá en 4 pasos';

  @override
  String get landingStep1Title => 'Creá tu cuenta';

  @override
  String get landingStep1Body =>
      'Registrate con email o entrá con tu cuenta de Riot.';

  @override
  String get landingStep2Title => 'Elegí tus misiones';

  @override
  String get landingStep2Body =>
      'Seleccioná el set del día según tu tiempo y skill.';

  @override
  String get landingStep3Title => 'Jugá ranked';

  @override
  String get landingStep3Body =>
      'Las misiones se validan con tus partidas reales.';

  @override
  String get landingStep4Title => 'Cobrá y canjeá';

  @override
  String get landingStep4Body => 'Sumá WPGG, comprá RP o retirá a tu wallet.';

  @override
  String get landingSponsorsTitle => '¿Querés apoyar el proyecto?';

  @override
  String get landingSponsorsBody =>
      'Buscamos sponsors y partners que quieran sumarse a una comunidad de jugadores de LoL con un modelo transparente. Si tenés una propuesta de colaboración, activación o branding, escribinos.';

  @override
  String get landingFaqTitle => 'Preguntas frecuentes';

  @override
  String get landingFaqBody =>
      '¿Necesitás saber más sobre misiones, retiros o el token? Tenemos una sección completa de FAQs dentro de la app.';

  @override
  String get landingFaqLink => 'Ver todas las FAQs →';

  @override
  String get landingFooterTerms => 'Términos';

  @override
  String get landingFooterFaqs => 'FAQs';

  @override
  String get landingFooterLogin => 'Iniciar sesión';

  @override
  String get landingFooterRegister => 'Registrarse';

  @override
  String get landingFooterCoinMarketCap => 'CoinMarketCap';

  @override
  String get landingFooterDisclaimer =>
      'WPGG no está afiliado, asociado ni respaldado por Riot Games, Inc. League of Legends y Riot Games son marcas registradas de Riot Games, Inc.';

  @override
  String landingFooterCopyright(int year) {
    return '© $year WPGG. Todos los derechos reservados.';
  }

  @override
  String get landingSponsorSentTitle => 'Propuesta enviada';

  @override
  String get landingSponsorSentBody =>
      'Gracias por tu interés en apoyar WPGG. Revisamos cada propuesta y te respondemos a la brevedad.';

  @override
  String get landingSponsorThanksSnackbar =>
      '¡Gracias! Recibimos tu propuesta y te vamos a contactar.';

  @override
  String get landingSponsorCompanyLabel => 'Empresa o marca';

  @override
  String get landingSponsorCompanyHint => 'Tu organización';

  @override
  String get landingSponsorCompanyError =>
      'Ingresá el nombre de tu empresa o marca';

  @override
  String get landingSponsorEmailLabel => 'Email de contacto';

  @override
  String get landingSponsorEmailHint => 'hola@tuempresa.com';

  @override
  String get landingSponsorEmailError => 'Ingresá un email válido';

  @override
  String get landingSponsorMessageLabel => 'Tu propuesta';

  @override
  String get landingSponsorMessageHint =>
      'Contanos qué tipo de colaboración tenés en mente: activación, premios, branding, etc.';

  @override
  String get landingSponsorMessageError =>
      'Contanos un poco más sobre tu propuesta (mín. 20 caracteres)';

  @override
  String get landingSponsorSubmit => 'Enviar propuesta';

  @override
  String get landingSponsorTurnstileRequired =>
      'Completá la verificación de seguridad antes de enviar.';

  @override
  String get landingSponsorSubmitError =>
      'No pudimos enviar tu propuesta. Intentá de nuevo.';
}
