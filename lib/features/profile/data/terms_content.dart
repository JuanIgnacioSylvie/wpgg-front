import '../domain/legal_section.dart';
import 'terms_content_fr.dart';
import 'terms_content_pt.dart';

abstract final class TermsContent {
  static const String subtitleEs = 'Well Played Good Game';
  static const String subtitleEn = 'Well Played Good Game';
  static const String lastUpdatedEs = 'Última actualización: junio de 2026';
  static const String lastUpdatedEn = 'Last updated: June 2026';

  static const List<LegalSection> sectionsEs = [
    LegalSection(
      title: '1. Aceptación de los términos',
      paragraphs: [
        'Al acceder o utilizar la plataforma WPGG (en adelante, "la Plataforma"), incluyendo la aplicación móvil, el sitio web y todos los servicios asociados, el usuario acepta quedar vinculado por los presentes Términos y Condiciones. Si no estás de acuerdo con alguno de estos términos, no deberás utilizar la Plataforma.',
      ],
    ),
    LegalSection(
      title: '2. Descripción del servicio',
      paragraphs: [
        'WPGG es una plataforma de estadísticas y gamificación para el videojuego League of Legends, desarrollada y operada de forma independiente. A través de la Plataforma, los usuarios pueden:',
        'WPGG no es un juego de azar, un esquema de inversión ni un producto financiero. Es un sistema de recompensas vinculado a la actividad de juego del usuario.',
      ],
      bullets: [
        'Visualizar estadísticas de sus partidas de League of Legends.',
        'Completar misiones diarias basadas en su rendimiento en el juego.',
        'Acumular tokens WPGG como recompensa por completar dichas misiones.',
        'Retirar tokens WPGG a una wallet compatible con la red Polygon.',
        'Canjear tokens WPGG por productos disponibles en la tienda interna de la Plataforma.',
      ],
    ),
    LegalSection(
      title: '3. Elegibilidad',
      paragraphs: [
        'Para utilizar la Plataforma, el usuario debe:',
        'WPGG no está afiliado, patrocinado ni avalado por Riot Games, Inc.',
      ],
      bullets: [
        'Tener al menos 18 años de edad, o la mayoría de edad legal en su jurisdicción.',
        'Poseer una cuenta activa de Riot Games y aceptar los Términos de Servicio de dicha plataforma.',
        'No tener prohibición legal o contractual para utilizar servicios de esta naturaleza en su país de residencia.',
      ],
    ),
    LegalSection(
      title: '4. Autenticación y cuenta de usuario',
      paragraphs: [
        'El acceso a la Plataforma se realiza mediante el sistema oficial de autenticación de Riot Games (Riot Sign On / OAuth2). WPGG no almacena contraseñas de Riot Games. El usuario es responsable de mantener la confidencialidad de sus credenciales y de cualquier actividad que se realice desde su cuenta.',
        'WPGG se reserva el derecho de suspender o cancelar cuentas que incurran en uso fraudulento, manipulación de estadísticas, o cualquier comportamiento contrario a estos términos.',
      ],
    ),
    LegalSection(
      title: '5. Sistema de misiones y recompensas',
      paragraphs: [
        'Las misiones diarias se generan en función de la actividad del usuario en League of Legends. La cantidad de tokens WPGG otorgados por cada misión puede variar según su dificultad y está sujeta a cambios por parte de WPGG sin previo aviso.',
        'El usuario acepta que:',
      ],
      bullets: [
        'Las misiones son de carácter diario y no acumulables entre días.',
        'Los rerolls de misiones están limitados a una cantidad determinada por día.',
        'WPGG puede modificar, suspender o discontinuar el sistema de misiones en cualquier momento.',
      ],
    ),
    LegalSection(
      title: '6. Token WPGG — naturaleza y riesgos',
      paragraphs: [
        'El token WPGG es un activo digital ERC-20 desplegado en la red Polygon Mainnet. Su contrato es público y verificable en PolygonScan. El usuario reconoce y acepta lo siguiente:',
        'WPGG recomienda no adquirir tokens en el mercado secundario con fines especulativos. El sistema está diseñado para recompensar el juego, no para generar retornos financieros.',
      ],
      bullets: [
        'El valor del token WPGG está determinado por el mercado y puede fluctuar significativamente.',
        'WPGG no garantiza ningún valor mínimo, retorno de inversión ni rentabilidad.',
        'La Plataforma no es un vehículo de inversión. El propósito del token es ser utilizado dentro del ecosistema de la Plataforma (tienda, canjes).',
        'La liquidez del token está respaldada por un pool fijo en QuickSwap (par WPGG/USDC). El tamaño de dicho pool es fijo y no garantiza liquidez ilimitada.',
        'El usuario es el único responsable de las decisiones que tome respecto al token WPGG, incluyendo su compra, venta o retención en el mercado secundario.',
      ],
    ),
    LegalSection(
      title: '7. Retiros a wallet',
      paragraphs: [
        'El usuario puede solicitar el retiro de tokens WPGG acumulados a su wallet personal en la red Polygon, sujeto a las siguientes condiciones:',
      ],
      bullets: [
        'El saldo mínimo para retirar es de 1.000 tokens WPGG.',
        'El usuario debe contar con una wallet compatible (por ejemplo, MetaMask) configurada en la red Polygon.',
        'Las transacciones en Polygon pueden implicar un gas fee que es responsabilidad del usuario.',
        'Una vez confirmado el retiro, la transacción es irreversible.',
        'WPGG no se responsabiliza por errores en la dirección de wallet proporcionada por el usuario.',
      ],
    ),
    LegalSection(
      title: '8. Tienda y canjes',
      paragraphs: [
        'Los productos disponibles en la tienda interna (incluyendo gift cards de Riot Points y otros) están sujetos a disponibilidad de stock. WPGG no garantiza la disponibilidad permanente de ningún producto. Los precios en tokens pueden actualizarse sin previo aviso.',
        'Los canjes son definitivos e irreversibles una vez procesados. En caso de problema con la entrega de un producto digital, el usuario deberá contactar al soporte de WPGG dentro de las 48 horas posteriores al canje.',
      ],
    ),
    LegalSection(
      title: '9. Conducta del usuario',
      paragraphs: [
        'El usuario se compromete a no:',
        'El incumplimiento de estas normas puede resultar en la suspensión permanente de la cuenta y la pérdida del saldo acumulado.',
      ],
      bullets: [
        'Utilizar bots, scripts o cualquier medio automatizado para completar misiones o manipular estadísticas.',
        'Intentar vulnerar la seguridad de la Plataforma o acceder a datos de otros usuarios.',
        'Revender, transferir o comercializar su cuenta de WPGG.',
        'Utilizar la Plataforma para actividades ilegales o contrarias a los Términos de Servicio de Riot Games.',
      ],
    ),
    LegalSection(
      title: '10. Propiedad intelectual',
      paragraphs: [
        'Todo el contenido de la Plataforma (diseño, código, textos, imágenes, logotipo de WPGG) es propiedad de WPGG o de sus respectivos titulares. Queda prohibida su reproducción, distribución o uso no autorizado.',
        'League of Legends y todos los activos asociados son propiedad de Riot Games, Inc. WPGG utiliza la API pública de Riot Games de conformidad con sus Políticas de Uso para Desarrolladores.',
      ],
    ),
    LegalSection(
      title: '11. Limitación de responsabilidad',
      paragraphs: [
        'En la máxima medida permitida por la ley aplicable, WPGG no será responsable por:',
      ],
      bullets: [
        'Pérdidas económicas derivadas de la fluctuación del valor del token WPGG.',
        'Interrupciones del servicio por mantenimiento, fallas técnicas o causas de fuerza mayor.',
        'Cambios en la API de Riot Games que afecten el funcionamiento de la Plataforma.',
        'Pérdida de fondos por errores en wallets o transacciones on-chain iniciadas por el usuario.',
      ],
    ),
    LegalSection(
      title: '12. Modificaciones',
      paragraphs: [
        'WPGG se reserva el derecho de modificar estos Términos y Condiciones en cualquier momento. Los cambios serán notificados a través de la Plataforma con al menos 7 días de anticipación. El uso continuado de la Plataforma tras la notificación implica la aceptación de los nuevos términos.',
      ],
    ),
    LegalSection(
      title: '13. Ley aplicable',
      paragraphs: [
        'Estos Términos y Condiciones se rigen por las leyes de la República Argentina. Cualquier disputa será sometida a la jurisdicción de los tribunales ordinarios de la Ciudad Autónoma de Buenos Aires, con renuncia expresa a cualquier otro fuero que pudiera corresponder.',
      ],
    ),
    LegalSection(
      title: '14. Contacto',
      paragraphs: [
        'Para consultas, reclamos o soporte, el usuario puede contactarse a través de los canales oficiales de WPGG disponibles en la Plataforma.',
      ],
    ),
  ];

  static const List<LegalSection> sectionsEn = [
    LegalSection(
      title: '1. Acceptance of terms',
      paragraphs: [
        'By accessing or using the WPGG platform (the "Platform"), including the mobile app, website, and all associated services, you agree to be bound by these Terms and Conditions. If you do not agree with any of these terms, you must not use the Platform.',
      ],
    ),
    LegalSection(
      title: '2. Description of the service',
      paragraphs: [
        'WPGG is an independent statistics and gamification platform for League of Legends. Through the Platform, users can:',
        'WPGG is not a game of chance, an investment scheme, or a financial product. It is a rewards system tied to the user\'s in-game activity.',
      ],
      bullets: [
        'View statistics for their League of Legends matches.',
        'Complete daily missions based on in-game performance.',
        'Earn WPGG tokens as rewards for completing missions.',
        'Withdraw WPGG tokens to a wallet compatible with the Polygon network.',
        'Redeem WPGG tokens for products available in the Platform\'s internal store.',
      ],
    ),
    LegalSection(
      title: '3. Eligibility',
      paragraphs: [
        'To use the Platform, the user must:',
        'WPGG is not affiliated with, sponsored by, or endorsed by Riot Games, Inc.',
      ],
      bullets: [
        'Be at least 18 years old, or the age of legal majority in their jurisdiction.',
        'Have an active Riot Games account and accept Riot\'s Terms of Service.',
        'Not be legally or contractually prohibited from using services of this nature in their country of residence.',
      ],
    ),
    LegalSection(
      title: '4. Authentication and user account',
      paragraphs: [
        'Access to the Platform is provided through Riot Games\' official authentication system (Riot Sign On / OAuth2). WPGG does not store Riot Games passwords. Users are responsible for keeping their credentials confidential and for any activity on their account.',
        'WPGG reserves the right to suspend or terminate accounts involved in fraudulent use, stat manipulation, or any behavior that violates these terms.',
      ],
    ),
    LegalSection(
      title: '5. Mission and reward system',
      paragraphs: [
        'Daily missions are generated based on the user\'s League of Legends activity. The amount of WPGG tokens awarded per mission may vary by difficulty and is subject to change by WPGG without prior notice.',
        'The user accepts that:',
      ],
      bullets: [
        'Missions are daily and do not carry over between days.',
        'Mission rerolls are limited to a set amount per day.',
        'WPGG may modify, suspend, or discontinue the mission system at any time.',
      ],
    ),
    LegalSection(
      title: '6. WPGG token — nature and risks',
      paragraphs: [
        'The WPGG token is an ERC-20 digital asset deployed on Polygon Mainnet. Its contract is public and verifiable on PolygonScan. The user acknowledges and accepts the following:',
        'WPGG recommends not acquiring tokens on the secondary market for speculative purposes. The system is designed to reward play, not to generate financial returns.',
      ],
      bullets: [
        'The value of the WPGG token is market-determined and may fluctuate significantly.',
        'WPGG does not guarantee any minimum value, investment return, or profitability.',
        'The Platform is not an investment vehicle. The token\'s purpose is use within the Platform ecosystem (store, redemptions).',
        'Token liquidity is backed by a fixed pool on QuickSwap (WPGG/USDC pair). The pool size is fixed and does not guarantee unlimited liquidity.',
        'The user is solely responsible for decisions regarding the WPGG token, including buying, selling, or holding on the secondary market.',
      ],
    ),
    LegalSection(
      title: '7. Wallet withdrawals',
      paragraphs: [
        'Users may request withdrawal of accumulated WPGG tokens to their personal wallet on the Polygon network, subject to the following conditions:',
      ],
      bullets: [
        'The minimum balance to withdraw is 1,000 WPGG tokens.',
        'The user must have a compatible wallet (e.g. MetaMask) configured on Polygon.',
        'Polygon transactions may involve a gas fee borne by the user.',
        'Once confirmed, a withdrawal is irreversible.',
        'WPGG is not responsible for errors in the wallet address provided by the user.',
      ],
    ),
    LegalSection(
      title: '8. Store and redemptions',
      paragraphs: [
        'Products in the internal store (including Riot Points gift cards and others) are subject to stock availability. WPGG does not guarantee permanent availability of any product. Token prices may be updated without prior notice.',
        'Redemptions are final and irreversible once processed. If there is an issue with delivery of a digital product, the user must contact WPGG support within 48 hours of redemption.',
      ],
    ),
    LegalSection(
      title: '9. User conduct',
      paragraphs: [
        'The user agrees not to:',
        'Violation of these rules may result in permanent account suspension and forfeiture of accumulated balance.',
      ],
      bullets: [
        'Use bots, scripts, or any automated means to complete missions or manipulate statistics.',
        'Attempt to compromise Platform security or access other users\' data.',
        'Resell, transfer, or trade their WPGG account.',
        'Use the Platform for illegal activities or activities contrary to Riot Games\' Terms of Service.',
      ],
    ),
    LegalSection(
      title: '10. Intellectual property',
      paragraphs: [
        'All Platform content (design, code, text, images, WPGG logo) is owned by WPGG or its respective rights holders. Unauthorized reproduction, distribution, or use is prohibited.',
        'League of Legends and all associated assets are property of Riot Games, Inc. WPGG uses the public Riot Games API in accordance with Riot\'s Developer Policies.',
      ],
    ),
    LegalSection(
      title: '11. Limitation of liability',
      paragraphs: [
        'To the maximum extent permitted by applicable law, WPGG shall not be liable for:',
      ],
      bullets: [
        'Economic losses arising from fluctuations in the WPGG token value.',
        'Service interruptions due to maintenance, technical failures, or force majeure.',
        'Changes to the Riot Games API that affect Platform operation.',
        'Loss of funds due to wallet errors or on-chain transactions initiated by the user.',
      ],
    ),
    LegalSection(
      title: '12. Modifications',
      paragraphs: [
        'WPGG reserves the right to modify these Terms and Conditions at any time. Changes will be notified through the Platform at least 7 days in advance. Continued use after notification implies acceptance of the new terms.',
      ],
    ),
    LegalSection(
      title: '13. Governing law',
      paragraphs: [
        'These Terms and Conditions are governed by the laws of the Argentine Republic. Any dispute shall be submitted to the ordinary courts of the City of Buenos Aires, with express waiver of any other jurisdiction.',
      ],
    ),
    LegalSection(
      title: '14. Contact',
      paragraphs: [
        'For inquiries, claims, or support, users may contact WPGG through the official channels available on the Platform.',
      ],
    ),
  ];

  static const String subtitleFr = 'Well Played Good Game';
  static const String subtitlePt = 'Well Played Good Game';
  static const String lastUpdatedFr = 'Dernière mise à jour : juin 2026';
  static const String lastUpdatedPt = 'Última atualização: junho de 2026';

  static const sectionsFr = TermsContentFr.sections;
  static const sectionsPt = TermsContentPt.sections;

  static List<LegalSection> sectionsForLanguageCode(String code) =>
      switch (code) {
        'es' => sectionsEs,
        'fr' => sectionsFr,
        'pt' => sectionsPt,
        _ => sectionsEn,
      };

  static String subtitleForLanguageCode(String code) => switch (code) {
        'es' => subtitleEs,
        'fr' => subtitleFr,
        'pt' => subtitlePt,
        _ => subtitleEn,
      };

  static String lastUpdatedForLanguageCode(String code) => switch (code) {
        'es' => lastUpdatedEs,
        'fr' => lastUpdatedFr,
        'pt' => lastUpdatedPt,
        _ => lastUpdatedEn,
      };

  @Deprecated('Use sectionsForLanguageCode')
  static List<LegalSection> sectionsForLocale(bool isSpanish) =>
      sectionsForLanguageCode(isSpanish ? 'es' : 'en');

  @Deprecated('Use subtitleForLanguageCode')
  static String subtitleForLocale(bool isSpanish) =>
      subtitleForLanguageCode(isSpanish ? 'es' : 'en');

  @Deprecated('Use lastUpdatedForLanguageCode')
  static String lastUpdatedForLocale(bool isSpanish) =>
      lastUpdatedForLanguageCode(isSpanish ? 'es' : 'en');
}
