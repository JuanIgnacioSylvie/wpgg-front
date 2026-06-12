// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get hello => 'Bonjour !';

  @override
  String get profile => 'Profil';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get language => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageSpanish => 'Espagnol';

  @override
  String get languageFrench => 'Français';

  @override
  String get languagePortuguese => 'Portugais';

  @override
  String get retry => 'Réessayer';

  @override
  String get welcomeMissionBadge => 'MISSION CADEAU';

  @override
  String get welcomeMissionSection => 'Mission cadeau';

  @override
  String get inProgress => 'En cours';

  @override
  String missionDayResets(String date, String timezone) {
    return 'Jour de mission $date · réinitialisation à 00:00 $timezone';
  }

  @override
  String dayEndsIn(String time) {
    return 'Le jour se termine dans : $time';
  }

  @override
  String get noActiveMissions =>
      'Aucune mission active pour le moment. Choisissez jusqu\'à 3 pour aujourd\'hui !';

  @override
  String get pickMissions => 'Choisir des missions';

  @override
  String get passMissions => 'Missions passées';

  @override
  String get completedMissionsPlaceholder =>
      'Les missions terminées apparaîtront ici.';

  @override
  String get noMissionsForDay => 'Aucune mission pour ce jour.';

  @override
  String get noMissionsForFilter => 'Aucune mission ne correspond à ce filtre.';

  @override
  String get errorLoadingMissions => 'Erreur lors du chargement des missions';

  @override
  String get missionsByDays => 'Missions par jour';

  @override
  String get errorGeneric => 'Erreur';

  @override
  String get filterAll => 'Toutes';

  @override
  String get filterToDo => 'À faire';

  @override
  String get filterInProgress => 'En cours';

  @override
  String get filterCompleted => 'Terminées';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyMedium => 'Moyenne';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get statusCompleted => 'Terminée';

  @override
  String get statusIncomplete => 'Incomplète';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusToDo => 'À faire';

  @override
  String endsIn(String time) {
    return 'Se termine dans : $time';
  }

  @override
  String get pickMissionsTitle => 'Choisir des missions';

  @override
  String get errorLoadingOffers => 'Erreur lors du chargement des offres';

  @override
  String selectedMissionsCount(int count, int max, int maxHard) {
    return 'Sélectionnées $count/$max (max. $maxHard difficile)';
  }

  @override
  String get rerollMissionTitle => 'Changer de mission ?';

  @override
  String rerollMissionBody(int cost) {
    return 'Cela coûtera $cost WPGG de votre solde.';
  }

  @override
  String missionSpendBalanceHint(int balance) {
    return 'Solde actuel : $balance WPGG';
  }

  @override
  String get missionInsufficientBalance =>
      'Vous n\'avez pas assez de WPGG pour cette action';

  @override
  String get cancel => 'Annuler';

  @override
  String get reroll => 'Changer';

  @override
  String get cancelMissionTitle => 'Supprimer la mission ?';

  @override
  String cancelMissionBody(int cost) {
    return 'Cela coûtera $cost WPGG de votre solde.';
  }

  @override
  String get deleteMission => 'Supprimer';

  @override
  String get dropToDeleteMission => 'Déposez ici pour supprimer';

  @override
  String summonerLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String get linkRiotPrompt =>
      'Liez votre compte Riot pour voir vos statistiques.';

  @override
  String get linkRiotAfterLoginPrompt =>
      'Nous n\'avons pas pu lier votre compte LoL automatiquement. Complétez les détails de votre invocateur pour voir vos statistiques.';

  @override
  String get linkRiotButton => 'Lier le compte Riot';

  @override
  String get completeRiotLinkButton => 'Compléter la liaison manuelle';

  @override
  String get linkRiotSheetTitle => 'Lier Riot';

  @override
  String get linkRiotSheetAction => 'Lier';

  @override
  String get summonerNameLabel => 'Nom d\'invocateur';

  @override
  String get tagLabel => 'Tag (#TAG sans #)';

  @override
  String get regionLabel => 'Région (ex. LA2)';

  @override
  String get myProfile => 'Mon profil';

  @override
  String get withdraw => 'RETIRER';

  @override
  String get generalNotification => 'Notification générale';

  @override
  String get helpSupport => 'Aide et support';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsAndConditionsTitle => 'Conditions générales';

  @override
  String get withdrawTitle => 'Retirer des WPGG';

  @override
  String withdrawMinHint(int amount) {
    return 'Le retrait minimum est de $amount WPGG';
  }

  @override
  String get walletAddressLabel => 'Adresse du portefeuille Polygon';

  @override
  String get walletAddressRequired => 'L\'adresse du portefeuille est requise';

  @override
  String get walletAddressInvalid =>
      'Saisissez une adresse Polygon valide (0x...)';

  @override
  String get withdrawAmountLabel => 'Montant (WPGG)';

  @override
  String get withdrawAmountInvalid => 'Saisissez un montant valide';

  @override
  String get withdrawInsufficientBalance => 'Solde insuffisant';

  @override
  String get withdrawSuccess => 'Retrait soumis avec succès';

  @override
  String get withdrawError => 'Échec du retrait. Veuillez réessayer.';

  @override
  String get pageUnavailableTitle => 'Cette page n\'est pas disponible';

  @override
  String get pageUnavailableBody => 'Nous y travaillons. Revenez plus tard.';

  @override
  String get faqsMenuItem => 'FAQ';

  @override
  String get faqsTitle => 'Questions fréquentes';

  @override
  String get faqsIntro =>
      'Tout ce que vous devez savoir sur WPGG — missions, récompenses, retraits et plus encore.';

  @override
  String get faqWhatIsWpggQ => 'Qu\'est-ce que WPGG ?';

  @override
  String get faqWhatIsWpggA =>
      'WPGG est une plateforme de statistiques League of Legends qui vous récompense pour jouer. Complétez des missions quotidiennes, gagnez des jetons WPGG et échangez-les contre des cartes cadeaux Riot Points ou d\'autres récompenses réelles.';

  @override
  String get faqHowMissionsWorkQ => 'Comment fonctionnent les missions ?';

  @override
  String get faqHowMissionsWorkA =>
      'Chaque jour, vous recevez un ensemble de missions : facile, moyenne et difficile. Les faciles sont simples — jouez une partie ou gagnez avec un champion précis. Les missions moyennes et difficiles exigent de meilleures performances : atteindre un certain KDA, obtenir X assists, des séries de victoires, etc. Complétez la mission, gagnez des jetons. C\'est tout.';

  @override
  String get faqRerollQ => 'Puis-je changer de mission ?';

  @override
  String get faqRerollA =>
      'Oui. Si une mission ne vous convient pas ou si vous ne pouvez pas la terminer, vous disposez de changements quotidiens pour l\'échanger contre une autre aléatoire du même niveau.';

  @override
  String get faqWithdrawQ => 'Comment retirer des WPGG vers mon portefeuille ?';

  @override
  String get faqWithdrawA =>
      'Vous devez accumuler un minimum de 1 000 WPGG pour retirer. Une fois ce seuil atteint, vous pouvez lancer un retrait depuis la section finance. Les jetons sont transférés vers votre portefeuille sur le réseau Polygon. Vous avez besoin d\'un portefeuille compatible (comme MetaMask) et de couvrir les frais de transaction — sur Polygon, c\'est pratiquement rien.';

  @override
  String get faqWhatCanIDoQ => 'Que puis-je faire avec des WPGG ?';

  @override
  String get faqWhatCanIDoA =>
      'Pour l\'instant, vous pouvez les échanger dans la boutique intégrée contre des cartes cadeaux Riot Points. L\'idée est qu\'avec ce que vous gagnez en quelques semaines de jeu normal, vous pouvez acheter un skin, faire plaisir à votre partenaire ou prendre des bières entre amis. Ce n\'est pas pour devenir riche — c\'est une vraie récompense pour ce que vous faites déjà.';

  @override
  String get faqTokenPriceQ => 'Combien vaut un WPGG ?';

  @override
  String get faqTokenPriceA =>
      'Le jeton s\'échange sur le marché, donc le prix varie. Mais l\'application n\'est pas conçue pour la spéculation — elle est faite pour être utilisée. La vraie valeur réside dans l\'échange contre des produits concrets.';

  @override
  String get faqGetRichQ => 'Est-ce que WPGG va me rendre riche ?';

  @override
  String get faqGetRichA =>
      'Non. Et nous le disons clairement, car la transparence fait partie du projet. WPGG n\'est ni un système d\'investissement ni un jeu de spéculation. C\'est un système de récompenses adossé à un pool de liquidité fixe sur QuickSwap (WPGG/USDC). Le pool est ce qu\'il est — il ne grandit pas comme par magie, il n\'y a aucune promesse de rendement. Ce que vous gagnez en jouant a une valeur réelle et échangeable, mais n\'attendez pas de multiplier votre argent ici.';

  @override
  String get faqTransparencyQ => 'Est-ce sûr ? Le projet est-il transparent ?';

  @override
  String get faqTransparencyA =>
      'Oui. Le contrat du jeton WPGG est déployé sur Polygon Mainnet et est vérifiable publiquement sur PolygonScan. Le pool de liquidité est sur QuickSwap. Tout ce qui soutient le système est on-chain et n\'importe qui peut l\'auditer. Pas de boîte noire.';

  @override
  String get faqCryptoKnowledgeQ =>
      'Dois-je connaître la crypto pour utiliser l\'application ?';

  @override
  String get faqCryptoKnowledgeA =>
      'Pour jouer des missions et gagner des WPGG, vous n\'avez besoin de rien savoir sur la crypto. La complexité n\'apparaît que lorsque vous voulez retirer vers votre portefeuille — et même là, le processus est guidé étape par étape dans l\'application.';

  @override
  String get faqLoLAccountQ => 'Quel compte LoL dois-je connecter ?';

  @override
  String get faqLoLAccountA =>
      'L\'application utilise Riot Sign On (le système officiel de Riot Games), vous vous connectez donc directement avec votre compte Riot. Vous n\'avez pas besoin de nous donner votre mot de passe ou quoi que ce soit de similaire — c\'est le même OAuth utilisé par des applications comme op.gg ou u.gg.';

  @override
  String get faqAvailabilityQ =>
      'L\'application est-elle disponible sur iOS et Android ?';

  @override
  String get faqAvailabilityA =>
      'Elle est actuellement en développement actif. Plus d\'informations sur la disponibilité bientôt.';

  @override
  String get storeTitle => 'Boutique';

  @override
  String get storeSubtitle =>
      'Échangez vos WPGG contre des cartes cadeaux Riot.';

  @override
  String get storeBuy => 'Acheter';

  @override
  String get storePurchaseTitle => 'Confirmer l\'achat';

  @override
  String storePurchaseBody(int cost, String product) {
    return 'Vous dépenserez $cost WPGG pour $product.';
  }

  @override
  String get storeComingSoon => 'Les achats seront bientôt disponibles.';

  @override
  String get storeOrderHistory => 'Vos achats';

  @override
  String get storeNoOrders =>
      'Vous n\'avez encore rien acheté dans la boutique.';

  @override
  String get storePurchaseSuccessTitle => 'Achat réussi !';

  @override
  String storePurchaseSuccessBody(int rp) {
    return 'Votre carte cadeau de $rp RP est prête. Conservez la clé en lieu sûr.';
  }

  @override
  String get storeYourKey => 'Votre clé Riot';

  @override
  String get storeCopyKey => 'Copier la clé';

  @override
  String get storeKeyCopied => 'Clé copiée dans le presse-papiers';

  @override
  String get storeDone => 'Terminé';

  @override
  String get storeOutOfStock => 'Ce produit est en rupture de stock.';

  @override
  String get storePurchaseError =>
      'Impossible de finaliser l\'achat. Veuillez réessayer.';

  @override
  String get transactionProcessingAcceptMission => 'Acceptation de la mission…';

  @override
  String get transactionProcessingRerollMission => 'Changement de mission…';

  @override
  String get transactionProcessingCancelMission => 'Suppression de la mission…';

  @override
  String get transactionProcessingPurchase => 'Traitement de l\'achat…';

  @override
  String get transactionSuccessAcceptMission => 'Mission acceptée';

  @override
  String get transactionSuccessRerollMission => 'Mission changée';

  @override
  String get transactionSuccessCancelMission => 'Mission supprimée';

  @override
  String get transactionFailedGeneric =>
      'L\'action n\'a pas pu être effectuée. Veuillez réessayer.';

  @override
  String get viewOnGeckoTerminal => 'Voir sur GeckoTerminal';

  @override
  String get authLoginSwitchLine => 'Vous n\'avez pas de compte ?';

  @override
  String get authLoginSwitchLink => 'Inscrivez-vous ici !';

  @override
  String get authRegisterSwitchLine => 'Vous avez déjà un compte ?';

  @override
  String get authRegisterSwitchLink => 'Connectez-vous ici !';

  @override
  String get authSwitchLinkPrefix => 'Vous pouvez ';

  @override
  String get riotNotFoundTitle => 'Compte introuvable.';

  @override
  String get riotNotFoundBody =>
      'Nous n\'avons pas trouvé de compte WPGG lié à cet identifiant Riot. Inscrivez-vous d\'abord sur WPGG.';

  @override
  String get riotNotFoundRegister => 'S\'inscrire';

  @override
  String get riotAlreadyExistsTitle => 'Vous avez déjà un compte.';

  @override
  String get riotAlreadyExistsBody =>
      'Un compte WPGG est déjà lié à cet identifiant Riot. Connectez-vous avec Riot ou par e-mail.';

  @override
  String get riotAlreadyExistsSignInRiot => 'Se connecter avec Riot';

  @override
  String get linkRiotBody =>
      'Liez votre compte Riot Games pour terminer l\'inscription.';

  @override
  String get authLabelEmail => 'E-mail';

  @override
  String get authHintEmail => 'Saisissez votre e-mail';

  @override
  String get authLabelPassword => 'Mot de passe';

  @override
  String get authHintPassword => 'Saisissez votre mot de passe';

  @override
  String get authLabelConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authHintConfirmPassword => 'Confirmez votre mot de passe';

  @override
  String get authRememberMe => 'Se souvenir de moi';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authButtonLogin => 'Se connecter';

  @override
  String get authButtonRegister => 'S\'inscrire';

  @override
  String get authRiotFooter => 'ou continuer avec';

  @override
  String get authPasswordsMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get authForgotPasswordBody =>
      'Saisissez votre e-mail et nous vous enverrons un lien de réinitialisation.';

  @override
  String get authForgotPasswordSuccess =>
      'Si un compte existe, nous avons envoyé un lien de réinitialisation.';

  @override
  String get authButtonSendResetLink => 'Envoyer le lien';

  @override
  String get authBackToLogin => 'Retour à la connexion';

  @override
  String get authResetPasswordTitle => 'Nouveau mot de passe';

  @override
  String get authResetPasswordBody =>
      'Choisissez un nouveau mot de passe pour votre compte.';

  @override
  String get authButtonResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get authResetPasswordSuccess =>
      'Mot de passe mis à jour. Vous pouvez vous connecter maintenant.';

  @override
  String get authResetPasswordInvalidLink =>
      'Lien invalide ou expiré. Demandez-en un nouveau depuis la connexion.';

  @override
  String get authVerifyEmailTitle => 'Confirmez votre e-mail';

  @override
  String get authVerifyEmailBody =>
      'Nous avons envoyé un lien à votre e-mail. Ouvrez-le pour activer votre compte.';

  @override
  String get authVerifyEmailResent =>
      'Si le compte existe et n\'est pas vérifié, nous avons renvoyé le lien.';

  @override
  String get authVerifyEmailSuccess => 'E-mail confirmé. Bienvenue sur WPGG !';

  @override
  String get authVerifyEmailInvalidLink =>
      'Lien invalide ou expiré. Demandez-en un nouveau depuis l\'inscription.';

  @override
  String get authButtonResendVerification => 'Renvoyer le lien';

  @override
  String get authTurnstileRequired =>
      'Complétez la vérification de sécurité avant de continuer.';

  @override
  String get authVerifyEmailConfirming => 'Confirmation de votre e-mail…';

  @override
  String get riotLoginCompleted => 'Connexion Riot terminée';

  @override
  String get riotCallbackTitle => 'Riot';

  @override
  String get riotGoToDashboard => 'Aller au tableau de bord';

  @override
  String get riotGoToLogin => 'Aller à la connexion';

  @override
  String get riotSessionTokensInUrl =>
      'Connecté avec Riot (jetons dans l\'URL).';

  @override
  String get riotSessionCookies => 'Connecté avec Riot (cookies).';

  @override
  String get riotSessionUpdated =>
      'Compte Riot authentifié ; session de l\'application mise à jour.';

  @override
  String get riotSessionViaExchange => 'Session WPGG via échange Riot.';

  @override
  String get riotIdentityError =>
      'Le serveur n\'a pas pu obtenir votre identité Riot. Réessayez de vous connecter.';

  @override
  String riotIdentityErrorWithDesc(String desc) {
    return 'Le serveur n\'a pas pu obtenir votre identité Riot : $desc';
  }

  @override
  String get riotNoSessionAfterLogin =>
      'Aucune session reçue après la connexion Riot.';

  @override
  String get financeTitle => 'Finance';

  @override
  String get financeSubtitle =>
      'Prix du jeton et activité de votre portefeuille';

  @override
  String get financeYourBalance => 'Votre solde';

  @override
  String get balanceLabel => 'Solde';

  @override
  String get financeFilterAll => 'Tout';

  @override
  String get financeFilterAllTransactions => 'Toutes les transactions';

  @override
  String get financeFilterIncome => 'Revenus';

  @override
  String get financeFilterExpense => 'Dépenses';

  @override
  String get financePriceHistory => 'Historique des prix sur 7 jours';

  @override
  String get financeNoChartData => 'Aucune donnée de graphique';

  @override
  String get financeNoTransactions => 'Aucune transaction';

  @override
  String get tokenPriceUpdatedHint =>
      'Prix en USD · mis à jour toutes les 60 s';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get notificationsInboxEmpty => 'Aucune notification pour le moment';

  @override
  String get notificationsMarkAllRead => 'Tout marquer comme lu';

  @override
  String get sidebarExpandMenu => 'Développer le menu';

  @override
  String get sidebarCollapse => 'Réduire';

  @override
  String get addMissionButton => 'Ajouter';

  @override
  String matchChampionFallback(int id) {
    return 'Champion $id';
  }

  @override
  String get matchWin => 'Victoire';

  @override
  String get matchLoss => 'Défaite';

  @override
  String get timeAgoJustNow => 'à l\'instant';

  @override
  String timeAgoMinutes(int count) {
    return 'il y a $count min';
  }

  @override
  String timeAgoHours(int count) {
    return 'il y a $count h';
  }

  @override
  String timeAgoDays(int count) {
    return 'il y a $count j';
  }

  @override
  String rankedWinrate(String percent) {
    return 'Taux de victoire $percent%';
  }

  @override
  String get queueRankedSolo => 'Solo/Duo';

  @override
  String get queueRankedFlex => 'Flex 5v5';

  @override
  String get queueRankedTft => 'Classé TFT';

  @override
  String get queueArena => 'Arène';

  @override
  String get queueAram => 'ARAM';

  @override
  String get queueNormal => 'Normal';

  @override
  String get landingNavMissions => 'Missions';

  @override
  String get landingNavCoin => 'La Coin';

  @override
  String get landingNavSponsors => 'Sponsors';

  @override
  String get landingNavLogin => 'Connexion';

  @override
  String get landingNavGetStarted => 'Commencer';

  @override
  String get landingHeroTitle =>
      'Jouez à League of Legends.\nGagnez des WPGG. Échangez contre des RP ou retirez.';

  @override
  String get landingHeroSubtitle =>
      'WPGG est une plateforme de missions quotidiennes LoL avec de vraies récompenses. Pas de promesses magiques, pas de boîte noire — tout est adossé à un pool fixe vérifiable on-chain.';

  @override
  String get landingCtaCreateAccount => 'Créer un compte gratuit';

  @override
  String get landingCtaHowItWorks => 'Comment ça marche';

  @override
  String get landingWhatTitle => 'Qu\'est-ce que WPGG ?';

  @override
  String landingWhatSubtitle(String tagline) {
    return '$tagline — des stats LoL qui vous récompensent pour jouer.';
  }

  @override
  String get landingWhatBody =>
      'Complétez des missions quotidiennes basées sur votre activité en classée, accumulez des tokens WPGG et utilisez-les en boutique pour des cartes cadeaux Riot Points ou retirez-les vers votre wallet. Un système de récompenses pensé pour les joueurs, pas pour les spéculateurs.';

  @override
  String get landingWhatBullet1 => 'Liez votre compte Riot en toute sécurité';

  @override
  String get landingWhatBullet2 =>
      'Choisissez des missions faciles, moyennes ou difficiles chaque jour';

  @override
  String get landingWhatBullet3 =>
      'Gagnez des WPGG en les complétant — sans astuces ni petites lignes cachées';

  @override
  String get landingMissionsTitle => 'Missions quotidiennes';

  @override
  String get landingMissionsSubtitle =>
      'Jouez comme d\'habitude. Gagnez de vraies récompenses.';

  @override
  String get landingMissionsBody =>
      'Chaque jour, un ensemble de missions : des choses simples comme jouer une partie, jusqu\'à des défis de performance comme atteindre un KDA ou enchaîner les victoires. Choisissez celles qui vous conviennent, complétez-les en classée et encaissez.';

  @override
  String get landingMissionsBullet1 =>
      'Facile, moyen et difficile — vous choisissez le risque';

  @override
  String get landingMissionsBullet2 =>
      'Relancez les missions qui ne vous plaisent pas (coût en WPGG)';

  @override
  String get landingMissionsBullet3 =>
      'Les récompenses varient selon la difficulté — pas d\'inflation infinie';

  @override
  String get landingCoinTitle => 'La WPGG Coin';

  @override
  String get landingCoinSubtitle => 'Transparence totale. Pas de boîte noire.';

  @override
  String get landingCoinBody =>
      'Le token WPGG est déployé sur Polygon Mainnet et auditable sur PolygonScan. La liquidité est adossée à un pool fixe sur QuickSwap (paire WPGG/USDC) : ce que vous voyez est ce que vous obtenez — il ne grandit pas magiquement et ne promet pas de rendements infinis.';

  @override
  String get landingCoinBullet1 => 'Contrat vérifiable publiquement on-chain';

  @override
  String get landingCoinBullet2 =>
      'Pool fixe sur QuickSwap — liquidité réelle, pas de promesses';

  @override
  String get landingCoinBullet3 =>
      'Vous pouvez inspecter le pool et tout auditer vous-même';

  @override
  String get landingCoinHighlightTitle => 'Pool fixe, attentes claires';

  @override
  String get landingCoinHighlightBody =>
      'Le pool de liquidité a une taille fixe. Le système est honnête sur ce qu\'il peut offrir : des récompenses réelles et échangeables — pas un schème pour devenir riche en farmant des parties.';

  @override
  String get landingNotRichTitle => 'Vous ne deviendrez pas riche';

  @override
  String get landingNotRichSubtitle =>
      'On le dit clairement, car l\'honnêteté fait partie du projet.';

  @override
  String get landingNotRichBody =>
      'WPGG n\'est pas un jeu d\'investissement ni un schème de farming infini. Personne ne devient riche en complétant des missions. C\'est pour acheter des RP en boutique avec vos tokens, ou retirer vos coins pour offrir des fleurs ou prendre une bière entre amis.';

  @override
  String get landingNotRichBullet1 =>
      'Récompenses modestes et réelles — assez pour des RP ou un petit plaisir';

  @override
  String get landingNotRichBullet2 =>
      'Pas de promesse de multiplier l\'argent ni de rendements garantis';

  @override
  String get landingNotRichBullet3 =>
      'Si vous cherchez à spéculer, ce n\'est pas votre place (et c\'est OK)';

  @override
  String get landingUseTitle => 'Que faire avec vos WPGG ?';

  @override
  String get landingUseSubtitle => 'Utilisez-les dans l\'app ou sortez-les.';

  @override
  String get landingUseBody =>
      'Vos tokens ont une utilité concrète dans et hors de WPGG.';

  @override
  String get landingUseBullet1 =>
      'Acheter des cartes cadeaux Riot Points dans la boutique WPGG';

  @override
  String get landingUseBullet2 =>
      'Retirer des WPGG vers votre wallet personnel sur Polygon';

  @override
  String get landingUseBullet3 =>
      'Les dépenser comme vous voulez : bière, fleurs, etc.';

  @override
  String get landingStepsTitle => 'Commencez en 4 étapes';

  @override
  String get landingStep1Title => 'Créez votre compte';

  @override
  String get landingStep1Body =>
      'Inscrivez-vous par email ou connectez-vous avec votre compte Riot.';

  @override
  String get landingStep2Title => 'Choisissez vos missions';

  @override
  String get landingStep2Body =>
      'Sélectionnez le set du jour selon votre temps et votre niveau.';

  @override
  String get landingStep3Title => 'Jouez en classée';

  @override
  String get landingStep3Body =>
      'Les missions sont validées avec vos vraies parties.';

  @override
  String get landingStep4Title => 'Gagnez et échangez';

  @override
  String get landingStep4Body =>
      'Accumulez des WPGG, achetez des RP ou retirez vers votre wallet.';

  @override
  String get landingSponsorsTitle => 'Vous voulez soutenir le projet ?';

  @override
  String get landingSponsorsBody =>
      'Nous cherchons des sponsors et partenaires pour rejoindre une communauté de joueurs LoL avec un modèle transparent. Si vous avez une proposition de collaboration, activation ou branding, écrivez-nous.';

  @override
  String get landingFaqTitle => 'Questions fréquentes';

  @override
  String get landingFaqBody =>
      'Besoin d\'en savoir plus sur les missions, les retraits ou le token ? Nous avons une section FAQ complète dans l\'app.';

  @override
  String get landingFaqLink => 'Voir toutes les FAQs →';

  @override
  String get landingFooterTerms => 'Conditions';

  @override
  String get landingFooterFaqs => 'FAQs';

  @override
  String get landingFooterLogin => 'Connexion';

  @override
  String get landingFooterRegister => 'S\'inscrire';

  @override
  String get landingFooterCoinMarketCap => 'CoinMarketCap';

  @override
  String get landingFooterDisclaimer =>
      'WPGG n\'est pas affilié, associé ou approuvé par Riot Games, Inc. League of Legends et Riot Games sont des marques de Riot Games, Inc.';

  @override
  String landingFooterCopyright(int year) {
    return '© $year WPGG. Tous droits réservés.';
  }

  @override
  String get landingSponsorSentTitle => 'Proposition envoyée';

  @override
  String get landingSponsorSentBody =>
      'Merci pour votre intérêt à soutenir WPGG. Nous examinons chaque proposition et vous répondrons bientôt.';

  @override
  String get landingSponsorThanksSnackbar =>
      'Merci ! Nous avons reçu votre proposition et vous contacterons.';

  @override
  String get landingSponsorCompanyLabel => 'Entreprise ou marque';

  @override
  String get landingSponsorCompanyHint => 'Votre organisation';

  @override
  String get landingSponsorCompanyError =>
      'Entrez le nom de votre entreprise ou marque';

  @override
  String get landingSponsorEmailLabel => 'Email de contact';

  @override
  String get landingSponsorEmailHint => 'bonjour@votreentreprise.com';

  @override
  String get landingSponsorEmailError => 'Entrez un email valide';

  @override
  String get landingSponsorMessageLabel => 'Votre proposition';

  @override
  String get landingSponsorMessageHint =>
      'Dites-nous quel type de collaboration vous envisagez : activation, prix, branding, etc.';

  @override
  String get landingSponsorMessageError =>
      'Dites-nous un peu plus sur votre proposition (min. 20 caractères)';

  @override
  String get landingSponsorSubmit => 'Envoyer la proposition';

  @override
  String get landingSponsorTurnstileRequired =>
      'Complétez la vérification de sécurité avant d\'envoyer.';

  @override
  String get landingSponsorSubmitError =>
      'Impossible d\'envoyer votre proposition. Réessayez.';
}
