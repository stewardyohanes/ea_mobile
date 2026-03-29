import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tradegenz_app/app/router.dart';
import 'package:tradegenz_app/core/extensions/l10n_extension.dart';
import 'package:tradegenz_app/core/notifications/fcm_service.dart';
import 'package:tradegenz_app/core/theme/app_theme.dart';
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
      theme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
