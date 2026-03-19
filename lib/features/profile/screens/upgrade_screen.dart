import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/plan_card_item.dart';
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

  Future<void> _contactWhatsApp(String plan, String price) async {
    final message = Uri.encodeComponent(
      'Halo, saya ingin upgrade ke plan $plan ($price) di TradeGenZ.',
    );
    final uri = Uri.parse('https://wa.me/62XXXXXXXXXXX?text=$message');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _contactWhatsAppAffiliate() async {
    final message = Uri.encodeComponent(
      'Halo, saya ingin aktivasi Affiliate Plan di TradeGenZ.',
    );
    final uri = Uri.parse('https://wa.me/62XXXXXXXXXXX?text=$message');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Plan'),
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
            Text('Choose Your Plan', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Unlock full access to all trading signals',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
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
                    label: 'Monthly',
                    isActive: !_isYearly,
                    onTap: () => setState(() => _isYearly = false),
                  ),
                  _BillingTab(
                    label: 'Yearly',
                    isActive: _isYearly,
                    onTap: () => setState(() => _isYearly = true),
                    badge: 'Save 33%',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // FREE Plan
            PlanCardItem(
              name: 'Free',
              price: '\$0',
              period: '/ forever',
              color: AppColors.textMuted,
              features: const [
                'Realtime signal direction (BUY/SELL)',
                'See trading pair & status',
                'Signal history (limited)',
              ],
              lockedFeatures: const [
                'Entry price, SL & TP hidden',
                'No push notifications',
              ],
              onTap: () => context.pop(),
              buttonLabel: 'Current Plan',
            ),

            // PREMIUM Plan
            PlanCardItem(
              name: 'Premium',
              price: _isYearly ? '\$80' : '\$10',
              period: _isYearly ? '/ year (\$6.7/mo)' : '/ month',
              color: AppColors.primary,
              isPopular: true,
              features: const [
                'Full signal detail (Entry, SL, TP)',
                'Realtime push notifications',
                'All trading pairs',
                'Complete signal history',
                'No ads',
              ],
              lockedFeatures: const [],
              onTap: () => _contactWhatsApp(
                'Premium',
                _isYearly ? '\$80/year' : '\$10/month',
              ),
              buttonLabel: 'Get Premium',
            ),

            // AFFILIATE Plan
            PlanCardItem(
              name: 'Affiliate',
              price: 'FREE',
              period: '(via broker)',
              color: AppColors.purple,
              features: const [
                'Everything in Premium',
                'Register via our broker link',
                'No monthly fee',
                'Active trading required',
              ],
              lockedFeatures: const [],
              onTap: _contactWhatsAppAffiliate,
              buttonLabel: 'Register via Broker',
            ),

            const SizedBox(height: 16),

            Text(
              'Contact us via WhatsApp to activate your plan',
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
