import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get hello;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @missionDayResets.
  ///
  /// In en, this message translates to:
  /// **'Mission day {date} · resets 00:00 {timezone}'**
  String missionDayResets(String date, String timezone);

  /// No description provided for @dayEndsIn.
  ///
  /// In en, this message translates to:
  /// **'Day ends in: {time}'**
  String dayEndsIn(String time);

  /// No description provided for @noActiveMissions.
  ///
  /// In en, this message translates to:
  /// **'No active missions yet. Pick up to 3 for today!'**
  String get noActiveMissions;

  /// No description provided for @pickMissions.
  ///
  /// In en, this message translates to:
  /// **'Pick missions'**
  String get pickMissions;

  /// No description provided for @passMissions.
  ///
  /// In en, this message translates to:
  /// **'Pass Missions'**
  String get passMissions;

  /// No description provided for @completedMissionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Completed missions will appear here.'**
  String get completedMissionsPlaceholder;

  /// No description provided for @errorLoadingMissions.
  ///
  /// In en, this message translates to:
  /// **'Error loading missions'**
  String get errorLoadingMissions;

  /// No description provided for @missionsByDays.
  ///
  /// In en, this message translates to:
  /// **'Missions by days'**
  String get missionsByDays;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorGeneric;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterToDo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get filterToDo;

  /// No description provided for @filterInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get filterInProgress;

  /// No description provided for @filterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get filterCompleted;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get statusIncomplete;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusToDo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get statusToDo;

  /// No description provided for @endsIn.
  ///
  /// In en, this message translates to:
  /// **'Ends in: {time}'**
  String endsIn(String time);

  /// No description provided for @pickMissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick Missions'**
  String get pickMissionsTitle;

  /// No description provided for @errorLoadingOffers.
  ///
  /// In en, this message translates to:
  /// **'Error loading offers'**
  String get errorLoadingOffers;

  /// No description provided for @selectedMissionsCount.
  ///
  /// In en, this message translates to:
  /// **'Selected {count}/{max} (max {maxHard} hard)'**
  String selectedMissionsCount(int count, int max, int maxHard);

  /// No description provided for @rerollMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reroll mission?'**
  String get rerollMissionTitle;

  /// No description provided for @rerollMissionBody.
  ///
  /// In en, this message translates to:
  /// **'This will cost 5 WPGG from your balance.'**
  String get rerollMissionBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reroll.
  ///
  /// In en, this message translates to:
  /// **'Reroll'**
  String get reroll;

  /// No description provided for @cancelMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete mission?'**
  String get cancelMissionTitle;

  /// No description provided for @cancelMissionBody.
  ///
  /// In en, this message translates to:
  /// **'This will cost 5 WPGG from your balance.'**
  String get cancelMissionBody;

  /// No description provided for @deleteMission.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteMission;

  /// No description provided for @dropToDeleteMission.
  ///
  /// In en, this message translates to:
  /// **'Drop here to delete'**
  String get dropToDeleteMission;

  /// No description provided for @summonerLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String summonerLevel(int level);

  /// No description provided for @linkRiotPrompt.
  ///
  /// In en, this message translates to:
  /// **'Link your Riot account to see stats.'**
  String get linkRiotPrompt;

  /// No description provided for @linkRiotAfterLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t link your LoL account automatically. Complete your summoner details to see stats.'**
  String get linkRiotAfterLoginPrompt;

  /// No description provided for @linkRiotButton.
  ///
  /// In en, this message translates to:
  /// **'Link Riot account'**
  String get linkRiotButton;

  /// No description provided for @completeRiotLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Complete manual linking'**
  String get completeRiotLinkButton;

  /// No description provided for @linkRiotSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Link Riot'**
  String get linkRiotSheetTitle;

  /// No description provided for @linkRiotSheetAction.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkRiotSheetAction;

  /// No description provided for @summonerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Summoner name'**
  String get summonerNameLabel;

  /// No description provided for @tagLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag (#TAG without #)'**
  String get tagLabel;

  /// No description provided for @regionLabel.
  ///
  /// In en, this message translates to:
  /// **'Region (e.g. LA2)'**
  String get regionLabel;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'WITHDRAW'**
  String get withdraw;

  /// No description provided for @generalNotification.
  ///
  /// In en, this message translates to:
  /// **'General Notification'**
  String get generalNotification;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @withdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw WPGG'**
  String get withdrawTitle;

  /// No description provided for @withdrawMinHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum withdrawal is {amount} WPGG'**
  String withdrawMinHint(int amount);

  /// No description provided for @walletAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Polygon wallet address'**
  String get walletAddressLabel;

  /// No description provided for @walletAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Wallet address is required'**
  String get walletAddressRequired;

  /// No description provided for @walletAddressInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Polygon address (0x...)'**
  String get walletAddressInvalid;

  /// No description provided for @withdrawAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (WPGG)'**
  String get withdrawAmountLabel;

  /// No description provided for @withdrawAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get withdrawAmountInvalid;

  /// No description provided for @withdrawInsufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get withdrawInsufficientBalance;

  /// No description provided for @withdrawSuccess.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal submitted successfully'**
  String get withdrawSuccess;

  /// No description provided for @withdrawError.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal failed. Please try again.'**
  String get withdrawError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
