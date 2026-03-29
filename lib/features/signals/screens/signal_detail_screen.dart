import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/signals_api.dart';
import '../models/signal_model.dart';
import '../widgets/price_ladder.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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
    final signalAsync = ref.watch(signalDetailProvider(signalId));
    final isPremium = ref.watch(
      authProvider.select((s) => s.user?.isPremium ?? false),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.terminal, size: 18),
            const SizedBox(width: 8),
            Text(context.l10n.signalFeedTitle),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: signalAsync.when(
        loading: () => const _DetailSkeleton(),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.l10n.failedToLoadSignal, style: AppTextStyles.body),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(signalDetailProvider(signalId)),
                child: Text(context.l10n.retry),
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
      signal.isBuy ? AppColors.secondaryContainer : AppColors.error;

  Color get _statusColor {
    if (signal.isTpHit) return AppColors.secondaryContainer;
    if (signal.isSlHit) return AppColors.error;
    if (signal.isActive) return AppColors.primary;
    return AppColors.textMuted;
  }

  String _statusLabel(BuildContext context) {
    switch (signal.status) {
      case 'active':
        return context.l10n.statusActive;
      case 'tp_hit':
        return context.l10n.statusTpHit;
      case 'sl_hit':
        return context.l10n.statusSlHit;
      case 'closed':
        return context.l10n.statusClosed;
      default:
        return signal.status.toUpperCase();
    }
  }

  bool get _isBullish => signal.trend.toUpperCase().contains('BULL');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header — "XAUUSD — BUY" style sesuai Stitch
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: signal.symbol,
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: AppColors.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: '  —  ',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            TextSpan(
                              text: signal.direction,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: _directionColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _Badge(label: _statusLabel(context), color: _statusColor),
                  ],
                ),

                const SizedBox(height: 8),

                // Trend badge + timestamp
                Row(
                  children: [
                    if (signal.trend.isNotEmpty) ...[
                      Icon(
                        _isBullish ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: _isBullish
                            ? AppColors.secondaryContainer
                            : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      _Badge(
                        label: signal.trend.toUpperCase(),
                        color: _isBullish
                            ? AppColors.secondaryContainer
                            : AppColors.error,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(signal.createdAt, style: AppTextStyles.caption),
                  ],
                ),

                const SizedBox(height: 24),

                // Price Ladder visual
                PriceLadder(signal: signal, isPremium: isPremium),

                const SizedBox(height: 20),

                // Price grid: ENTRY1 | ENTRY2 / SL | TP / R:R | TREND
                if (isPremium) ...[
                  _PriceGrid(signal: signal),
                  const SizedBox(height: 16),
                ] else ...[
                  // Upgrade CTA kalau free
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
                                  context.l10n.unlockSignalDetail,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  context.l10n.upgradeToSeeDetail,
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        // EXECUTE SIGNAL sticky button di bottom
        if (isPremium && signal.isActive)
          _ExecuteSignalButton(signal: signal),
      ],
    );
  }
}

// ─── Price Grid 2×3 ──────────────────────────────────────────────────────────

class _PriceGrid extends StatelessWidget {
  final Signal signal;
  const _PriceGrid({required this.signal});

  int get _dec => signal.entry1 > 100 ? 2 : 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: ENTRY 1 | ENTRY 2
        Row(
          children: [
            Expanded(
              child: _PriceCell(
                label: context.l10n.entry1Label,
                value: signal.entry1.toStringAsFixed(_dec),
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PriceCell(
                label: context.l10n.entry2Label,
                value: signal.entry2 != null
                    ? signal.entry2!.toStringAsFixed(_dec)
                    : '—',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Row 2: STOP LOSS | TAKE PROFIT
        Row(
          children: [
            Expanded(
              child: _PriceCell(
                label: context.l10n.stopLossLabel,
                value: signal.sl.toStringAsFixed(_dec),
                color: AppColors.error,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PriceCell(
                label: context.l10n.takeProfitLabel,
                value: signal.tp != null
                    ? signal.tp!.toStringAsFixed(_dec)
                    : '—',
                color: AppColors.secondaryContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Row 3: RISK/REWARD | TREND STRENGTH
        Row(
          children: [
            Expanded(
              child: _PriceCell(
                label: context.l10n.riskRewardLabel,
                value: signal.riskReward != null
                    ? '1 : ${signal.riskReward!.toStringAsFixed(1)}'
                    : '—',
                color: AppColors.tertiary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TrendStrengthCell(trend: signal.trend),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _PriceCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendStrengthCell extends StatelessWidget {
  final String trend;
  const _TrendStrengthCell({required this.trend});

  bool get _isBullish => trend.toUpperCase().contains('BULL');
  Color get _color =>
      _isBullish ? AppColors.secondaryContainer : AppColors.error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.trendStrengthLabel,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          if (trend.isEmpty)
            Text('—',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 16,
                  color: AppColors.textMuted,
                ))
          else
            Row(
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Container(
                  width: 18,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _color.withValues(alpha: i == 2 ? 0.4 : 1.0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              )),
            ),
        ],
      ),
    );
  }
}

// ─── Execute Signal Button ────────────────────────────────────────────────────

class _ExecuteSignalButton extends StatelessWidget {
  final Signal signal;
  const _ExecuteSignalButton({required this.signal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.bolt, color: AppColors.onPrimary, size: 20),
          label: Text(
            context.l10n.executeSignal,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onPrimary,
              letterSpacing: 1.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Badge ────────────────────────────────────────────────────────────────────

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
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Skeleton ─────────────────────────────────────────────────────────────────

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 200, height: 40),
          const SizedBox(height: 24),
          _SkeletonBox(width: double.infinity, height: 220),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _SkeletonBox(width: double.infinity, height: 70)),
              const SizedBox(width: 8),
              Expanded(child: _SkeletonBox(width: double.infinity, height: 70)),
            ],
          ),
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
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
