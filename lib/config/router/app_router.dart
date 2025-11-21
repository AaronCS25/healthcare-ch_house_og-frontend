import 'package:go_router/go_router.dart';

import 'package:rimac_app/features/chat/chat.dart';
import 'package:rimac_app/features/shared/shared.dart';
import 'package:rimac_app/features/profile/profile.dart';
import 'package:rimac_app/features/dashboard/dashboard.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
