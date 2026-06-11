import '../domain/legal_section.dart';

abstract final class TermsContentPt {
  static const List<LegalSection> sections = [
    LegalSection(
      title: '1. Aceitação dos termos',
      paragraphs: [
        'Ao acessar ou utilizar a plataforma WPGG (a "Plataforma"), incluindo o aplicativo móvel, o site e todos os serviços associados, você concorda em ficar vinculado a estes Termos e Condições. Se você não concordar com algum destes termos, não deverá utilizar a Plataforma.',
      ],
    ),
    LegalSection(
      title: '2. Descrição do serviço',
      paragraphs: [
        'WPGG é uma plataforma independente de estatísticas e gamificação para League of Legends. Por meio da Plataforma, os usuários podem:',
        'WPGG não é um jogo de azar, um esquema de investimento nem um produto financeiro. É um sistema de recompensas vinculado à atividade de jogo do usuário.',
      ],
      bullets: [
        'Visualizar estatísticas de suas partidas de League of Legends.',
        'Completar missões diárias com base em seu desempenho no jogo.',
        'Acumular tokens WPGG como recompensa por completar missões.',
        'Sacar tokens WPGG para uma carteira compatível com a rede Polygon.',
        'Resgatar tokens WPGG por produtos disponíveis na loja interna da Plataforma.',
      ],
    ),
    LegalSection(
      title: '3. Elegibilidade',
      paragraphs: [
        'Para utilizar a Plataforma, o usuário deve:',
        'WPGG não é afiliada, patrocinada nem endossada pela Riot Games, Inc.',
      ],
      bullets: [
        'Ter pelo menos 18 anos de idade, ou a maioridade legal em sua jurisdição.',
        'Possuir uma conta ativa da Riot Games e aceitar os Termos de Serviço da Riot.',
        'Não estar legal ou contratualmente impedido de utilizar serviços desta natureza em seu país de residência.',
      ],
    ),
    LegalSection(
      title: '4. Autenticação e conta de usuário',
      paragraphs: [
        'O acesso à Plataforma é realizado por meio do sistema oficial de autenticação da Riot Games (Riot Sign On / OAuth2). A WPGG não armazena senhas da Riot Games. O usuário é responsável por manter a confidencialidade de suas credenciais e por qualquer atividade realizada em sua conta.',
        'A WPGG reserva-se o direito de suspender ou encerrar contas envolvidas em uso fraudulento, manipulação de estatísticas ou qualquer comportamento que viole estes termos.',
      ],
    ),
    LegalSection(
      title: '5. Sistema de missões e recompensas',
      paragraphs: [
        'As missões diárias são geradas com base na atividade do usuário em League of Legends. A quantidade de tokens WPGG concedida por missão pode variar conforme a dificuldade e está sujeita a alterações pela WPGG sem aviso prévio.',
        'O usuário aceita que:',
      ],
      bullets: [
        'As missões são diárias e não acumulam entre os dias.',
        'As rerolagens de missões são limitadas a uma quantidade determinada por dia.',
        'A WPGG pode modificar, suspender ou descontinuar o sistema de missões a qualquer momento.',
      ],
    ),
    LegalSection(
      title: '6. Token WPGG — natureza e riscos',
      paragraphs: [
        'O token WPGG é um ativo digital ERC-20 implantado na Polygon Mainnet. Seu contrato é público e verificável no PolygonScan. O usuário reconhece e aceita o seguinte:',
        'A WPGG recomenda não adquirir tokens no mercado secundário com fins especulativos. O sistema foi projetado para recompensar o jogo, e não para gerar retornos financeiros.',
      ],
      bullets: [
        'O valor do token WPGG é determinado pelo mercado e pode flutuar significativamente.',
        'A WPGG não garante nenhum valor mínimo, retorno de investimento ou rentabilidade.',
        'A Plataforma não é um veículo de investimento. A finalidade do token é ser utilizado dentro do ecossistema da Plataforma (loja, resgates).',
        'A liquidez do token é respaldada por um pool fixo na QuickSwap (par WPGG/USDC). O tamanho desse pool é fixo e não garante liquidez ilimitada.',
        'O usuário é o único responsável pelas decisões relativas ao token WPGG, incluindo compra, venda ou retenção no mercado secundário.',
      ],
    ),
    LegalSection(
      title: '7. Saques para carteira',
      paragraphs: [
        'O usuário pode solicitar o saque de tokens WPGG acumulados para sua carteira pessoal na rede Polygon, sujeito às seguintes condições:',
      ],
      bullets: [
        'O saldo mínimo para sacar é de 1.000 tokens WPGG.',
        'O usuário deve possuir uma carteira compatível (por exemplo, MetaMask) configurada na rede Polygon.',
        'As transações na Polygon podem envolver uma taxa de gas de responsabilidade do usuário.',
        'Uma vez confirmado, o saque é irreversível.',
        'A WPGG não se responsabiliza por erros no endereço de carteira fornecido pelo usuário.',
      ],
    ),
    LegalSection(
      title: '8. Loja e resgates',
      paragraphs: [
        'Os produtos disponíveis na loja interna (incluindo gift cards de Riot Points e outros) estão sujeitos à disponibilidade de estoque. A WPGG não garante a disponibilidade permanente de nenhum produto. Os preços em tokens podem ser atualizados sem aviso prévio.',
        'Os resgates são definitivos e irreversíveis uma vez processados. Em caso de problema com a entrega de um produto digital, o usuário deverá entrar em contato com o suporte da WPGG em até 48 horas após o resgate.',
      ],
    ),
    LegalSection(
      title: '9. Conduta do usuário',
      paragraphs: [
        'O usuário se compromete a não:',
        'O descumprimento destas regras pode resultar na suspensão permanente da conta e na perda do saldo acumulado.',
      ],
      bullets: [
        'Utilizar bots, scripts ou qualquer meio automatizado para completar missões ou manipular estatísticas.',
        'Tentar comprometer a segurança da Plataforma ou acessar dados de outros usuários.',
        'Revender, transferir ou comercializar sua conta WPGG.',
        'Utilizar a Plataforma para atividades ilegais ou contrárias aos Termos de Serviço da Riot Games.',
      ],
    ),
    LegalSection(
      title: '10. Propriedade intelectual',
      paragraphs: [
        'Todo o conteúdo da Plataforma (design, código, textos, imagens, logotipo WPGG) é propriedade da WPGG ou de seus respectivos titulares. É proibida a reprodução, distribuição ou uso não autorizado.',
        'League of Legends e todos os ativos associados são propriedade da Riot Games, Inc. A WPGG utiliza a API pública da Riot Games de acordo com as Políticas para Desenvolvedores da Riot.',
      ],
    ),
    LegalSection(
      title: '11. Limitação de responsabilidade',
      paragraphs: [
        'Na máxima extensão permitida pela lei aplicável, a WPGG não será responsável por:',
      ],
      bullets: [
        'Perdas econômicas decorrentes da flutuação do valor do token WPGG.',
        'Interrupções do serviço por manutenção, falhas técnicas ou casos de força maior.',
        'Alterações na API da Riot Games que afetem o funcionamento da Plataforma.',
        'Perda de fundos por erros em carteiras ou transações on-chain iniciadas pelo usuário.',
      ],
    ),
    LegalSection(
      title: '12. Alterações',
      paragraphs: [
        'A WPGG reserva-se o direito de modificar estes Termos e Condições a qualquer momento. As alterações serão notificadas por meio da Plataforma com pelo menos 7 dias de antecedência. O uso continuado após a notificação implica a aceitação dos novos termos.',
      ],
    ),
    LegalSection(
      title: '13. Lei aplicável',
      paragraphs: [
        'Estes Termos e Condições são regidos pelas leis da República Argentina. Qualquer disputa será submetida à jurisdição dos tribunais ordinários da Cidade Autônoma de Buenos Aires, com renúncia expressa a qualquer outro foro.',
      ],
    ),
    LegalSection(
      title: '14. Contato',
      paragraphs: [
        'Para dúvidas, reclamações ou suporte, o usuário pode entrar em contato com a WPGG pelos canais oficiais disponíveis na Plataforma.',
      ],
    ),
  ];
}
