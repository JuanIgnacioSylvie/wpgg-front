// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello!';

  @override
  String get profile => 'Profile';

  @override
  String get logOut => 'Log out';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get retry => 'Retry';

  @override
  String get inProgress => 'In Progress';

  @override
  String missionDayResets(String date, String timezone) {
    return 'Mission day $date · resets 00:00 $timezone';
  }

  @override
  String dayEndsIn(String time) {
    return 'Day ends in: $time';
  }

  @override
  String get noActiveMissions =>
      'No active missions yet. Pick up to 3 for today!';

  @override
  String get pickMissions => 'Pick missions';

  @override
  String get passMissions => 'Pass Missions';

  @override
  String get completedMissionsPlaceholder =>
      'Completed missions will appear here.';

  @override
  String get errorLoadingMissions => 'Error loading missions';

  @override
  String get missionsByDays => 'Missions by days';

  @override
  String get errorGeneric => 'Error';

  @override
  String get filterAll => 'All';

  @override
  String get filterToDo => 'To do';

  @override
  String get filterInProgress => 'In Progress';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusIncomplete => 'Incomplete';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusToDo => 'To do';

  @override
  String endsIn(String time) {
    return 'Ends in: $time';
  }

  @override
  String get pickMissionsTitle => 'Pick Missions';

  @override
  String get errorLoadingOffers => 'Error loading offers';

  @override
  String selectedMissionsCount(int count, int max, int maxHard) {
    return 'Selected $count/$max (max $maxHard hard)';
  }

  @override
  String get rerollMissionTitle => 'Reroll mission?';

  @override
  String rerollMissionBody(int cost) {
    return 'This will cost $cost WPGG from your balance.';
  }

  @override
  String missionSpendBalanceHint(int balance) {
    return 'Current balance: $balance WPGG';
  }

  @override
  String get missionInsufficientBalance =>
      'You don\'t have enough WPGG for this action';

  @override
  String get cancel => 'Cancel';

  @override
  String get reroll => 'Reroll';

  @override
  String get cancelMissionTitle => 'Delete mission?';

  @override
  String cancelMissionBody(int cost) {
    return 'This will cost $cost WPGG from your balance.';
  }

  @override
  String get deleteMission => 'Delete';

  @override
  String get dropToDeleteMission => 'Drop here to delete';

  @override
  String summonerLevel(int level) {
    return 'Level $level';
  }

  @override
  String get linkRiotPrompt => 'Link your Riot account to see stats.';

  @override
  String get linkRiotAfterLoginPrompt =>
      'We couldn\'t link your LoL account automatically. Complete your summoner details to see stats.';

  @override
  String get linkRiotButton => 'Link Riot account';

  @override
  String get completeRiotLinkButton => 'Complete manual linking';

  @override
  String get linkRiotSheetTitle => 'Link Riot';

  @override
  String get linkRiotSheetAction => 'Link';

  @override
  String get summonerNameLabel => 'Summoner name';

  @override
  String get tagLabel => 'Tag (#TAG without #)';

  @override
  String get regionLabel => 'Region (e.g. LA2)';

  @override
  String get myProfile => 'My profile';

  @override
  String get withdraw => 'WITHDRAW';

  @override
  String get generalNotification => 'General Notification';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get contactUs => 'Contact us';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get withdrawTitle => 'Withdraw WPGG';

  @override
  String withdrawMinHint(int amount) {
    return 'Minimum withdrawal is $amount WPGG';
  }

  @override
  String get walletAddressLabel => 'Polygon wallet address';

  @override
  String get walletAddressRequired => 'Wallet address is required';

  @override
  String get walletAddressInvalid => 'Enter a valid Polygon address (0x...)';

  @override
  String get withdrawAmountLabel => 'Amount (WPGG)';

  @override
  String get withdrawAmountInvalid => 'Enter a valid amount';

  @override
  String get withdrawInsufficientBalance => 'Insufficient balance';

  @override
  String get withdrawSuccess => 'Withdrawal submitted successfully';

  @override
  String get withdrawError => 'Withdrawal failed. Please try again.';

  @override
  String get pageUnavailableTitle => 'This page is not available';

  @override
  String get pageUnavailableBody =>
      'We\'re working on it. Please check back later.';

  @override
  String get faqsMenuItem => 'FAQs';

  @override
  String get faqsTitle => 'Frequently asked questions';

  @override
  String get faqsIntro =>
      'Everything you need to know about WPGG — missions, rewards, withdrawals and more.';

  @override
  String get faqWhatIsWpggQ => 'What is WPGG?';

  @override
  String get faqWhatIsWpggA =>
      'WPGG is a League of Legends stats platform that rewards you for playing. Complete daily missions, earn WPGG tokens, and redeem them for Riot Points gift cards or other real-world rewards.';

  @override
  String get faqHowMissionsWorkQ => 'How do missions work?';

  @override
  String get faqHowMissionsWorkA =>
      'Each day you get a set of missions: easy, medium, and hard. Easy ones are simple — play a match or win with a specific champion. Medium and hard missions require better performance: hit a certain KDA, get X assists, win streaks, and so on. Complete the mission, earn tokens. That\'s it.';

  @override
  String get faqRerollQ => 'Can I reroll missions?';

  @override
  String get faqRerollA =>
      'Yes. If a mission doesn\'t suit you or you can\'t complete it, you have daily rerolls to swap it for another random one of the same tier.';

  @override
  String get faqWithdrawQ => 'How do I withdraw WPGG to my wallet?';

  @override
  String get faqWithdrawA =>
      'You need to accumulate a minimum of 1,000 WPGG to withdraw. Once you reach it, you can start a withdrawal from the finance section. Tokens are transferred to your wallet on the Polygon network. You need a compatible wallet (like MetaMask) and to cover the transaction gas fee — on Polygon it\'s practically nothing.';

  @override
  String get faqWhatCanIDoQ => 'What can I do with WPGG?';

  @override
  String get faqWhatCanIDoA =>
      'For now you can redeem them in the in-app store for Riot Points gift cards. The idea is that with what you earn over a few weeks of normal play you can buy a skin, treat your girlfriend, or grab beers with the boys. It\'s not about getting rich — it\'s a real reward for what you already do.';

  @override
  String get faqTokenPriceQ => 'How much is one WPGG worth?';

  @override
  String get faqTokenPriceA =>
      'The token trades on the market, so the price varies. But the app isn\'t built for speculation — it\'s built for you to use it. The real value is in redeeming for concrete products.';

  @override
  String get faqGetRichQ => 'Will WPGG make me rich?';

  @override
  String get faqGetRichA =>
      'No. And we say it straight because transparency is part of the project. WPGG is not an investment scheme or a speculation game. It\'s a rewards system backed by a fixed liquidity pool on QuickSwap (WPGG/USDC). The pool is what it is — it doesn\'t grow magically, there are no return promises. What you earn playing has real, redeemable value, but don\'t expect to multiply your money here.';

  @override
  String get faqTransparencyQ => 'Is it safe? Is the project transparent?';

  @override
  String get faqTransparencyA =>
      'Yes. The WPGG token contract is deployed on Polygon Mainnet and is publicly verifiable on PolygonScan. The liquidity pool is on QuickSwap. Everything backing the system is on-chain and anyone can audit it. No black box.';

  @override
  String get faqCryptoKnowledgeQ => 'Do I need to know crypto to use the app?';

  @override
  String get faqCryptoKnowledgeA =>
      'To play missions and earn WPGG, you don\'t need to know anything about crypto. Complexity only shows up when you want to withdraw to your wallet — and even then the process is guided step by step inside the app.';

  @override
  String get faqLoLAccountQ => 'Which LoL account do I connect with?';

  @override
  String get faqLoLAccountA =>
      'The app uses Riot Sign On (Riot Games\' official system), so you sign in with your Riot account directly. You don\'t need to give us your password or anything like that — it\'s the same OAuth used by apps like op.gg or u.gg.';

  @override
  String get faqAvailabilityQ => 'Is the app available on iOS and Android?';

  @override
  String get faqAvailabilityA =>
      'It\'s currently in active development. More info on availability coming soon.';
}
