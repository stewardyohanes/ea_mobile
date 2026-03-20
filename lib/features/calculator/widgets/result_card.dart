import 'package:flutter/material.dart';
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: lotSize != null
              ? riskColor.withValues(alpha: 0.3)
              : AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          Text('Recommended Lot Size', style: AppTextStyles.caption),
          const SizedBox(height: 8),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              lotSize != null ? lotSize!.toStringAsFixed(2) : '—',
              key: ValueKey(lotSize?.toStringAsFixed(2)),
              style: TextStyle(
                color: lotSize != null ? riskColor : AppColors.textMuted,
                fontSize: 56,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),

          Text(
            'lots',
            style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
          ),

          const SizedBox(height: 20),

          // Risk meter bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (riskPercent / 10).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceVariant,
              color: riskColor,
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: riskColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                riskLabel,
                style: AppTextStyles.caption.copyWith(color: riskColor),
              ),
            ],
          ),

          if (riskAmount != null) ...[
            const SizedBox(height: 16),
            Divider(color: AppColors.divider.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Risk Amount',
                    value: '\$${riskAmount!.toStringAsFixed(2)}',
                    color: AppColors.error,
                  ),
                ),
                Container(width: 1, height: 32, color: AppColors.divider),
                Expanded(
                  child: _StatItem(
                    label: 'Pair',
                    value: pair,
                    color: AppColors.primary,
                  ),
                ),
                Container(width: 1, height: 32, color: AppColors.divider),
                Expanded(
                  child: _StatItem(
                    label: 'Risk %',
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            value,
            key: ValueKey(value),
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
