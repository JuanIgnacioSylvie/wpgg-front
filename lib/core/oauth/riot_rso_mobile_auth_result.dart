/// Resultado del flujo OAuth Riot en móvil (Custom Tab / ASWebAuthenticationSession).
class RiotRsoMobileAuthResult {
  const RiotRsoMobileAuthResult({
    this.riotSessionCode,
    this.oauthError,
    this.oauthErrorDescription,
    this.riotLinkPendingCode,
    this.cancelled = false,
  });

  final String? riotSessionCode;
  final String? oauthError;
  final String? oauthErrorDescription;
  final String? riotLinkPendingCode;
  final bool cancelled;

  bool get hasRiotSessionCode =>
      riotSessionCode != null && riotSessionCode!.isNotEmpty;

  bool get hasOAuthError => oauthError != null && oauthError!.isNotEmpty;
}
