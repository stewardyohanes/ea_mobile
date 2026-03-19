import 'package:flutter/material.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  const ProfileHeader({required this.user, super.key});

  // Ambil inisial dari email kalau name kosong
  String get _initials {
    final name = user.name ?? '';
    if (name.isNotEmpty) return name[0].toUpperCase();
    if (user.email.isNotEmpty) return user.email[0].toUpperCase();
    return '?';
  }

  Color get _planColor {
    if (user.isAffiliate) return AppColors.purple;
    if (user.isPremium) return AppColors.gold;
    return AppColors.textMuted;
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
        // Avatar lingkaran dengan inisial
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Email
        Text(user.email, style: AppTextStyles.body),

        const SizedBox(height: 6),

        // Plan badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _planColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _planColor.withValues(alpha: 0.4)),
          ),
          child: Text(
            _planLabel,
            style: AppTextStyles.caption.copyWith(
              color: _planColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
