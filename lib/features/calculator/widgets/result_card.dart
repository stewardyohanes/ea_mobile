import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ResultCard extends StatelessWidget {
  final double? lotSize;
  final double? riskAmount;
  final double riskPercent;
  final Color riskColor;
  final String riskLabel;
  final String pair;

  const ResultCard({
    required this.lotSize,
    required this.riskAmount,
    required this.riskPercent,
    required this.riskColor,
    required this.riskLabel,
    required this.pair,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: lotSize != null
              ? riskColor.withValues(alpha: 0.25)
              : AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          // Label
          Text(
            context.l10n.recommendedPositionSize,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),

          // Lot size number + badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  lotSize != null ? lotSize!.toStringAsFixed(2) : '—',
                  key: ValueKey(lotSize?.toStringAsFixed(2)),
                  style: GoogleFonts.jetBrainsMono(
                    color: lotSize != null ? riskColor : AppColors.textMuted,
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.lotsUnit,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.outline,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Risk label badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: riskColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        riskLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: riskColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (riskAmount != null) ...[
            const SizedBox(height: 16),
            // RISK AMOUNT | RISK LEVEL — dua kotak grid
            Row(
              children: [
                Expanded(
                  child: _MetricBox(
                    label: context.l10n.riskAmount,
                    value: '\$${riskAmount!.toStringAsFixed(2)}',
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricBox(
                    label: context.l10n.riskLevel,
                    value: '${riskPercent.toStringAsFixed(1)}%',
                    color: riskColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
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
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              value,
              key: ValueKey(value),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
