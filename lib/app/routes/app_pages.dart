import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../views/splash/splash_page.dart';
import '../views/dashboard/dashboard_page.dart';

/// GoRouter: splash → dashboard (tabs handled inside DashboardPage).
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
}
