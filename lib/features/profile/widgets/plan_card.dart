import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PlanCard extends StatelessWidget {
  final User user;
  const PlanCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    if (user.isPremium || user.isAffiliate) return _ActivePlanCard(user: user);
    return _UpgradeCard();
  }
}

// Card untuk user premium/affiliate — tampilkan info plan
class _ActivePlanCard extends StatelessWidget {
  final User user;
  const _ActivePlanCard({required this.user});

  Color get _color => user.isAffiliate ? AppColors.purple : AppColors.gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            user.isAffiliate ? Icons.diamond : Icons.workspace_premium,
            color: _color,
            size: 28,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.isAffiliate ? context.l10n.affiliatePlanCard : context.l10n.premiumPlanCard,
                style: AppTextStyles.h3.copyWith(color: _color),
              ),
              if (user.planExpiry != null)
                Text(
                  context.l10n.planActiveUntil(user.planExpiry!),
                  style: AppTextStyles.caption,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Card untuk free user — ajak upgrade
class _UpgradeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.purple.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.upgradeToPremium,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.getPremiumUnlock,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => context.push('/upgrade'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              context.l10n.upgrade,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
