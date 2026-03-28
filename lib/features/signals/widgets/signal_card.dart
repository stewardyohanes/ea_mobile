import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/signal_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

class SignalCard extends ConsumerWidget {
  final Signal signal;
  const SignalCard({required this.signal, super.key});

  Color get _directionColor =>
      signal.isBuy ? AppColors.success : AppColors.error;

  Color get _statusColor {
    if (signal.isTpHit) return AppColors.success;
    if (signal.isSlHit) return AppColors.error;
    if (signal.isActive) return AppColors.primary;
    return AppColors.textMuted;
  }

  String get _statusLabel {
    switch (signal.status) {
      case 'active':
        return 'ACTIVE';
      case 'tp_hit':
        return 'TP HIT';
      case 'sl_hit':
        return 'SL HIT';
      case 'closed':
        return 'CLOSED';
      default:
        return signal.status.toUpperCase();
    }
  }

  String _timeAgo() {
    try {
      final created = DateTime.parse(signal.createdAt);
      final diff = DateTime.now().difference(created);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return signal.createdAt;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(
      authProvider.select((s) => s.user?.isPremium ?? false),
    );

    return GestureDetector(
      onTap: () => {
        if (isPremium)
          {context.push('/signal/${signal.id}')}
        else
          {context.push('/upgrade')},
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: symbol + BUY/SELL badge + status chip
            Row(
              children: [
                Text(signal.symbol, style: AppTextStyles.h3),
                const SizedBox(width: 8),
                _DirectionBadge(
                  label: signal.direction,
                  color: _directionColor,
                ),
                const Spacer(),
                _StatusChip(label: _statusLabel, color: _statusColor),
              ],
            ),

            const SizedBox(height: 12),

            // Entry price area
            isPremium
                ? _PremiumPriceBlock(signal: signal, timeAgo: _timeAgo())
                : _LockedPriceRow(onTap: () => context.push('/upgrade')),
          ],
        ),
      ),
    );
  }
}

// --- Premium price block: ENTRY PRICE besar + STOP LOSS | TAKEPROFIT + R:R ---
class _PremiumPriceBlock extends StatelessWidget {
  final Signal signal;
  final String timeAgo;
  const _PremiumPriceBlock({required this.signal, required this.timeAgo});

  bool get _isBullish => signal.trend.toUpperCase().contains('BULL');
  int get _dec => signal.entry1 > 100 ? 2 : 5;

  @override
  Widget build(BuildContext context) {
    final trendColor =
        _isBullish ? AppColors.secondaryContainer : AppColors.error;
    final trendIcon = _isBullish ? Icons.trending_up : Icons.trending_down;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ENTRY PRICE label + value
        Text(
          'ENTRY PRICE',
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              signal.entry1.toStringAsFixed(_dec),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1,
              ),
            ),
            const Spacer(),
            if (signal.trend.isNotEmpty) ...[
              Icon(trendIcon, color: trendColor, size: 16),
              const SizedBox(width: 4),
              Text(
                signal.trend.toUpperCase(),
                style: AppTextStyles.label.copyWith(
                  color: trendColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 10),
        Divider(
          color: AppColors.outlineVariant.withValues(alpha: 0.2),
          height: 1,
        ),
        const SizedBox(height: 8),

        // STOP LOSS | TAKEPROFIT row
        Row(
          children: [
            _PriceLabel(
              label: 'STOP LOSS',
              value: signal.sl.toStringAsFixed(_dec),
              color: AppColors.error,
            ),
            const SizedBox(width: 20),
            if (signal.tp != null)
              _PriceLabel(
                label: 'TAKEPROFIT',
                value: signal.tp!.toStringAsFixed(_dec),
                color: AppColors.secondaryContainer,
              ),
            const Spacer(),
            // Time + R:R
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeAgo, style: AppTextStyles.caption),
                if (signal.riskReward != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'R:R 1:${signal.riskReward!.toStringAsFixed(1)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _PriceLabel({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// --- Direction badge (BUY green / SELL red) ---
class _DirectionBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _DirectionBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// --- Status chip (ACTIVE=primary, TP HIT=green, SL HIT=red) ---
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// --- Locked price row for free users ---
class _LockedPriceRow extends StatelessWidget {
  final VoidCallback onTap;
  const _LockedPriceRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, color: AppColors.primary, size: 14),
            const SizedBox(width: 6),
            Text(
              'Upgrade to see Entry, SL & TP',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
