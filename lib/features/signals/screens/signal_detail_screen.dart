import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/signals_api.dart';
import '../models/signal_model.dart';
import '../widgets/price_ladder.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

// FutureProvider dengan parameter ID — fetch signal by ID
// Setara useEffect + useState untuk fetch single item di RN
final signalDetailProvider = FutureProvider.family<Signal, String>((
  ref,
  id,
) async {
  return SignalsApi.getSignalById(id);
});

class SignalDetailScreen extends ConsumerWidget {
  final String signalId;
  const SignalDetailScreen({required this.signalId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FutureProvider.family diakses dengan .call(id)
    final signalAsync = ref.watch(signalDetailProvider(signalId));
    final isPremium = ref.watch(
      authProvider.select((s) => s.user?.isPremium ?? false),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signal Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      // signalAsync.when() = handle 3 state: loading, error, data
      // Setara conditional rendering berdasarkan status di RN
      body: signalAsync.when(
        loading: () => const _DetailSkeleton(),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to load signal', style: AppTextStyles.body),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(signalDetailProvider(signalId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (signal) => _DetailContent(signal: signal, isPremium: isPremium),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final Signal signal;
  final bool isPremium;
  const _DetailContent({required this.signal, required this.isPremium});

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — symbol + badges
          Row(
            children: [
              Text(signal.symbol, style: AppTextStyles.h1),
              const SizedBox(width: 12),
              _Badge(label: signal.direction, color: _directionColor),
              const Spacer(),
              _Badge(label: _statusLabel, color: _statusColor),
            ],
          ),

          const SizedBox(height: 8),

          // Timestamp
          Text('Created: ${signal.createdAt}', style: AppTextStyles.caption),

          const SizedBox(height: 24),

          // Trend + R:R Ratio
          Row(
            children: [
              if (signal.trend.isNotEmpty) ...[
                Text('Trend', style: AppTextStyles.label),
                const Spacer(),
                Text(signal.trend, style: AppTextStyles.h3),
              ],
            ],
          ),
          if (signal.trend.isNotEmpty) const SizedBox(height: 12),

          if (signal.riskReward != null) ...[
            Row(
              children: [
                Text('Risk/Reward', style: AppTextStyles.label),
                const Spacer(),
                Text(
                  '1 : ${signal.riskReward!.toStringAsFixed(2)}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.gold),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Price Ladder
          Text('Price Levels', style: AppTextStyles.label),
          const SizedBox(height: 8),
          PriceLadder(signal: signal, isPremium: isPremium),

          // Upgrade CTA kalau free
          if (!isPremium) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => context.push('/upgrade'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.purple.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_open, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unlock Full Signal Detail',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Upgrade to see Entry, SL & TP levels',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ],


          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// Badge widget
class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Skeleton loading
class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 120, height: 36),
          const SizedBox(height: 24),
          _SkeletonBox(width: double.infinity, height: 200),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  const _SkeletonBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
