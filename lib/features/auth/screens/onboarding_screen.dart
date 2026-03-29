import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradegenz_app/core/extensions/l10n_extension.dart';
import 'package:tradegenz_app/core/storage/secure_storage.dart';
import 'package:tradegenz_app/core/theme/app_colors.dart';
import 'package:tradegenz_app/core/theme/app_text_styles.dart';
import 'package:tradegenz_app/features/auth/widgets/onboarding_feature_item.dart';
import 'package:tradegenz_app/features/auth/widgets/onboarding_hero.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<void> _onGetStarted() async {
    await SecureStorage.setOnboardingDone();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Stack(
        children: [
          // Ambient glow — top left
          Positioned(
            top: -80,
            left: -80,
            child: _GlowBlob(
              color: AppColors.primary.withValues(alpha: 0.08),
              size: 320,
            ),
          ),
          // Ambient glow — center right
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            right: -80,
            child: _GlowBlob(
              color: AppColors.secondaryContainer.withValues(alpha: 0.05),
              size: 220,
            ),
          ),

          // Main layout: header (fixed) + scrollable content + footer CTA (fixed)
          SafeArea(
            child: Column(
              children: [
                // Header: terminal icon + TRADEGENZ
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.terminal,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.onboardingTitle,
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      children: [
                        // Hero visual: Lottie + glass chip
                        const OnboardingHero(),

                        const SizedBox(height: 32),

                        // Tagline
                        Text(
                          l10n.onboardingSubtitle,
                          style: AppTextStyles.h2.copyWith(height: 1.2),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        // Description
                        Text(
                          l10n.onboardingDescription,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 28),

                        // Feature 1: Real-time EA Signals
                        OnboardingFeatureItem(
                          icon: Icons.insights,
                          iconColor: AppColors.primary,
                          iconBg: const Color(0x1AB0C6FF),
                          title: l10n.featureSignalsTitle,
                          subtitle: l10n.featureSignalsDesc,
                        ),

                        const SizedBox(height: 12),

                        // Feature 2: Lot Size Calculator
                        OnboardingFeatureItem(
                          icon: Icons.calculate_outlined,
                          iconColor: AppColors.secondaryContainer,
                          iconBg: const Color(0x1A00E5A0),
                          title: l10n.featureCalculatorTitle,
                          subtitle: l10n.featureCalculatorDesc,
                        ),

                        const SizedBox(height: 12),

                        // Feature 3: Win Rate Analytics
                        OnboardingFeatureItem(
                          icon: Icons.analytics_outlined,
                          iconColor: AppColors.tertiary,
                          iconBg: const Color(0x1AFFBA20),
                          title: l10n.featureAnalyticsTitle,
                          subtitle: l10n.featureAnalyticsDesc,
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Footer CTA — fixed at bottom
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: Column(
                    children: [
                      _GetStartedButton(onPressed: _onGetStarted),
                      const SizedBox(height: 20),
                      Text(
                        l10n.institutionalGrade,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: AppColors.outline,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _GetStartedButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.getStarted,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              color: AppColors.onPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Blurred color blob for ambient glow effect.
class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: 70, sigmaY: 70),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
