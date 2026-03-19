import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/plan_card.dart';
import '../widgets/settings_tile.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse('https://wa.me/628xxxxxxxxxx');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ConsumerWidget — ref langsung di parameter build, tidak butuh StatefulWidget
    // karena screen ini tidak punya state lokal
    final user = ref.watch(authProvider).user;

    // Kalau user null (harusnya tidak terjadi di screen ini), balik kosong
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — avatar + email + plan badge
            Center(child: ProfileHeader(user: user)),

            const SizedBox(height: 24),

            // Plan card
            PlanCard(user: user),

            const SizedBox(height: 24),

            // Section: Account
            if (user.isAffiliate) ...[
              SettingsSection(
                title: 'Account',
                children: [
                  SettingsTile(
                    icon: Icons.card_giftcard,
                    title: 'Referral Code',
                    subtitle: user.referralCode ?? '-',
                    iconColor: AppColors.purple,
                    // Copy referral code ke clipboard
                    onTap: () {
                      if (user.referralCode != null) {
                        Clipboard.setData(
                          ClipboardData(text: user.referralCode!),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Referral code copied!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Section: Support
            SettingsSection(
              title: 'Support',
              children: [
                SettingsTile(
                  icon: Icons.chat,
                  title: 'Contact via WhatsApp',
                  subtitle: 'Chat with our team',
                  iconColor: AppColors.success,
                  onTap: _launchWhatsApp,
                ),
                const Divider(height: 1, color: AppColors.divider, indent: 56),
                SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help & FAQ',
                  onTap: () {}, // nanti bisa buka webview
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Section: About
            SettingsSection(
              title: 'About',
              children: [
                SettingsTile(
                  icon: Icons.info_outline,
                  title: 'App Version',
                  subtitle: '1.0.0',
                  iconColor: AppColors.textMuted,
                  trailing: const SizedBox.shrink(), // tidak ada arrow
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  // GoRouter redirect otomatis ke /login setelah logout
                  // karena isAuthenticated = false
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
