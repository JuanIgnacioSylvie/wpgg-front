import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/link_riot_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/register_check_email_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/auth/presentation/pages/riot_rso_already_exists_page.dart';
import '../../features/auth/presentation/pages/riot_rso_callback_page.dart';
import '../../features/auth/presentation/pages/riot_rso_no_account_page.dart';
import '../constants/app_constants.dart';
import 'oauth_deep_link_redirect.dart';
import '../../features/missions/presentation/bloc/missions_bloc.dart';
import '../../features/missions/presentation/pages/home_page.dart';
import '../../features/missions/presentation/pages/missions_by_day_page.dart';
import '../../features/missions/presentation/pages/web_missions_by_day_page.dart';
import '../../features/missions/presentation/pages/pick_missions_page.dart';
import '../../features/profile/presentation/pages/faqs_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/terms_page.dart';
import '../../features/riot/presentation/bloc/riot_bloc.dart';
import '../../features/store/presentation/bloc/store_bloc.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../features/store/presentation/pages/store_page.dart';
import '../../features/store/presentation/pages/web_store_page.dart';
import '../../features/wallet/presentation/pages/finance_page.dart';
import '../../features/wallet/presentation/pages/web_finance_page.dart';
import '../di/injection_container.dart';
import '../presentation/app_shell_page.dart';
import '../presentation/pages/unavailable_page.dart';
import '../presentation/web/web_app_shell_page.dart';
import '../presentation/wpgg_transaction_feedback_host.dart';
import '../../features/missions/presentation/pages/web_dashboard_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

Widget _authFlowRoute(Widget child) {
  return BlocProvider.value(
    value: sl<AuthBloc>(),
    child: child,
  );
}

int shellBranchIndexForNav(int navIndex) {
  if (navIndex <= 1) {
    return navIndex;
  }
  if (navIndex == 2) {
    return 2;
  }
  if (navIndex == 3) {
    return 3;
  }
  if (navIndex == 4) {
    return 4;
  }
  return 0;
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    return normalizeOAuthDeepLinkLocation(state.uri.toString());
  },
  errorBuilder: (context, state) => const UnavailablePage(),
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
      path: '/auth/link-riot',
      builder: (_, __) => _authFlowRoute(const LinkRiotPage()),
    ),
    GoRoute(
      path: '/auth/riot-already-exists',
      builder: (_, __) => const RiotRsoAlreadyExistsPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => _authFlowRoute(const LoginPage()),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => _authFlowRoute(const RegisterPage()),
    ),
    GoRoute(
      path: '/register/check-email',
      builder: (_, state) => _authFlowRoute(
        RegisterCheckEmailPage(
          email: state.uri.queryParameters['email'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (_, __) => _authFlowRoute(const VerifyEmailPage()),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (_, __) => _authFlowRoute(const ForgotPasswordPage()),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (_, __) => _authFlowRoute(const ResetPasswordPage()),
    ),
    GoRoute(
      path: '/missions/pick',
      builder: (_, __) => WpggTransactionFeedbackHost(
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<RiotBloc>()),
            BlocProvider.value(value: sl<MissionsBloc>()),
          ],
          child: const PickMissionsPage(),
        ),
      ),
    ),
    GoRoute(
      path: '/profile/faqs',
      builder: (_, __) => BlocProvider.value(
        value: sl<RiotBloc>(),
        child: const FaqsPage(),
      ),
    ),
    GoRoute(
      path: '/profile/terms',
      builder: (_, __) => BlocProvider.value(
        value: sl<RiotBloc>(),
        child: const TermsPage(),
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
            BlocProvider.value(value: sl<StoreBloc>()),
          ],
          child: WpggTransactionFeedbackHost(
            child: kIsWeb
                ? WebAppShellPage(navigationShell: navigationShell)
                : AppShellPage(navigationShell: navigationShell),
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, __) => kIsWeb
                  ? const WebDashboardPage()
                  : const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/missions/by-day',
              builder: (_, __) => kIsWeb
                  ? const WebMissionsByDayPage()
                  : const MissionsByDayPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/store',
              builder: (_, __) => kIsWeb
                  ? const WebStorePage()
                  : const StorePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/finance',
              builder: (_, __) => kIsWeb
                  ? const WebFinancePage()
                  : const FinancePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => kIsWeb
                  ? const SizedBox.shrink()
                  : const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
