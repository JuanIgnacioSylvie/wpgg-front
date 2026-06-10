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
}
