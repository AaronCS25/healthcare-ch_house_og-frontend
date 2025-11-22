import 'package:go_router/go_router.dart';

import 'package:rimac_app/config/config.dart';
import 'package:rimac_app/features/auth/auth.dart';
import 'package:rimac_app/features/chat/chat.dart';
import 'package:rimac_app/features/shared/shared.dart';
import 'package:rimac_app/features/profile/profile.dart';
import 'package:rimac_app/features/dashboard/dashboard.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: AppRouterNotifier(ServiceLocator.get<AuthCubit>()),
  redirect: (context, state) {
    final destination = state.matchedLocation;
    final authStatus = ServiceLocator.get<AuthCubit>().state.status;

    if (destination == '/splash' && authStatus == AuthStatus.checking) {
      return null;
    }

    if (authStatus == AuthStatus.unauthenticated) {
      if (destination == '/login') {
        return null;
      }
      return '/login';
    }

    if (authStatus == AuthStatus.authenticated) {
      if (destination == '/login' || destination == '/splash') {
        return '/';
      }
      return null;
    }

    return null;
  },
  routes: [
    // ** Auth Routes **
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

    // ** Root Routes **
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          RootScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chat',
              builder: (context, state) => const ChatScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
