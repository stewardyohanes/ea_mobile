import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tradegenz_app/core/theme/app_colors.dart';

/// Hero visual onboarding: Lottie animation di dalam container rounded
/// dengan glass chip overlay di bawah (MT4 connection status).
class OnboardingHero extends StatelessWidget {
  const OnboardingHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 50,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Lottie animation sebagai hero visual
                Positioned.fill(
                  child: ColoredBox(
                    color: AppColors.surfaceContainerLow,
                    child: Lottie.asset(
                      'assets/animations/business-sales-profit.json',
                      fit: BoxFit.cover,
                      repeat: true,
                    ),
                  ),
                ),

                // Gradient fade ke bawah (supaya chip overlay terbaca)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background.withValues(alpha: 0.65),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Glass chip: MT4 Connection status
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: _ConnectionChip(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConnectionChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MT4 CONNECTION',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  color: AppColors.outline,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'STABLE: 12ms',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF47FFBB), // secondary-fixed
                ),
              ),
            ],
          ),
          // Signal bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Bar(height: 12, active: true),
              const SizedBox(width: 2),
              _Bar(height: 12, active: true),
              const SizedBox(width: 2),
              _Bar(height: 12, active: true),
              const SizedBox(width: 2),
              _Bar(height: 5, active: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final bool active;
  const _Bar({required this.height, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF47FFBB)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
