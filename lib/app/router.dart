import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tradegenz_app/core/storage/secure_storage.dart';
import 'package:tradegenz_app/features/auth/providers/auth_provider.dart';

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

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isLoggedIn = authState.isAuthenticated;
      final isOnboardingDone = await SecureStorage.isOnboardingDone();

      final currentPath = state.uri.path;

      if (!isOnboardingDone && currentPath != '/onboarding') {
        return '/onboarding';
      }

      final protectedRoutes = ['/', '/history', 'analytics', '/profile'];
      if (!isLoggedIn && protectedRoutes.contains(currentPath)) {
        return '/login';
      }

      if (isLoggedIn &&
          (currentPath == '/login' || currentPath == '/onboarding')) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const _PlaceholderScreen('Onboarding'),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const _PlaceholderScreen('Login'),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const _PlaceholderScreen('Register'),
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

class _TabShell extends StatelessWidget {
  final Widget child;
  const _TabShell({required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/analytics')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // default to feed
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child, // konten screen yang aktif
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
