import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../features/riot/presentation/pages/dashboard_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../di/injection_container.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) => null,
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: const RegisterPage(),
      ),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<AuthBloc>()),
          BlocProvider(create: (_) => sl<RiotBloc>()),
        ],
        child: const DashboardPage(),
      ),
    ),
  ],
);
