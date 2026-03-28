import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  const ProfileHeader({required this.user, super.key});

  String get _initials {
    final name = user.name ?? '';
    if (name.trim().isNotEmpty) {
      final parts = name.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    if (user.email.isNotEmpty) return user.email[0].toUpperCase();
    return '?';
  }

  Color get _planColor {
    if (user.isAffiliate) return AppColors.purple;
    if (user.isPremium) return AppColors.tertiary;
    return AppColors.outline;
  }

  String get _planLabel {
    if (user.isAffiliate) return 'AFFILIATE';
    if (user.isPremium) return 'PREMIUM';
    return 'FREE';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar — lingkaran dengan inisial + ring sesuai plan color
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _planColor.withValues(alpha: 0.5), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: GoogleFonts.inter(
                    color: AppColors.onPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Name (kalau ada) atau email
        if (user.name != null && user.name!.isNotEmpty) ...[
          Text(
            user.name!,
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: AppTextStyles.caption,
          ),
        ] else ...[
          Text(user.email, style: AppTextStyles.body),
        ],

        const SizedBox(height: 10),

        // Plan badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: _planColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _planColor.withValues(alpha: 0.4)),
          ),
          child: Text(
            _planLabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _planColor,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
