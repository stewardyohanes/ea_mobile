import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tradegenz_app/app/router.dart';
import 'package:tradegenz_app/core/notifications/fcm_service.dart';
import 'package:tradegenz_app/core/theme/app_colors.dart';
import 'package:tradegenz_app/features/auth/providers/auth_provider.dart';
import 'package:tradegenz_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: TradeGenZApp()));
}

class TradeGenZApp extends ConsumerStatefulWidget {
  const TradeGenZApp({super.key});

  @override
  ConsumerState<TradeGenZApp> createState() => _TradeGenZAppState();
}

class _TradeGenZAppState extends ConsumerState<TradeGenZApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(authProvider.notifier).checkSession();

      // Set navigasi saat notifikasi di-tap → buka detail signal
      FcmService.onNotificationTap = (signalId) {
        ref.read(routerProvider).push('/signal/$signalId');
      };

      await FcmService.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'TradeGenZ',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
        ),
      ),
    );
  }
}
