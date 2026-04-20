import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/profile_header.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/user_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _launchEmail() async {
    final uri = Uri.parse('mailto:chloeder29@gmail.com');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchPrivacyPolicy() async {
    final uri = Uri.parse('https://www.tradegenz.com/privacy-policy');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final user = authState.user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.terminal, size: 20),
            const SizedBox(width: 8),
            Text(context.l10n.profileTitle),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () => ref.read(authProvider.notifier).refreshUser(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              Center(child: ProfileHeader(user: user)),

              const SizedBox(height: 20),

              _StatsGrid(user: user),

              const SizedBox(height: 16),

              _PlanCard(user: user),

              const SizedBox(height: 16),

              if (user.isAffiliate) ...[
                _SettingsGroup(
                  title: context.l10n.accountSection,
                  children: [
                    _SettingsRow(
                      icon: Icons.share,
                      label: context.l10n.referralCode,
                      trailing: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.outlineVariant.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Text(
                              user.referralCode ?? '—',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (user.referralCode != null) {
                                Clipboard.setData(
                                  ClipboardData(text: user.referralCode!),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.l10n.referralCodeCopied,
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: const Icon(
                              Icons.content_copy,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              _SettingsGroup(
                title: context.l10n.supportSection,
                children: [
                  _SettingsRow(
                    icon: Icons.email_outlined,
                    iconColor: AppColors.secondaryContainer,
                    label: context.l10n.contactEmail,
                    onTap: _launchEmail,
                  ),
                  _SettingsRow(
                    icon: Icons.help_outline,
                    label: context.l10n.helpFaq,
                    onTap: () => context.push('/faq'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              _SettingsGroup(
                title: context.l10n.aboutSection,
                children: [
                  _SettingsRow(
                    icon: Icons.info_outline,
                    label: context.l10n.appVersion,
                    trailing: Text(
                      context.l10n.appVersionNumber,
                      style: AppTextStyles.caption,
                    ),
                    showChevron: false,
                  ),
                  _SettingsRow(
                    icon: Icons.gavel,
                    label: context.l10n.privacyPolicy,
                    onTap: _launchPrivacyPolicy,
                  ),
                  _SettingsRow(
                    icon: Icons.description_outlined,
                    label: context.l10n.termsOfService,
                    onTap: () => context.push('/terms'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: Text(
                    context.l10n.logoutAccount,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                      letterSpacing: 1.5,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stats Grid ───────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final User user;
  const _StatsGrid({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: context.l10n.winRateStat,
            value: user.winRate != null ? '${user.winRate}' : '—',
            unit: '%',
            accentColor: AppColors.secondaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: context.l10n.totalSignalsStat,
            value: user.totalSignals?.toString() ?? '—',
            unit: 'X',
            accentColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color accentColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                  height: 1,
                ),
              ),
              const SizedBox(width: 3),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: accentColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Plan Card ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final User user;
  const _PlanCard({required this.user});

  Color get _color =>
      user.isAffiliate ? AppColors.purple : AppColors.tertiary;

  @override
  Widget build(BuildContext context) {
    if (!user.isPremium) return _FreePlanCard();

    final planTitle = user.isAffiliate
        ? context.l10n.activeAffiliate
        : context.l10n.activePremium;
    final List<String> features = [
      context.l10n.premiumFeature1,
      context.l10n.premiumFeature2,
      context.l10n.premiumFeature3,
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainerHighest,
            AppColors.surfaceContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planTitle.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: _color,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (user.planExpiry != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.planExpires(user.planExpiry!),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              Icon(Icons.workspace_premium, color: _color, size: 28),
            ],
          ),
          const SizedBox(height: 20),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Color(0xFF47FFBB),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(f, style: AppTextStyles.bodySmall),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FreePlanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.purple.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.upgradeToPremium, style: AppTextStyles.h4),
                const SizedBox(height: 4),
                Text(
                  context.l10n.unlockSignalsAlerts,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => context.push('/upgrade'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size.zero,
            ),
            child: Text(
              context.l10n.upgrade,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Settings Group ───────────────────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.outline,
                letterSpacing: 3,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.iconColor,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor ?? AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: AppTextStyles.bodyMedium),
            ),
            ?trailing,
            if (trailing == null && showChevron)
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.outline,
              ),
          ],
        ),
      ),
    );
  }
}
