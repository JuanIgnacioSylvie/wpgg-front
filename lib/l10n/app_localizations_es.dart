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
  String get rerollMissionBody => 'Esto costará 5 WPGG de tu saldo.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reroll => 'Cambiar';

  @override
  String get cancelMissionTitle => '¿Eliminar misión?';

  @override
  String get cancelMissionBody => 'Esto costará 5 WPGG de tu saldo.';

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
}
