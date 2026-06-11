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
  String get languageFrench => 'French';

  @override
  String get languagePortuguese => 'Portuguese';

  @override
  String get retry => 'Retry';

  @override
  String get welcomeMissionBadge => 'GIFT MISSION';

  @override
  String get welcomeMissionSection => 'Gift mission';

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
  String get noMissionsForDay => 'No missions for this day.';

  @override
  String get noMissionsForFilter => 'No missions match this filter.';

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
  String get termsAndConditionsTitle => 'Terms and Conditions';

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

  @override
  String get storeTitle => 'Store';

  @override
  String get storeSubtitle => 'Redeem your WPGG for Riot gift cards.';

  @override
  String get storeBuy => 'Buy';

  @override
  String get storePurchaseTitle => 'Confirm purchase';

  @override
  String storePurchaseBody(int cost, String product) {
    return 'You will spend $cost WPGG for $product.';
  }

  @override
  String get storeComingSoon => 'Purchases will be available soon.';

  @override
  String get storeOrderHistory => 'Your purchases';

  @override
  String get storeNoOrders =>
      'You haven\'t bought anything from the store yet.';

  @override
  String get storePurchaseSuccessTitle => 'Purchase successful!';

  @override
  String storePurchaseSuccessBody(int rp) {
    return 'Your $rp RP gift card is ready. Save the key somewhere safe.';
  }

  @override
  String get storeYourKey => 'Your Riot Key';

  @override
  String get storeCopyKey => 'Copy key';

  @override
  String get storeKeyCopied => 'Key copied to clipboard';

  @override
  String get storeDone => 'Done';

  @override
  String get storeOutOfStock => 'This product is out of stock.';

  @override
  String get storePurchaseError =>
      'Could not complete the purchase. Please try again.';

  @override
  String get transactionProcessingAcceptMission => 'Accepting mission…';

  @override
  String get transactionProcessingRerollMission => 'Rerolling mission…';

  @override
  String get transactionProcessingCancelMission => 'Deleting mission…';

  @override
  String get transactionProcessingPurchase => 'Processing purchase…';

  @override
  String get transactionSuccessAcceptMission => 'Mission accepted';

  @override
  String get transactionSuccessRerollMission => 'Mission rerolled';

  @override
  String get transactionSuccessCancelMission => 'Mission deleted';

  @override
  String get transactionFailedGeneric =>
      'The action could not be completed. Please try again.';

  @override
  String get viewOnGeckoTerminal => 'View on GeckoTerminal';

  @override
  String get authLoginSwitchLine => 'Don\'t have an account?';

  @override
  String get authLoginSwitchLink => 'Sign up here!';

  @override
  String get authRegisterSwitchLine => 'Already have an account?';

  @override
  String get authRegisterSwitchLink => 'Log in here!';

  @override
  String get authSwitchLinkPrefix => 'You can ';

  @override
  String get riotNotFoundTitle => 'Account not found.';

  @override
  String get riotNotFoundBody =>
      'We couldn\'t find a WPGG account linked to that Riot ID. Sign up on WPGG first.';

  @override
  String get riotNotFoundRegister => 'Sign up';

  @override
  String get riotAlreadyExistsTitle => 'You already have an account.';

  @override
  String get riotAlreadyExistsBody =>
      'A WPGG account is already linked to this Riot ID. Sign in with Riot or email.';

  @override
  String get riotAlreadyExistsSignInRiot => 'Sign in with Riot';

  @override
  String get linkRiotBody =>
      'Link your Riot Games account to complete registration.';

  @override
  String get authLabelEmail => 'Email';

  @override
  String get authHintEmail => 'Enter your email';

  @override
  String get authLabelPassword => 'Password';

  @override
  String get authHintPassword => 'Enter your password';

  @override
  String get authLabelConfirmPassword => 'Confirm password';

  @override
  String get authHintConfirmPassword => 'Confirm your password';

  @override
  String get authRememberMe => 'Remember me';

  @override
  String get authForgotPassword => 'Forgot your password?';

  @override
  String get authButtonLogin => 'Log in';

  @override
  String get authButtonRegister => 'Sign up';

  @override
  String get authRiotFooter => 'or continue with';

  @override
  String get authPasswordsMismatch => 'Passwords don\'t match';

  @override
  String get authForgotPasswordBody =>
      'Enter your email and we\'ll send a reset link.';

  @override
  String get authForgotPasswordSuccess =>
      'If an account exists, we sent a reset link.';

  @override
  String get authButtonSendResetLink => 'Send link';

  @override
  String get authBackToLogin => 'Back to log in';

  @override
  String get authResetPasswordTitle => 'New password';

  @override
  String get authResetPasswordBody => 'Choose a new password for your account.';

  @override
  String get authButtonResetPassword => 'Reset password';

  @override
  String get authResetPasswordSuccess =>
      'Password updated. You can log in now.';

  @override
  String get authResetPasswordInvalidLink =>
      'Invalid or expired link. Request a new one from log in.';

  @override
  String get authVerifyEmailTitle => 'Confirm your email';

  @override
  String get authVerifyEmailBody =>
      'We sent a link to your email. Open it to activate your account.';

  @override
  String get authVerifyEmailResent =>
      'If the account exists and isn\'t verified, we resent the link.';

  @override
  String get authVerifyEmailSuccess => 'Email confirmed. Welcome to WPGG!';

  @override
  String get authVerifyEmailInvalidLink =>
      'Invalid or expired link. Request a new one from sign up.';

  @override
  String get authButtonResendVerification => 'Resend link';

  @override
  String get authTurnstileRequired =>
      'Complete the security check before continuing.';

  @override
  String get authVerifyEmailConfirming => 'Confirming your email…';

  @override
  String get riotLoginCompleted => 'Riot login complete';

  @override
  String get riotCallbackTitle => 'Riot';

  @override
  String get riotGoToDashboard => 'Go to dashboard';

  @override
  String get riotGoToLogin => 'Go to log in';

  @override
  String get riotSessionTokensInUrl => 'Signed in with Riot (tokens in URL).';

  @override
  String get riotSessionCookies => 'Signed in with Riot (cookies).';

  @override
  String get riotSessionUpdated =>
      'Riot account authenticated; app session updated.';

  @override
  String get riotSessionViaExchange => 'WPGG session via Riot exchange.';

  @override
  String get riotIdentityError =>
      'The server couldn\'t get your Riot identity. Try signing in again.';

  @override
  String riotIdentityErrorWithDesc(String desc) {
    return 'The server couldn\'t get your Riot identity: $desc';
  }

  @override
  String get riotNoSessionAfterLogin => 'No session received after Riot login.';

  @override
  String get financeTitle => 'Finance';

  @override
  String get financeSubtitle => 'Token price and your wallet activity';

  @override
  String get financeYourBalance => 'Your balance';

  @override
  String get balanceLabel => 'Balance';

  @override
  String get financeFilterAll => 'All';

  @override
  String get financeFilterAllTransactions => 'All transactions';

  @override
  String get financeFilterIncome => 'Income';

  @override
  String get financeFilterExpense => 'Expense';

  @override
  String get financePriceHistory => '7-day price history';

  @override
  String get financeNoChartData => 'No chart data';

  @override
  String get financeNoTransactions => 'No transactions';

  @override
  String get tokenPriceUpdatedHint => 'Price in USD · updated every 60s';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get sidebarExpandMenu => 'Expand menu';

  @override
  String get sidebarCollapse => 'Collapse';

  @override
  String get addMissionButton => 'Add';

  @override
  String matchChampionFallback(int id) {
    return 'Champion $id';
  }

  @override
  String get matchWin => 'Victory';

  @override
  String get matchLoss => 'Defeat';

  @override
  String get timeAgoJustNow => 'just now';

  @override
  String timeAgoMinutes(int count) {
    return '$count min ago';
  }

  @override
  String timeAgoHours(int count) {
    return '$count h ago';
  }

  @override
  String timeAgoDays(int count) {
    return '$count d ago';
  }

  @override
  String rankedWinrate(String percent) {
    return 'Win rate $percent%';
  }

  @override
  String get queueRankedSolo => 'Solo/Duo';

  @override
  String get queueRankedFlex => 'Flex 5v5';

  @override
  String get queueRankedTft => 'Ranked TFT';

  @override
  String get queueArena => 'Arena';

  @override
  String get queueAram => 'ARAM';

  @override
  String get queueNormal => 'Normal';
}
