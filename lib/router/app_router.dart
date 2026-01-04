import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';

class AppRouter {
  final AuthService _authService = AuthService();

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final isLoggedIn = await _authService.isLoggedIn();
      final isLoggingIn = state.matchedLocation == '/login';

      // 如果未登入且不在登入頁，重導向到登入頁
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // 如果已登入且在登入頁，重導向到首頁
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DashboardScreen(selectedMenu: 'home'),
      ),
      GoRoute(
        path: '/users',
        builder: (context, state) => const DashboardScreen(selectedMenu: 'users'),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const DashboardScreen(selectedMenu: 'settings'),
      ),
    ],
  );
}
