import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradegenz_app/core/theme/app_colors.dart';

/// Header section login: terminal icon box + title TRADEGENZ + subtitle
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Terminal icon box
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
              ),
            ],
          ),
          child: const Icon(
            Icons.terminal,
            color: AppColors.primary,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'TRADEGENZ',
          style: GoogleFonts.inter(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'SECURE QUANTUM TERMINAL ACCESS',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
            letterSpacing: 2.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
