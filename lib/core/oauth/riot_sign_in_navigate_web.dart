import 'package:web/web.dart';

/// WebAssembly / entornos sin `dart:library.html`.
Future<void> openRiotRsoSignInUrl(String url) async {
  window.location.href = url;
}
