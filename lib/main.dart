import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/platform/configure_url_strategy.dart';
import 'core/platform/oauth_callback_fragment_capture.dart';
import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/ddragon/domain/repositories/ddragon_repository.dart';
import 'features/ddragon/presentation/providers/ddragon_provider.dart';

Future<void> main() async {
  captureOauthCallbackFragmentAtAppStart();
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();
  await initDependencies();
  runApp(const WpggApp());
}

class WpggApp extends StatelessWidget {
  const WpggApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => DDragonProvider(sl<DDragonRepository>()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, __) => MaterialApp.router(
          title: 'WPGG',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
