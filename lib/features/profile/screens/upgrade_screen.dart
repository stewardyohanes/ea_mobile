import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/plan_card_item.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  // Toggle billing period — monthly atau yearly
  bool _isYearly = false;

  Future<void> _contactWhatsApp(BuildContext context, String plan, String price) async {
    final message = Uri.encodeComponent(
      context.l10n.whatsappUpgradeMessage(plan, price),
    );
    final uri = Uri.parse('https://wa.me/62XXXXXXXXXXX?text=$message');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _contactWhatsAppAffiliate(BuildContext context) async {
    final message = Uri.encodeComponent(
      context.l10n.whatsappAffiliateMessage,
    );
    final uri = Uri.parse('https://wa.me/62XXXXXXXXXXX?text=$message');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.upgradePlanTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header banner — "Proprietary Alpha Access"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryContainer.withValues(alpha: 0.2),
                    AppColors.primary.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.bolt,
                        color: AppColors.tertiary,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        context.l10n.proprietaryAlphaAccess,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tertiary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(context.l10n.upgradePremiumTitle, style: AppTextStyles.h2),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.upgradePremiumSubtitle,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Billing toggle — Monthly / Yearly
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BillingTab(
                    label: context.l10n.billingMonthly,
                    isActive: !_isYearly,
                    onTap: () => setState(() => _isYearly = false),
                  ),
                  _BillingTab(
                    label: context.l10n.billingYearly,
                    isActive: _isYearly,
                    onTap: () => setState(() => _isYearly = true),
                    badge: context.l10n.save33,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // FREE Plan
            PlanCardItem(
              name: context.l10n.planFree,
              price: context.l10n.priceFree,
              period: context.l10n.priceForever,
              color: AppColors.textMuted,
              features: [
                context.l10n.freePlanFeature1,
                context.l10n.freePlanFeature2,
                context.l10n.freePlanFeature3,
              ],
              lockedFeatures: [
                context.l10n.freePlanFeature4,
                context.l10n.freePlanFeature5,
              ],
              onTap: () => context.pop(),
              buttonLabel: context.l10n.currentPlan,
            ),

            // PREMIUM Plan
            PlanCardItem(
              name: context.l10n.planPremium,
              price: _isYearly ? context.l10n.pricePremiumYearly : context.l10n.pricePremiumMonthly,
              period: _isYearly ? context.l10n.pricePerYear : context.l10n.pricePerMonth,
              color: AppColors.primary,
              isPopular: true,
              features: [
                context.l10n.premiumPlanFeature1,
                context.l10n.premiumPlanFeature2,
                context.l10n.premiumPlanFeature3,
                context.l10n.premiumPlanFeature4,
                context.l10n.premiumPlanFeature5,
              ],
              lockedFeatures: const [],
              onTap: () => _contactWhatsApp(
                context,
                'Premium',
                _isYearly ? '\$80/year' : '\$10/month',
              ),
              buttonLabel: context.l10n.getPremium,
            ),

            // AFFILIATE Plan
            PlanCardItem(
              name: context.l10n.planAffiliate,
              price: context.l10n.priceAffiliate,
              period: context.l10n.priceViaBroker,
              color: AppColors.purple,
              features: [
                context.l10n.affiliatePlanFeature1,
                context.l10n.affiliatePlanFeature2,
                context.l10n.affiliatePlanFeature3,
                context.l10n.affiliatePlanFeature4,
              ],
              lockedFeatures: const [],
              onTap: () => _contactWhatsAppAffiliate(context),
              buttonLabel: context.l10n.registerViaBroker,
            ),

            const SizedBox(height: 16),

            Text(
              context.l10n.contactWhatsAppActivate,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Toggle tab widget
class _BillingTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final String? badge;

  const _BillingTab({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isActive ? AppColors.textPrimary : AppColors.textMuted,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
