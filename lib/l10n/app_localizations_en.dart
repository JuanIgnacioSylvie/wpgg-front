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
  String get rerollMissionBody => 'This will cost 5 WPGG from your balance.';

  @override
  String get cancel => 'Cancel';

  @override
  String get reroll => 'Reroll';

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
}
