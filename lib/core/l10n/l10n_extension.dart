import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import 'auth_error_codes.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  String languageLabelForCode(String code) {
    final l10n = this.l10n;
    return switch (code) {
      'es' => l10n.languageSpanish,
      'fr' => l10n.languageFrench,
      'pt' => l10n.languagePortuguese,
      _ => l10n.languageEnglish,
    };
  }

  String localizeAuthError(String message) {
    return switch (message) {
      AuthErrorCodes.riotNoSession => l10n.riotNoSessionAfterLogin,
      _ => message,
    };
  }
}
