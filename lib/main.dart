import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/firebase/firebase_bootstrap.dart';
import 'core/platform/configure_url_strategy.dart';
import 'core/platform/oauth_callback_fragment_capture.dart';
import 'core/di/injection_container.dart';
import 'core/locale/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/presentation/web/web_motion.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/ddragon/domain/repositories/ddragon_repository.dart';
import 'features/ddragon/presentation/providers/ddragon_provider.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  captureOauthCallbackFragmentAtAppStart();
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();
  await initDependencies();
  if (kIsWeb) {
    runApp(const WpggApp());
    unawaited(bootstrapFirebase());
  } else {
    await bootstrapFirebase();
    runApp(const WpggApp());
  }
}

class WpggApp extends StatelessWidget {
  const WpggApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (_) => DDragonProvider(sl<DDragonRepository>()),
        ),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (_, themeProvider, localeProvider, __) => MaterialApp.router(
          title: 'WPGG',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          themeAnimationDuration: WebMotion.theme,
          themeAnimationCurve: WebMotion.curve,
          locale: localeProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localeListResolutionCallback: (locales, supported) {
            // Default to English unless the user picked a language in settings.
            return localeProvider.locale;
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
