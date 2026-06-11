import '../domain/legal_section.dart';

abstract final class TermsContentFr {
  static const List<LegalSection> sections = [
    LegalSection(
      title: '1. Acceptation des conditions',
      paragraphs: [
        'En accédant à la plateforme WPGG (la « Plateforme ») ou en l\'utilisant, y compris l\'application mobile, le site web et tous les services associés, vous acceptez d\'être lié par les présentes Conditions générales. Si vous n\'acceptez pas l\'une de ces conditions, vous ne devez pas utiliser la Plateforme.',
      ],
    ),
    LegalSection(
      title: '2. Description du service',
      paragraphs: [
        'WPGG est une plateforme indépendante de statistiques et de gamification pour League of Legends. Via la Plateforme, les utilisateurs peuvent :',
        'WPGG n\'est pas un jeu de hasard, un système d\'investissement ni un produit financier. Il s\'agit d\'un système de récompenses lié à l\'activité de jeu de l\'utilisateur.',
      ],
      bullets: [
        'Consulter les statistiques de leurs parties de League of Legends.',
        'Accomplir des missions quotidiennes basées sur leurs performances en jeu.',
        'Gagner des tokens WPGG en récompense pour l\'accomplissement des missions.',
        'Retirer des tokens WPGG vers un wallet compatible avec le réseau Polygon.',
        'Échanger des tokens WPGG contre des produits disponibles dans la boutique interne de la Plateforme.',
      ],
    ),
    LegalSection(
      title: '3. Éligibilité',
      paragraphs: [
        'Pour utiliser la Plateforme, l\'utilisateur doit :',
        'WPGG n\'est pas affilié, sponsorisé ni approuvé par Riot Games, Inc.',
      ],
      bullets: [
        'Avoir au moins 18 ans, ou l\'âge de la majorité légale dans sa juridiction.',
        'Disposer d\'un compte Riot Games actif et accepter les Conditions d\'utilisation de Riot.',
        'Ne pas être légalement ou contractuellement interdit d\'utiliser des services de cette nature dans son pays de résidence.',
      ],
    ),
    LegalSection(
      title: '4. Authentification et compte utilisateur',
      paragraphs: [
        'L\'accès à la Plateforme est assuré via le système d\'authentification officiel de Riot Games (Riot Sign On / OAuth2). WPGG ne stocke pas les mots de passe Riot Games. L\'utilisateur est responsable de la confidentialité de ses identifiants et de toute activité effectuée depuis son compte.',
        'WPGG se réserve le droit de suspendre ou de résilier les comptes impliqués dans une utilisation frauduleuse, une manipulation de statistiques ou tout comportement contraire aux présentes conditions.',
      ],
    ),
    LegalSection(
      title: '5. Système de missions et récompenses',
      paragraphs: [
        'Les missions quotidiennes sont générées en fonction de l\'activité de l\'utilisateur sur League of Legends. Le montant de tokens WPGG attribué par mission peut varier selon la difficulté et est susceptible d\'être modifié par WPGG sans préavis.',
        'L\'utilisateur accepte que :',
      ],
      bullets: [
        'Les missions sont quotidiennes et ne sont pas reportées d\'un jour à l\'autre.',
        'Les relances de missions sont limitées à un nombre déterminé par jour.',
        'WPGG peut modifier, suspendre ou interrompre le système de missions à tout moment.',
      ],
    ),
    LegalSection(
      title: '6. Token WPGG — nature et risques',
      paragraphs: [
        'Le token WPGG est un actif numérique ERC-20 déployé sur Polygon Mainnet. Son contrat est public et vérifiable sur PolygonScan. L\'utilisateur reconnaît et accepte ce qui suit :',
        'WPGG recommande de ne pas acquérir de tokens sur le marché secondaire à des fins spéculatives. Le système est conçu pour récompenser le jeu, et non pour générer des rendements financiers.',
      ],
      bullets: [
        'La valeur du token WPGG est déterminée par le marché et peut fluctuer de manière significative.',
        'WPGG ne garantit aucune valeur minimale, aucun rendement d\'investissement ni aucune rentabilité.',
        'La Plateforme n\'est pas un véhicule d\'investissement. L\'objectif du token est d\'être utilisé au sein de l\'écosystème de la Plateforme (boutique, échanges).',
        'La liquidité du token est assurée par un pool fixe sur QuickSwap (paire WPGG/USDC). La taille de ce pool est fixe et ne garantit pas une liquidité illimitée.',
        'L\'utilisateur est seul responsable des décisions concernant le token WPGG, y compris son achat, sa vente ou sa détention sur le marché secondaire.',
      ],
    ),
    LegalSection(
      title: '7. Retraits vers le wallet',
      paragraphs: [
        'L\'utilisateur peut demander le retrait de tokens WPGG accumulés vers son wallet personnel sur le réseau Polygon, sous réserve des conditions suivantes :',
      ],
      bullets: [
        'Le solde minimum pour retirer est de 1 000 tokens WPGG.',
        'L\'utilisateur doit disposer d\'un wallet compatible (par exemple MetaMask) configuré sur Polygon.',
        'Les transactions sur Polygon peuvent impliquer des frais de gas à la charge de l\'utilisateur.',
        'Une fois confirmé, un retrait est irréversible.',
        'WPGG n\'est pas responsable des erreurs dans l\'adresse de wallet fournie par l\'utilisateur.',
      ],
    ),
    LegalSection(
      title: '8. Boutique et échanges',
      paragraphs: [
        'Les produits disponibles dans la boutique interne (y compris les cartes cadeaux Riot Points et autres) sont soumis à la disponibilité des stocks. WPGG ne garantit pas la disponibilité permanente d\'un produit quelconque. Les prix en tokens peuvent être mis à jour sans préavis.',
        'Les échanges sont définitifs et irréversibles une fois traités. En cas de problème avec la livraison d\'un produit numérique, l\'utilisateur doit contacter le support WPGG dans les 48 heures suivant l\'échange.',
      ],
    ),
    LegalSection(
      title: '9. Conduite de l\'utilisateur',
      paragraphs: [
        'L\'utilisateur s\'engage à ne pas :',
        'Le non-respect de ces règles peut entraîner la suspension permanente du compte et la perte du solde accumulé.',
      ],
      bullets: [
        'Utiliser des bots, des scripts ou tout moyen automatisé pour accomplir des missions ou manipuler des statistiques.',
        'Tenter de compromettre la sécurité de la Plateforme ou d\'accéder aux données d\'autres utilisateurs.',
        'Revendre, transférer ou commercialiser son compte WPGG.',
        'Utiliser la Plateforme pour des activités illégales ou contraires aux Conditions d\'utilisation de Riot Games.',
      ],
    ),
    LegalSection(
      title: '10. Propriété intellectuelle',
      paragraphs: [
        'L\'ensemble du contenu de la Plateforme (design, code, textes, images, logo WPGG) appartient à WPGG ou à ses titulaires respectifs. Toute reproduction, distribution ou utilisation non autorisée est interdite.',
        'League of Legends et tous les actifs associés sont la propriété de Riot Games, Inc. WPGG utilise l\'API publique de Riot Games conformément aux Politiques pour les développeurs de Riot.',
      ],
    ),
    LegalSection(
      title: '11. Limitation de responsabilité',
      paragraphs: [
        'Dans la mesure maximale permise par la loi applicable, WPGG ne sera pas responsable de :',
      ],
      bullets: [
        'Pertes économiques résultant des fluctuations de la valeur du token WPGG.',
        'Interruptions de service dues à la maintenance, à des pannes techniques ou à des cas de force majeure.',
        'Modifications de l\'API Riot Games affectant le fonctionnement de la Plateforme.',
        'Perte de fonds due à des erreurs de wallet ou à des transactions on-chain initiées par l\'utilisateur.',
      ],
    ),
    LegalSection(
      title: '12. Modifications',
      paragraphs: [
        'WPGG se réserve le droit de modifier les présentes Conditions générales à tout moment. Les modifications seront notifiées via la Plateforme au moins 7 jours à l\'avance. L\'utilisation continue après notification implique l\'acceptation des nouvelles conditions.',
      ],
    ),
    LegalSection(
      title: '13. Droit applicable',
      paragraphs: [
        'Les présentes Conditions générales sont régies par les lois de la République argentine. Tout litige sera soumis aux tribunaux ordinaires de la Ville autonome de Buenos Aires, avec renonciation expresse à toute autre juridiction.',
      ],
    ),
    LegalSection(
      title: '14. Contact',
      paragraphs: [
        'Pour toute question, réclamation ou demande de support, l\'utilisateur peut contacter WPGG via les canaux officiels disponibles sur la Plateforme.',
      ],
    ),
  ];
}
