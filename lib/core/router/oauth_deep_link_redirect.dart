import '../constants/app_constants.dart';

/// Convierte `wpgg://auth/riot-callback?...` → `/auth/riot-callback?...` para GoRouter.
String? normalizeOAuthDeepLinkLocation(String location) {
  final uri = Uri.tryParse(location);
  if (uri == null || uri.scheme != AppConstants.riotRsoMobileCallbackScheme) {
    return null;
  }

  final path = uri.host.isNotEmpty
      ? '/${uri.host}${uri.path}'
      : (uri.path.isNotEmpty ? uri.path : AppConstants.riotRsoWebSuccessPath);

  if (uri.query.isEmpty) {
    return path;
  }
  return '$path?${uri.query}';
}
