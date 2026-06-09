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
  /// **'This will cost {cost} WPGG from your balance.'**
  String rerollMissionBody(int cost);

  /// No description provided for @missionSpendBalanceHint.
  ///
  /// In en, this message translates to:
  /// **'Current balance: {balance} WPGG'**
  String missionSpendBalanceHint(int balance);

  /// No description provided for @missionInsufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough WPGG for this action'**
  String get missionInsufficientBalance;

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
  /// **'This will cost {cost} WPGG from your balance.'**
  String cancelMissionBody(int cost);

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

  /// No description provided for @pageUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'This page is not available'**
  String get pageUnavailableTitle;

  /// No description provided for @pageUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'We\'re working on it. Please check back later.'**
  String get pageUnavailableBody;

  /// No description provided for @faqsMenuItem.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqsMenuItem;

  /// No description provided for @faqsTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get faqsTitle;

  /// No description provided for @faqsIntro.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to know about WPGG — missions, rewards, withdrawals and more.'**
  String get faqsIntro;

  /// No description provided for @faqWhatIsWpggQ.
  ///
  /// In en, this message translates to:
  /// **'What is WPGG?'**
  String get faqWhatIsWpggQ;

  /// No description provided for @faqWhatIsWpggA.
  ///
  /// In en, this message translates to:
  /// **'WPGG is a League of Legends stats platform that rewards you for playing. Complete daily missions, earn WPGG tokens, and redeem them for Riot Points gift cards or other real-world rewards.'**
  String get faqWhatIsWpggA;

  /// No description provided for @faqHowMissionsWorkQ.
  ///
  /// In en, this message translates to:
  /// **'How do missions work?'**
  String get faqHowMissionsWorkQ;

  /// No description provided for @faqHowMissionsWorkA.
  ///
  /// In en, this message translates to:
  /// **'Each day you get a set of missions: easy, medium, and hard. Easy ones are simple — play a match or win with a specific champion. Medium and hard missions require better performance: hit a certain KDA, get X assists, win streaks, and so on. Complete the mission, earn tokens. That\'s it.'**
  String get faqHowMissionsWorkA;

  /// No description provided for @faqRerollQ.
  ///
  /// In en, this message translates to:
  /// **'Can I reroll missions?'**
  String get faqRerollQ;

  /// No description provided for @faqRerollA.
  ///
  /// In en, this message translates to:
  /// **'Yes. If a mission doesn\'t suit you or you can\'t complete it, you have daily rerolls to swap it for another random one of the same tier.'**
  String get faqRerollA;

  /// No description provided for @faqWithdrawQ.
  ///
  /// In en, this message translates to:
  /// **'How do I withdraw WPGG to my wallet?'**
  String get faqWithdrawQ;

  /// No description provided for @faqWithdrawA.
  ///
  /// In en, this message translates to:
  /// **'You need to accumulate a minimum of 1,000 WPGG to withdraw. Once you reach it, you can start a withdrawal from the finance section. Tokens are transferred to your wallet on the Polygon network. You need a compatible wallet (like MetaMask) and to cover the transaction gas fee — on Polygon it\'s practically nothing.'**
  String get faqWithdrawA;

  /// No description provided for @faqWhatCanIDoQ.
  ///
  /// In en, this message translates to:
  /// **'What can I do with WPGG?'**
  String get faqWhatCanIDoQ;

  /// No description provided for @faqWhatCanIDoA.
  ///
  /// In en, this message translates to:
  /// **'For now you can redeem them in the in-app store for Riot Points gift cards. The idea is that with what you earn over a few weeks of normal play you can buy a skin, treat your girlfriend, or grab beers with the boys. It\'s not about getting rich — it\'s a real reward for what you already do.'**
  String get faqWhatCanIDoA;

  /// No description provided for @faqTokenPriceQ.
  ///
  /// In en, this message translates to:
  /// **'How much is one WPGG worth?'**
  String get faqTokenPriceQ;

  /// No description provided for @faqTokenPriceA.
  ///
  /// In en, this message translates to:
  /// **'The token trades on the market, so the price varies. But the app isn\'t built for speculation — it\'s built for you to use it. The real value is in redeeming for concrete products.'**
  String get faqTokenPriceA;

  /// No description provided for @faqGetRichQ.
  ///
  /// In en, this message translates to:
  /// **'Will WPGG make me rich?'**
  String get faqGetRichQ;

  /// No description provided for @faqGetRichA.
  ///
  /// In en, this message translates to:
  /// **'No. And we say it straight because transparency is part of the project. WPGG is not an investment scheme or a speculation game. It\'s a rewards system backed by a fixed liquidity pool on QuickSwap (WPGG/USDC). The pool is what it is — it doesn\'t grow magically, there are no return promises. What you earn playing has real, redeemable value, but don\'t expect to multiply your money here.'**
  String get faqGetRichA;

  /// No description provided for @faqTransparencyQ.
  ///
  /// In en, this message translates to:
  /// **'Is it safe? Is the project transparent?'**
  String get faqTransparencyQ;

  /// No description provided for @faqTransparencyA.
  ///
  /// In en, this message translates to:
  /// **'Yes. The WPGG token contract is deployed on Polygon Mainnet and is publicly verifiable on PolygonScan. The liquidity pool is on QuickSwap. Everything backing the system is on-chain and anyone can audit it. No black box.'**
  String get faqTransparencyA;

  /// No description provided for @faqCryptoKnowledgeQ.
  ///
  /// In en, this message translates to:
  /// **'Do I need to know crypto to use the app?'**
  String get faqCryptoKnowledgeQ;

  /// No description provided for @faqCryptoKnowledgeA.
  ///
  /// In en, this message translates to:
  /// **'To play missions and earn WPGG, you don\'t need to know anything about crypto. Complexity only shows up when you want to withdraw to your wallet — and even then the process is guided step by step inside the app.'**
  String get faqCryptoKnowledgeA;

  /// No description provided for @faqLoLAccountQ.
  ///
  /// In en, this message translates to:
  /// **'Which LoL account do I connect with?'**
  String get faqLoLAccountQ;

  /// No description provided for @faqLoLAccountA.
  ///
  /// In en, this message translates to:
  /// **'The app uses Riot Sign On (Riot Games\' official system), so you sign in with your Riot account directly. You don\'t need to give us your password or anything like that — it\'s the same OAuth used by apps like op.gg or u.gg.'**
  String get faqLoLAccountA;

  /// No description provided for @faqAvailabilityQ.
  ///
  /// In en, this message translates to:
  /// **'Is the app available on iOS and Android?'**
  String get faqAvailabilityQ;

  /// No description provided for @faqAvailabilityA.
  ///
  /// In en, this message translates to:
  /// **'It\'s currently in active development. More info on availability coming soon.'**
  String get faqAvailabilityA;
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
