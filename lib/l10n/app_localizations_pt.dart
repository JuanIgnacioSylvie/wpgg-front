// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get hello => 'Olá!';

  @override
  String get profile => 'Perfil';

  @override
  String get logOut => 'Sair';

  @override
  String get language => 'Idioma';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get languageSpanish => 'Espanhol';

  @override
  String get languageFrench => 'Francês';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get welcomeMissionBadge => 'MISSÃO PRESENTE';

  @override
  String get welcomeMissionSection => 'Missão presente';

  @override
  String get inProgress => 'Em andamento';

  @override
  String missionDayResets(String date, String timezone) {
    return 'Dia de missão $date · reinicia às 00:00 $timezone';
  }

  @override
  String dayEndsIn(String time) {
    return 'O dia termina em: $time';
  }

  @override
  String get noActiveMissions =>
      'Nenhuma missão ativa ainda. Escolha até 3 para hoje!';

  @override
  String get pickMissions => 'Escolher missões';

  @override
  String get passMissions => 'Missões passadas';

  @override
  String get completedMissionsPlaceholder =>
      'As missões concluídas vão aparecer aqui.';

  @override
  String get noMissionsForDay => 'Nenhuma missão para este dia.';

  @override
  String get noMissionsForFilter => 'Nenhuma missão corresponde a este filtro.';

  @override
  String get errorLoadingMissions => 'Erro ao carregar missões';

  @override
  String get missionsByDays => 'Missões por dia';

  @override
  String get errorGeneric => 'Erro';

  @override
  String get filterAll => 'Todas';

  @override
  String get filterToDo => 'A fazer';

  @override
  String get filterInProgress => 'Em andamento';

  @override
  String get filterCompleted => 'Concluídas';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Média';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get statusCompleted => 'Concluída';

  @override
  String get statusIncomplete => 'Incompleta';

  @override
  String get statusInProgress => 'Em andamento';

  @override
  String get statusToDo => 'A fazer';

  @override
  String endsIn(String time) {
    return 'Termina em: $time';
  }

  @override
  String get pickMissionsTitle => 'Escolher missões';

  @override
  String get errorLoadingOffers => 'Erro ao carregar ofertas';

  @override
  String selectedMissionsCount(int count, int max, int maxHard) {
    return 'Selecionadas $count/$max (máx. $maxHard difícil)';
  }

  @override
  String get rerollMissionTitle => 'Trocar missão?';

  @override
  String rerollMissionBody(int cost) {
    return 'Isso vai custar $cost WPGG do seu saldo.';
  }

  @override
  String missionSpendBalanceHint(int balance) {
    return 'Saldo atual: $balance WPGG';
  }

  @override
  String get missionInsufficientBalance =>
      'Você não tem WPGG suficiente para esta ação';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reroll => 'Trocar';

  @override
  String get cancelMissionTitle => 'Excluir missão?';

  @override
  String cancelMissionBody(int cost) {
    return 'Isso vai custar $cost WPGG do seu saldo.';
  }

  @override
  String get deleteMission => 'Excluir';

  @override
  String get dropToDeleteMission => 'Solte aqui para excluir';

  @override
  String summonerLevel(int level) {
    return 'Nível $level';
  }

  @override
  String get linkRiotPrompt =>
      'Vincule sua conta Riot para ver as estatísticas.';

  @override
  String get linkRiotAfterLoginPrompt =>
      'Não conseguimos vincular sua conta LoL automaticamente. Complete os dados do invocador para ver as estatísticas.';

  @override
  String get linkRiotButton => 'Vincular conta Riot';

  @override
  String get completeRiotLinkButton => 'Completar vinculação manual';

  @override
  String get linkRiotSheetTitle => 'Vincular Riot';

  @override
  String get linkRiotSheetAction => 'Vincular';

  @override
  String get summonerNameLabel => 'Nome do invocador';

  @override
  String get tagLabel => 'Tag (#TAG sem #)';

  @override
  String get regionLabel => 'Região (ex. BR1)';

  @override
  String get myProfile => 'Meu perfil';

  @override
  String get withdraw => 'SACAR';

  @override
  String get generalNotification => 'Notificação geral';

  @override
  String get helpSupport => 'Ajuda e suporte';

  @override
  String get contactUs => 'Fale conosco';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get termsAndConditionsTitle => 'Termos e condições';

  @override
  String get withdrawTitle => 'Sacar WPGG';

  @override
  String withdrawMinHint(int amount) {
    return 'O saque mínimo é de $amount WPGG';
  }

  @override
  String get walletAddressLabel => 'Endereço da carteira Polygon';

  @override
  String get walletAddressRequired => 'O endereço da carteira é obrigatório';

  @override
  String get walletAddressInvalid =>
      'Digite um endereço Polygon válido (0x...)';

  @override
  String get withdrawAmountLabel => 'Valor (WPGG)';

  @override
  String get withdrawAmountInvalid => 'Digite um valor válido';

  @override
  String get withdrawInsufficientBalance => 'Saldo insuficiente';

  @override
  String get withdrawSuccess => 'Saque enviado com sucesso';

  @override
  String get withdrawError => 'Falha no saque. Tente de novo.';

  @override
  String get pageUnavailableTitle => 'Esta página não está disponível';

  @override
  String get pageUnavailableBody =>
      'Estamos trabalhando nisso. Volte mais tarde.';

  @override
  String get faqsMenuItem => 'Perguntas frequentes';

  @override
  String get faqsTitle => 'Perguntas frequentes';

  @override
  String get faqsIntro =>
      'Tudo o que você precisa saber sobre o WPGG — missões, recompensas, saques e muito mais.';

  @override
  String get faqWhatIsWpggQ => 'O que é o WPGG?';

  @override
  String get faqWhatIsWpggA =>
      'WPGG é uma plataforma de estatísticas de League of Legends que te recompensa por jogar. Complete missões diárias, ganhe tokens WPGG e troque por gift cards de Riot Points ou outras recompensas reais.';

  @override
  String get faqHowMissionsWorkQ => 'Como funcionam as missões?';

  @override
  String get faqHowMissionsWorkA =>
      'Todo dia você recebe um conjunto de missões: fácil, média e difícil. As fáceis são simples — jogue uma partida ou ganhe com um campeão específico. As médias e difíceis exigem melhor desempenho: bater um KDA certo, pegar X assistências, sequências de vitória e por aí vai. Complete a missão, ganhe tokens. É isso.';

  @override
  String get faqRerollQ => 'Posso trocar missões?';

  @override
  String get faqRerollA =>
      'Sim. Se uma missão não combina com você ou não dá para completar, você tem trocas diárias para trocar por outra aleatória do mesmo nível.';

  @override
  String get faqWithdrawQ => 'Como saco WPGG para minha carteira?';

  @override
  String get faqWithdrawA =>
      'Você precisa acumular no mínimo 1.000 WPGG para sacar. Quando chegar nesse valor, pode iniciar um saque na seção de finanças. Os tokens são transferidos para sua carteira na rede Polygon. Você precisa de uma carteira compatível (como MetaMask) e cobrir a taxa de transação — na Polygon é praticamente nada.';

  @override
  String get faqWhatCanIDoQ => 'O que posso fazer com WPGG?';

  @override
  String get faqWhatCanIDoA =>
      'Por enquanto você pode trocar na loja do app por gift cards de Riot Points. A ideia é que com o que você ganha em algumas semanas de jogo normal dá para comprar uma skin, presentear alguém ou pagar uma rodada com a galera. Não é para ficar rico — é uma recompensa de verdade pelo que você já faz.';

  @override
  String get faqTokenPriceQ => 'Quanto vale um WPGG?';

  @override
  String get faqTokenPriceA =>
      'O token negocia no mercado, então o preço varia. Mas o app não foi feito para especulação — foi feito para você usar. O valor real está em trocar por produtos concretos.';

  @override
  String get faqGetRichQ => 'O WPGG vai me deixar rico?';

  @override
  String get faqGetRichA =>
      'Não. E a gente fala isso na lata porque transparência faz parte do projeto. WPGG não é esquema de investimento nem jogo de especulação. É um sistema de recompensas com pool de liquidez fixo no QuickSwap (WPGG/USDC). O pool é o que é — não cresce magicamente, não tem promessa de retorno. O que você ganha jogando tem valor real e resgatável, mas não espere multiplicar seu dinheiro aqui.';

  @override
  String get faqTransparencyQ => 'É seguro? O projeto é transparente?';

  @override
  String get faqTransparencyA =>
      'Sim. O contrato do token WPGG está na Polygon Mainnet e é verificável publicamente no PolygonScan. O pool de liquidez está no QuickSwap. Tudo que sustenta o sistema está on-chain e qualquer um pode auditar. Sem caixa preta.';

  @override
  String get faqCryptoKnowledgeQ =>
      'Preciso entender de crypto para usar o app?';

  @override
  String get faqCryptoKnowledgeA =>
      'Para jogar missões e ganhar WPGG, você não precisa saber nada de crypto. A complexidade só aparece quando você quer sacar para a carteira — e mesmo assim o processo é guiado passo a passo dentro do app.';

  @override
  String get faqLoLAccountQ => 'Qual conta LoL eu conecto?';

  @override
  String get faqLoLAccountA =>
      'O app usa Riot Sign On (sistema oficial da Riot Games), então você entra com sua conta Riot direto. Não precisa nos passar senha nem nada disso — é o mesmo OAuth usado por apps como op.gg ou u.gg.';

  @override
  String get faqAvailabilityQ => 'O app está disponível no iOS e Android?';

  @override
  String get faqAvailabilityA =>
      'Está em desenvolvimento ativo no momento. Mais informações sobre disponibilidade em breve.';

  @override
  String get storeTitle => 'Loja';

  @override
  String get storeSubtitle => 'Troque seus WPGG por gift cards Riot.';

  @override
  String get storeBuy => 'Comprar';

  @override
  String get storePurchaseTitle => 'Confirmar compra';

  @override
  String storePurchaseBody(int cost, String product) {
    return 'Você vai gastar $cost WPGG em $product.';
  }

  @override
  String get storeComingSoon => 'Compras em breve.';

  @override
  String get storeOrderHistory => 'Suas compras';

  @override
  String get storeNoOrders => 'Você ainda não comprou nada na loja.';

  @override
  String get storePurchaseSuccessTitle => 'Compra feita!';

  @override
  String storePurchaseSuccessBody(int rp) {
    return 'Seu gift card de $rp RP está pronto. Guarde a chave em um lugar seguro.';
  }

  @override
  String get storeYourKey => 'Sua chave Riot';

  @override
  String get storeCopyKey => 'Copiar chave';

  @override
  String get storeKeyCopied => 'Chave copiada';

  @override
  String get storeDone => 'Pronto';

  @override
  String get storeOutOfStock => 'Este produto está fora de estoque.';

  @override
  String get storePurchaseError =>
      'Não foi possível concluir a compra. Tente de novo.';

  @override
  String get transactionProcessingAcceptMission => 'Aceitando missão…';

  @override
  String get transactionProcessingRerollMission => 'Trocando missão…';

  @override
  String get transactionProcessingCancelMission => 'Excluindo missão…';

  @override
  String get transactionProcessingPurchase => 'Processando compra…';

  @override
  String get transactionSuccessAcceptMission => 'Missão aceita';

  @override
  String get transactionSuccessRerollMission => 'Missão trocada';

  @override
  String get transactionSuccessCancelMission => 'Missão excluída';

  @override
  String get transactionFailedGeneric =>
      'Não foi possível concluir a ação. Tente de novo.';

  @override
  String get viewOnGeckoTerminal => 'Ver no GeckoTerminal';

  @override
  String get authLoginSwitchLine => 'Não tem conta?';

  @override
  String get authLoginSwitchLink => 'Cadastre-se aqui!';

  @override
  String get authRegisterSwitchLine => 'Já tem conta?';

  @override
  String get authRegisterSwitchLink => 'Entre aqui!';

  @override
  String get authSwitchLinkPrefix => 'Você pode ';

  @override
  String get riotNotFoundTitle => 'Conta não encontrada.';

  @override
  String get riotNotFoundBody =>
      'Não encontramos uma conta WPGG vinculada a esse Riot ID. Cadastre-se no WPGG primeiro.';

  @override
  String get riotNotFoundRegister => 'Cadastrar';

  @override
  String get riotAlreadyExistsTitle => 'Você já tem uma conta.';

  @override
  String get riotAlreadyExistsBody =>
      'Já existe uma conta WPGG vinculada a este Riot ID. Entre com Riot ou e-mail.';

  @override
  String get riotAlreadyExistsSignInRiot => 'Entrar com Riot';

  @override
  String get linkRiotBody =>
      'Vincule sua conta Riot Games para concluir o cadastro.';

  @override
  String get authLabelEmail => 'E-mail';

  @override
  String get authHintEmail => 'Digite seu e-mail';

  @override
  String get authLabelPassword => 'Senha';

  @override
  String get authHintPassword => 'Digite sua senha';

  @override
  String get authLabelConfirmPassword => 'Confirmar senha';

  @override
  String get authHintConfirmPassword => 'Confirme sua senha';

  @override
  String get authRememberMe => 'Lembrar de mim';

  @override
  String get authForgotPassword => 'Esqueceu a senha?';

  @override
  String get authButtonLogin => 'Entrar';

  @override
  String get authButtonRegister => 'Cadastrar';

  @override
  String get authRiotFooter => 'ou continuar com';

  @override
  String get authPasswordsMismatch => 'As senhas não coincidem';

  @override
  String get authForgotPasswordBody =>
      'Digite seu e-mail e enviaremos um link de redefinição.';

  @override
  String get authForgotPasswordSuccess =>
      'Se existir uma conta, enviamos um link de redefinição.';

  @override
  String get authButtonSendResetLink => 'Enviar link';

  @override
  String get authBackToLogin => 'Voltar ao login';

  @override
  String get authResetPasswordTitle => 'Nova senha';

  @override
  String get authResetPasswordBody => 'Escolha uma nova senha para sua conta.';

  @override
  String get authButtonResetPassword => 'Redefinir senha';

  @override
  String get authResetPasswordSuccess =>
      'Senha atualizada. Você já pode entrar.';

  @override
  String get authResetPasswordInvalidLink =>
      'Link inválido ou expirado. Peça um novo no login.';

  @override
  String get authVerifyEmailTitle => 'Confirme seu e-mail';

  @override
  String get authVerifyEmailBody =>
      'Enviamos um link para seu e-mail. Abra para ativar sua conta.';

  @override
  String get authVerifyEmailResent =>
      'Se a conta existir e não estiver verificada, reenviamos o link.';

  @override
  String get authVerifyEmailSuccess => 'E-mail confirmado. Bem-vindo ao WPGG!';

  @override
  String get authVerifyEmailInvalidLink =>
      'Link inválido ou expirado. Peça um novo no cadastro.';

  @override
  String get authButtonResendVerification => 'Reenviar link';

  @override
  String get authTurnstileRequired =>
      'Complete a verificação de segurança antes de continuar.';

  @override
  String get authVerifyEmailConfirming => 'Confirmando seu e-mail…';

  @override
  String get riotLoginCompleted => 'Login Riot concluído';

  @override
  String get riotCallbackTitle => 'Riot';

  @override
  String get riotGoToDashboard => 'Ir para o painel';

  @override
  String get riotGoToLogin => 'Ir para o login';

  @override
  String get riotSessionTokensInUrl => 'Conectado com Riot (tokens na URL).';

  @override
  String get riotSessionCookies => 'Conectado com Riot (cookies).';

  @override
  String get riotSessionUpdated =>
      'Conta Riot autenticada; sessão do app atualizada.';

  @override
  String get riotSessionViaExchange => 'Sessão WPGG via troca Riot.';

  @override
  String get riotIdentityError =>
      'O servidor não conseguiu obter sua identidade Riot. Tente entrar de novo.';

  @override
  String riotIdentityErrorWithDesc(String desc) {
    return 'O servidor não conseguiu obter sua identidade Riot: $desc';
  }

  @override
  String get riotNoSessionAfterLogin =>
      'Nenhuma sessão recebida após o login Riot.';

  @override
  String get financeTitle => 'Finanças';

  @override
  String get financeSubtitle => 'Preço do token e atividade da sua carteira';

  @override
  String get financeYourBalance => 'Seu saldo';

  @override
  String get balanceLabel => 'Saldo';

  @override
  String get financeFilterAll => 'Tudo';

  @override
  String get financeFilterAllTransactions => 'Todas as transações';

  @override
  String get financeFilterIncome => 'Entradas';

  @override
  String get financeFilterExpense => 'Saídas';

  @override
  String get financePriceHistory => 'Histórico de preço em 7 dias';

  @override
  String get financeNoChartData => 'Sem dados no gráfico';

  @override
  String get financeNoTransactions => 'Nenhuma transação';

  @override
  String get tokenPriceUpdatedHint => 'Preço em USD · atualizado a cada 60s';

  @override
  String get navDashboard => 'Painel';

  @override
  String get navNotifications => 'Notificações';

  @override
  String get sidebarExpandMenu => 'Expandir menu';

  @override
  String get sidebarCollapse => 'Recolher';

  @override
  String get addMissionButton => 'Adicionar';

  @override
  String matchChampionFallback(int id) {
    return 'Campeão $id';
  }

  @override
  String get matchWin => 'Vitória';

  @override
  String get matchLoss => 'Derrota';

  @override
  String get timeAgoJustNow => 'agora';

  @override
  String timeAgoMinutes(int count) {
    return 'há $count min';
  }

  @override
  String timeAgoHours(int count) {
    return 'há $count h';
  }

  @override
  String timeAgoDays(int count) {
    return 'há $count d';
  }

  @override
  String rankedWinrate(String percent) {
    return 'Taxa de vitória $percent%';
  }

  @override
  String get queueRankedSolo => 'Solo/Duo';

  @override
  String get queueRankedFlex => 'Flex 5v5';

  @override
  String get queueRankedTft => 'Ranqueada TFT';

  @override
  String get queueArena => 'Arena';

  @override
  String get queueAram => 'ARAM';

  @override
  String get queueNormal => 'Normal';
}
