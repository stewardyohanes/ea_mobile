import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/storage/secure_storage.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/register_screen.dart';

// RouterNotifier = jembatan antara Riverpod dan GoRouter
// GoRouter butuh ChangeNotifier untuk tahu kapan harus re-evaluate redirect
// Riverpod tidak bisa langsung dipakai di GoRouter, jadi kita buat wrapper ini
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // ref.listen = watch tapi dari luar widget tree
    // Setiap kali authProvider berubah → notifyListeners()
    // → GoRouter re-evaluate redirect
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }

  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    // ref.read (bukan watch) karena ini dipanggil di luar widget
    final authState = _ref.read(authProvider);
    final isLoggedIn = authState.isAuthenticated;
    final isOnboardingDone = await SecureStorage.isOnboardingDone();
    final currentPath = state.uri.path;

    if (!isOnboardingDone && currentPath != '/onboarding') {
      return '/onboarding';
    }

    final protectedRoutes = ['/', '/history', '/analytics', '/profile'];
    if (!isLoggedIn && protectedRoutes.contains(currentPath)) {
      return '/login';
    }

    if (isLoggedIn &&
        (currentPath == '/login' ||
            currentPath == '/register' ||
            currentPath == '/onboarding')) {
      return '/';
    }

    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  // Buat notifier sekali, simpan di provider
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    // refreshListenable = GoRouter akan re-evaluate redirect
    // setiap kali notifier.notifyListeners() dipanggil
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/disclaimer',
        builder: (context, state) => const _PlaceholderScreen('Disclaimer'),
      ),
      ShellRoute(
        builder: (context, state, child) => _TabShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const _PlaceholderScreen('Feed'),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const _PlaceholderScreen('History'),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const _PlaceholderScreen('Analytics'),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const _PlaceholderScreen('Profile'),
          ),
        ],
      ),
      GoRoute(
        path: '/signal/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return _PlaceholderScreen('Signal Detail: $id');
        },
      ),
      GoRoute(
        path: '/upgrade',
        builder: (context, state) => const _PlaceholderScreen('Upgrade'),
      ),
    ],
  );
});

class _PlaceholderScreen extends StatelessWidget {
  final String name;
  const _PlaceholderScreen(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(name, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _TabShell extends StatelessWidget {
  final Widget child;
  const _TabShell({required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/analytics')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _locationToIndex(location),
        backgroundColor: const Color(0xFF0D1F3C),
        selectedItemColor: const Color(0xFF2979FF),
        unselectedItemColor: const Color(0xFF7A88A8),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/history');
              break;
            case 2:
              context.go('/analytics');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_alt),
            label: 'Signals',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
