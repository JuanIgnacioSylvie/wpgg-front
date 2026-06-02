import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/riot_rso_already_exists_page.dart';
import '../../features/auth/presentation/pages/riot_rso_callback_page.dart';
import '../../features/auth/presentation/pages/riot_rso_no_account_page.dart';
import '../constants/app_constants.dart';
import '../../features/missions/presentation/bloc/missions_bloc.dart';
import '../../features/missions/presentation/pages/home_page.dart';
import '../../features/missions/presentation/pages/missions_by_day_page.dart';
import '../../features/missions/presentation/pages/pick_missions_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../features/wallet/presentation/pages/finance_page.dart';
import '../di/injection_container.dart';
import '../presentation/app_shell_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

int shellBranchIndexForNav(int navIndex) {
  if (navIndex <= 1) {
    return navIndex;
  }
  if (navIndex == 3) {
    return 2;
  }
  if (navIndex == 4) {
    return 3;
  }
  return 0;
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) => null,
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: AppConstants.riotRsoWebSuccessPath,
      builder: (_, __) => const RiotRsoCallbackPage(),
    ),
    GoRoute(
      path: '/auth/riot-no-account',
      builder: (_, __) => const RiotRsoNoAccountPage(),
    ),
    GoRoute(
      path: '/auth/riot-already-exists',
      builder: (_, __) => const RiotRsoAlreadyExistsPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => BlocProvider.value(
        value: sl<AuthBloc>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => BlocProvider.value(
        value: sl<AuthBloc>(),
        child: const RegisterPage(),
      ),
    ),
    GoRoute(
      path: '/missions/pick',
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<RiotBloc>()),
          BlocProvider.value(value: sl<MissionsBloc>()),
        ],
        child: const PickMissionsPage(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<AuthBloc>()),
            BlocProvider.value(value: sl<RiotBloc>()),
            BlocProvider.value(value: sl<MissionsBloc>()),
            BlocProvider.value(value: sl<WalletBloc>()),
          ],
          child: AppShellPage(navigationShell: navigationShell),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, __) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/missions/by-day',
              builder: (_, __) => const MissionsByDayPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/finance',
              builder: (_, __) => const FinancePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
