import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradegenz_app/core/extensions/l10n_extension.dart';
import 'package:tradegenz_app/core/theme/app_colors.dart';
import 'package:tradegenz_app/features/auth/providers/auth_provider.dart';
import 'package:tradegenz_app/features/auth/widgets/login_form_card.dart';
import 'package:tradegenz_app/features/auth/widgets/login_header.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    await ref.read(authProvider.notifier).login(email, password);
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background glow — kiri atas (primary)
          Positioned(
            top: -80,
            left: -80,
            child: _GlowBlob(
              color: AppColors.primary.withValues(alpha: 0.1),
              size: 280,
            ),
          ),
          // Background glow — kanan bawah (secondary)
          Positioned(
            bottom: -80,
            right: -80,
            child: _GlowBlob(
              color: AppColors.secondaryContainer.withValues(alpha: 0.08),
              size: 220,
            ),
          ),

          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Header: icon + TRADEGENZ + subtitle
                  const LoginHeader(),

                  const SizedBox(height: 40),

                  // Form card: inputs + button + integrity footer
                  LoginFormCard(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    obscurePassword: _obscurePassword,
                    isLoading: authState.isLoading,
                    errorMessage: authState.error,
                    onToggleObscure: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    onLogin: _onLogin,
                    onForgotPassword: () => context.push('/forgot-password'),
                  ),

                  const SizedBox(height: 28),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.dontHaveAccount,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/register'),
                        child: Text(
                          context.l10n.registerNow,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF47FFBB), // secondary-fixed
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF47FFBB),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Blurred color blob untuk background glow effect.
/// Setara CSS: `filter: blur(100px)` pada colored circle.
class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
