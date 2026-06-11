bool requiresEncryptedPayload(String method, String path) {
  if (method.toUpperCase() != 'POST') {
    return false;
  }
  final normalized = _normalizeRequestPath(path);
  const exact = {
    '/auth/login',
    '/auth/register',
    '/auth/reset-password',
    '/auth/riot-session',
    '/auth/refresh',
    '/withdrawals',
    '/contact/sponsor',
  };
  if (exact.contains(normalized)) {
    return true;
  }
  if (RegExp(r'^/store/products/[^/]+/purchase$').hasMatch(normalized)) {
    return true;
  }
  if (RegExp(r'^/riot/rso/(refresh|userinfo)$').hasMatch(normalized)) {
    return true;
  }
  return false;
}

String _normalizeRequestPath(String path) {
  final withoutQuery = path.split('?').first;
  final trimmed = withoutQuery.replaceAll(RegExp(r'/+$'), '');
  return (trimmed.isEmpty ? '/' : trimmed).toLowerCase();
}
