import 'package:web/web.dart' as web;

const _baseDocumentTitle = 'WPGG';

/// Updates the browser tab title with an unread badge, e.g. `(2) WPGG`.
void updateWebDocumentTitle({required int unreadCount}) {
  if (unreadCount <= 0) {
    web.document.title = _baseDocumentTitle;
    return;
  }

  final label = unreadCount > 9 ? '9+' : '$unreadCount';
  web.document.title = '($label) $_baseDocumentTitle';
}

void resetWebDocumentTitle() {
  web.document.title = _baseDocumentTitle;
}
