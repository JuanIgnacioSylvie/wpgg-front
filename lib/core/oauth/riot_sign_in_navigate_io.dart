import 'package:url_launcher/url_launcher.dart';

Future<void> openRiotRsoSignInUrl(String url) async {
  final ok = await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
  if (!ok) {
    throw Exception('No se pudo abrir la página de Riot');
  }
}
