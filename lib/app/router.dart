import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tradegenz_app/features/auth/screens/disclaimer_screen.dart';
import 'package:tradegenz_app/features/calculator/screens/calculator_screen.dart';
import 'package:tradegenz_app/features/profile/screens/profile_screen.dart';
import 'package:tradegenz_app/features/profile/screens/upgrade_screen.dart';
import 'package:tradegenz_app/features/signals/screens/feed_screen.dart';
import 'package:tradegenz_app/features/signals/screens/history_screen.dart';
import 'package:tradegenz_app/features/signals/screens/signal_detail_screen.dart';
import 'package:tradegenz_app/shared/widgets/network_banner.dart';
import '../core/storage/secure_storage.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';

// RouterNotifier = jembatan antara Riverpod dan GoRouter
// GoRouter butuh ChangeNotifier untuk tahu kapan harus re-evaluate redirect
// Riverpod tidak bisa langsung dipakai di GoRouter, jadi kita buat wrapper ini
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // ref.listen = watch tapi dari luar widget tree
    // Setiap kali authProvider berubah → notifyListeners()
    // → GoRouter re-evaluate redirect
    _ref.listen(authProvider, (_, _) => notifyListeners());
  }

  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    // ref.read (bukan watch) karena ini dipanggil di luar widget
    final authState = _ref.read(authProvider);
    final isLoggedIn = authState.isAuthenticated;
    final isOnboardingDone = await SecureStorage.isOnboardingDone();
    final isDisclaimerAccepted = await SecureStorage.isDisclaimerAccepted();
    final currentPath = state.uri.path;

    if (!isOnboardingDone && currentPath != '/onboarding') {
      return '/onboarding';
    }

    if (isLoggedIn && !isDisclaimerAccepted && currentPath != '/disclaimer') {
      return '/disclaimer';
    }

    final protectedRoutes = ['/', '/history', '/calculator', '/profile'];
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
        builder: (context, state) => const DisclaimerScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return OtpVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return ResetPasswordScreen(
            email: extra['email'] ?? '',
            otp: extra['otp'] ?? '',
          );
        },
      ),
      ShellRoute(
        builder: (context, state, child) => _TabShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const FeedScreen()),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/calculator',
            builder: (context, state) => const CalculatorScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/signal/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SignalDetailScreen(signalId: id);
        },
      ),
      GoRoute(
        path: '/upgrade',
        builder: (context, state) => const UpgradeScreen(),
      ),
    ],
  );
});

class _TabShell extends StatelessWidget {
  final Widget child;
  const _TabShell({required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/calculator')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: Column(
        children: [
          const NetworkBanner(),
          Expanded(child: child),
        ],
      ),
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
              context.go('/calculator');
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
            icon: Icon(Icons.calculate_outlined),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
