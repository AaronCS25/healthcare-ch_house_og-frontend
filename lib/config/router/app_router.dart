import 'package:go_router/go_router.dart';
import 'package:rimac_app/features/shared/shared.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (context, state) => const RootScreen())],
);
