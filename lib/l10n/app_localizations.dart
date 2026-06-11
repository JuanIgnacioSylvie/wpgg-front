import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

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
    Locale('fr'),
    Locale('pt'),
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

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get languagePortuguese;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @welcomeMissionBadge.
  ///
  /// In en, this message translates to:
  /// **'GIFT MISSION'**
  String get welcomeMissionBadge;

  /// No description provided for @welcomeMissionSection.
  ///
  /// In en, this message translates to:
  /// **'Gift mission'**
  String get welcomeMissionSection;

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

  /// No description provided for @noMissionsForDay.
  ///
  /// In en, this message translates to:
  /// **'No missions for this day.'**
  String get noMissionsForDay;

  /// No description provided for @noMissionsForFilter.
  ///
  /// In en, this message translates to:
  /// **'No missions match this filter.'**
  String get noMissionsForFilter;

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

  /// No description provided for @termsAndConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditionsTitle;

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

  /// No description provided for @storeTitle.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get storeTitle;

  /// No description provided for @storeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Redeem your WPGG for Riot gift cards.'**
  String get storeSubtitle;

  /// No description provided for @storeBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get storeBuy;

  /// No description provided for @storePurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm purchase'**
  String get storePurchaseTitle;

  /// No description provided for @storePurchaseBody.
  ///
  /// In en, this message translates to:
  /// **'You will spend {cost} WPGG for {product}.'**
  String storePurchaseBody(int cost, String product);

  /// No description provided for @storeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Purchases will be available soon.'**
  String get storeComingSoon;

  /// No description provided for @storeOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'Your purchases'**
  String get storeOrderHistory;

  /// No description provided for @storeNoOrders.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t bought anything from the store yet.'**
  String get storeNoOrders;

  /// No description provided for @storePurchaseSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful!'**
  String get storePurchaseSuccessTitle;

  /// No description provided for @storePurchaseSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your {rp} RP gift card is ready. Save the key somewhere safe.'**
  String storePurchaseSuccessBody(int rp);

  /// No description provided for @storeYourKey.
  ///
  /// In en, this message translates to:
  /// **'Your Riot Key'**
  String get storeYourKey;

  /// No description provided for @storeCopyKey.
  ///
  /// In en, this message translates to:
  /// **'Copy key'**
  String get storeCopyKey;

  /// No description provided for @storeKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'Key copied to clipboard'**
  String get storeKeyCopied;

  /// No description provided for @storeDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get storeDone;

  /// No description provided for @storeOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'This product is out of stock.'**
  String get storeOutOfStock;

  /// No description provided for @storePurchaseError.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the purchase. Please try again.'**
  String get storePurchaseError;

  /// No description provided for @transactionProcessingAcceptMission.
  ///
  /// In en, this message translates to:
  /// **'Accepting mission…'**
  String get transactionProcessingAcceptMission;

  /// No description provided for @transactionProcessingRerollMission.
  ///
  /// In en, this message translates to:
  /// **'Rerolling mission…'**
  String get transactionProcessingRerollMission;

  /// No description provided for @transactionProcessingCancelMission.
  ///
  /// In en, this message translates to:
  /// **'Deleting mission…'**
  String get transactionProcessingCancelMission;

  /// No description provided for @transactionProcessingPurchase.
  ///
  /// In en, this message translates to:
  /// **'Processing purchase…'**
  String get transactionProcessingPurchase;

  /// No description provided for @transactionSuccessAcceptMission.
  ///
  /// In en, this message translates to:
  /// **'Mission accepted'**
  String get transactionSuccessAcceptMission;

  /// No description provided for @transactionSuccessRerollMission.
  ///
  /// In en, this message translates to:
  /// **'Mission rerolled'**
  String get transactionSuccessRerollMission;

  /// No description provided for @transactionSuccessCancelMission.
  ///
  /// In en, this message translates to:
  /// **'Mission deleted'**
  String get transactionSuccessCancelMission;

  /// No description provided for @transactionFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'The action could not be completed. Please try again.'**
  String get transactionFailedGeneric;

  /// No description provided for @viewOnGeckoTerminal.
  ///
  /// In en, this message translates to:
  /// **'View on GeckoTerminal'**
  String get viewOnGeckoTerminal;

  /// No description provided for @authLoginSwitchLine.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authLoginSwitchLine;

  /// No description provided for @authLoginSwitchLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up here!'**
  String get authLoginSwitchLink;

  /// No description provided for @authRegisterSwitchLine.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authRegisterSwitchLine;

  /// No description provided for @authRegisterSwitchLink.
  ///
  /// In en, this message translates to:
  /// **'Log in here!'**
  String get authRegisterSwitchLink;

  /// No description provided for @authSwitchLinkPrefix.
  ///
  /// In en, this message translates to:
  /// **'You can '**
  String get authSwitchLinkPrefix;

  /// No description provided for @riotNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Account not found.'**
  String get riotNotFoundTitle;

  /// No description provided for @riotNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find a WPGG account linked to that Riot ID. Sign up on WPGG first.'**
  String get riotNotFoundBody;

  /// No description provided for @riotNotFoundRegister.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get riotNotFoundRegister;

  /// No description provided for @riotAlreadyExistsTitle.
  ///
  /// In en, this message translates to:
  /// **'You already have an account.'**
  String get riotAlreadyExistsTitle;

  /// No description provided for @riotAlreadyExistsBody.
  ///
  /// In en, this message translates to:
  /// **'A WPGG account is already linked to this Riot ID. Sign in with Riot or email.'**
  String get riotAlreadyExistsBody;

  /// No description provided for @riotAlreadyExistsSignInRiot.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Riot'**
  String get riotAlreadyExistsSignInRiot;

  /// No description provided for @linkRiotBody.
  ///
  /// In en, this message translates to:
  /// **'Link your Riot Games account to complete registration.'**
  String get linkRiotBody;

  /// No description provided for @authLabelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authLabelEmail;

  /// No description provided for @authHintEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authHintEmail;

  /// No description provided for @authLabelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authLabelPassword;

  /// No description provided for @authHintPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authHintPassword;

  /// No description provided for @authLabelConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authLabelConfirmPassword;

  /// No description provided for @authHintConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get authHintConfirmPassword;

  /// No description provided for @authRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get authRememberMe;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get authForgotPassword;

  /// No description provided for @authButtonLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authButtonLogin;

  /// No description provided for @authButtonRegister.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authButtonRegister;

  /// No description provided for @authRiotFooter.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authRiotFooter;

  /// No description provided for @authPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get authPasswordsMismatch;

  /// No description provided for @authForgotPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send a reset link.'**
  String get authForgotPasswordBody;

  /// No description provided for @authForgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, we sent a reset link.'**
  String get authForgotPasswordSuccess;

  /// No description provided for @authButtonSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get authButtonSendResetLink;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to log in'**
  String get authBackToLogin;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authResetPasswordTitle;

  /// No description provided for @authResetPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your account.'**
  String get authResetPasswordBody;

  /// No description provided for @authButtonResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authButtonResetPassword;

  /// No description provided for @authResetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated. You can log in now.'**
  String get authResetPasswordSuccess;

  /// No description provided for @authResetPasswordInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired link. Request a new one from log in.'**
  String get authResetPasswordInvalidLink;

  /// No description provided for @authVerifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email'**
  String get authVerifyEmailTitle;

  /// No description provided for @authVerifyEmailBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a link to your email. Open it to activate your account.'**
  String get authVerifyEmailBody;

  /// No description provided for @authVerifyEmailResent.
  ///
  /// In en, this message translates to:
  /// **'If the account exists and isn\'t verified, we resent the link.'**
  String get authVerifyEmailResent;

  /// No description provided for @authVerifyEmailSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email confirmed. Welcome to WPGG!'**
  String get authVerifyEmailSuccess;

  /// No description provided for @authVerifyEmailInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired link. Request a new one from sign up.'**
  String get authVerifyEmailInvalidLink;

  /// No description provided for @authButtonResendVerification.
  ///
  /// In en, this message translates to:
  /// **'Resend link'**
  String get authButtonResendVerification;

  /// No description provided for @authTurnstileRequired.
  ///
  /// In en, this message translates to:
  /// **'Complete the security check before continuing.'**
  String get authTurnstileRequired;

  /// No description provided for @authVerifyEmailConfirming.
  ///
  /// In en, this message translates to:
  /// **'Confirming your email…'**
  String get authVerifyEmailConfirming;

  /// No description provided for @riotLoginCompleted.
  ///
  /// In en, this message translates to:
  /// **'Riot login complete'**
  String get riotLoginCompleted;

  /// No description provided for @riotCallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Riot'**
  String get riotCallbackTitle;

  /// No description provided for @riotGoToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to dashboard'**
  String get riotGoToDashboard;

  /// No description provided for @riotGoToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to log in'**
  String get riotGoToLogin;

  /// No description provided for @riotSessionTokensInUrl.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Riot (tokens in URL).'**
  String get riotSessionTokensInUrl;

  /// No description provided for @riotSessionCookies.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Riot (cookies).'**
  String get riotSessionCookies;

  /// No description provided for @riotSessionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Riot account authenticated; app session updated.'**
  String get riotSessionUpdated;

  /// No description provided for @riotSessionViaExchange.
  ///
  /// In en, this message translates to:
  /// **'WPGG session via Riot exchange.'**
  String get riotSessionViaExchange;

  /// No description provided for @riotIdentityError.
  ///
  /// In en, this message translates to:
  /// **'The server couldn\'t get your Riot identity. Try signing in again.'**
  String get riotIdentityError;

  /// No description provided for @riotIdentityErrorWithDesc.
  ///
  /// In en, this message translates to:
  /// **'The server couldn\'t get your Riot identity: {desc}'**
  String riotIdentityErrorWithDesc(String desc);

  /// No description provided for @riotNoSessionAfterLogin.
  ///
  /// In en, this message translates to:
  /// **'No session received after Riot login.'**
  String get riotNoSessionAfterLogin;

  /// No description provided for @financeTitle.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeTitle;

  /// No description provided for @financeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Token price and your wallet activity'**
  String get financeSubtitle;

  /// No description provided for @financeYourBalance.
  ///
  /// In en, this message translates to:
  /// **'Your balance'**
  String get financeYourBalance;

  /// No description provided for @balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceLabel;

  /// No description provided for @financeFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get financeFilterAll;

  /// No description provided for @financeFilterAllTransactions.
  ///
  /// In en, this message translates to:
  /// **'All transactions'**
  String get financeFilterAllTransactions;

  /// No description provided for @financeFilterIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeFilterIncome;

  /// No description provided for @financeFilterExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get financeFilterExpense;

  /// No description provided for @financePriceHistory.
  ///
  /// In en, this message translates to:
  /// **'7-day price history'**
  String get financePriceHistory;

  /// No description provided for @financeNoChartData.
  ///
  /// In en, this message translates to:
  /// **'No chart data'**
  String get financeNoChartData;

  /// No description provided for @financeNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get financeNoTransactions;

  /// No description provided for @tokenPriceUpdatedHint.
  ///
  /// In en, this message translates to:
  /// **'Price in USD · updated every 60s'**
  String get tokenPriceUpdatedHint;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @sidebarExpandMenu.
  ///
  /// In en, this message translates to:
  /// **'Expand menu'**
  String get sidebarExpandMenu;

  /// No description provided for @sidebarCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get sidebarCollapse;

  /// No description provided for @addMissionButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addMissionButton;

  /// No description provided for @matchChampionFallback.
  ///
  /// In en, this message translates to:
  /// **'Champion {id}'**
  String matchChampionFallback(int id);

  /// No description provided for @matchWin.
  ///
  /// In en, this message translates to:
  /// **'Victory'**
  String get matchWin;

  /// No description provided for @matchLoss.
  ///
  /// In en, this message translates to:
  /// **'Defeat'**
  String get matchLoss;

  /// No description provided for @timeAgoJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeAgoJustNow;

  /// No description provided for @timeAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String timeAgoMinutes(int count);

  /// No description provided for @timeAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String timeAgoHours(int count);

  /// No description provided for @timeAgoDays.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String timeAgoDays(int count);

  /// No description provided for @rankedWinrate.
  ///
  /// In en, this message translates to:
  /// **'Win rate {percent}%'**
  String rankedWinrate(String percent);

  /// No description provided for @queueRankedSolo.
  ///
  /// In en, this message translates to:
  /// **'Solo/Duo'**
  String get queueRankedSolo;

  /// No description provided for @queueRankedFlex.
  ///
  /// In en, this message translates to:
  /// **'Flex 5v5'**
  String get queueRankedFlex;

  /// No description provided for @queueRankedTft.
  ///
  /// In en, this message translates to:
  /// **'Ranked TFT'**
  String get queueRankedTft;

  /// No description provided for @queueArena.
  ///
  /// In en, this message translates to:
  /// **'Arena'**
  String get queueArena;

  /// No description provided for @queueAram.
  ///
  /// In en, this message translates to:
  /// **'ARAM'**
  String get queueAram;

  /// No description provided for @queueNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get queueNormal;
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
      <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

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
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
