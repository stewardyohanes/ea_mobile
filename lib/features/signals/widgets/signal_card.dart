import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/signal_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _directionColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            // Row 1: Symbol + Direction + Status
            Row(
              children: [
                Text(signal.symbol, style: AppTextStyles.h3),
                const SizedBox(width: 8),
                _Badge(label: signal.direction, color: _directionColor),
                if (signal.trend.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  _Badge(label: signal.trend, color: AppColors.textMuted),
                ],
                const Spacer(),
                _Badge(label: _statusLabel, color: _statusColor),
              ],
            ),

            const SizedBox(height: 12),

            // Row 2: Harga — blur kalau free
            isPremium
                ? _PriceRow(signal: signal)
                : _LockedPriceRow(onTap: () => context.push('/upgrade')),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final Signal signal;
  const _PriceRow({required this.signal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PriceColumn(
          label: 'Entry',
          value: signal.entry1.toStringAsFixed(2),
          color: AppColors.textPrimary,
        ),
        const SizedBox(width: 16),
        _PriceColumn(
          label: 'Stop Loss',
          value: signal.sl.toStringAsFixed(2),
          color: AppColors.error,
        ),
        if (signal.tp != null) ...[
          const SizedBox(width: 16),
          _PriceColumn(
            label: 'Take Profit',
            value: signal.tp!.toStringAsFixed(2),
            color: AppColors.success,
          ),
        ],
        const Spacer(),
        if (signal.riskReward != null)
          Text(
            '1:${signal.riskReward!.toStringAsFixed(2)}',
            style: AppTextStyles.label.copyWith(color: AppColors.gold),
          ),
      ],
    );
  }
}

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

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

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

class _PriceColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _PriceColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.price.copyWith(color: color)),
      ],
    );
  }
}
