import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/signal_model.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HistoryCard extends StatelessWidget {
  final Signal signal;
  const HistoryCard({required this.signal, super.key});

  bool get _isWin => signal.isTpHit;
  Color get _statusColor => _isWin ? AppColors.secondaryContainer : AppColors.error;

  String _statusLabel(BuildContext context) =>
      _isWin ? context.l10n.statusTpHit : context.l10n.statusSlHit;

  double get _exitPrice => _isWin ? (signal.tp ?? signal.sl) : signal.sl;

  double get _pipsDiff {
    final diff = (_exitPrice - signal.entry1).abs();
    if (signal.symbol.contains('XAU') || signal.symbol.contains('XAG')) {
      return diff;
    }
    return diff * 10000;
  }

  String get _formattedDate {
    try {
      final dt = DateTime.parse(signal.createdAt);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.year}.${months[dt.month - 1]}.${dt.day.toString().padLeft(2, '0')} · '
             '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return signal.createdAt;
    }
  }

  int get _decimalPlaces => signal.entry1 > 100 ? 2 : 5;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _statusColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _statusColor.withValues(alpha: 0.12),
                  border: Border.all(
                    color: _statusColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  _isWin ? Icons.trending_up : Icons.trending_down,
                  color: _statusColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(signal.symbol, style: AppTextStyles.h4),
                        const SizedBox(width: 8),
                        _DirectionBadge(
                          label: signal.direction,
                          color: signal.isBuy
                              ? AppColors.secondaryContainer
                              : AppColors.error,
                        ),
                        const SizedBox(width: 6),
                        _StatusBadge(label: _statusLabel(context), color: _statusColor),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(_formattedDate, style: AppTextStyles.caption),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_isWin ? '+' : '-'}${_pipsDiff.toStringAsFixed(1)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _statusColor,
                    ),
                  ),
                  Text(
                    l10n.pipsLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: _statusColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(
            color: AppColors.outlineVariant.withValues(alpha: 0.15),
            height: 1,
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _PriceCell(
                  label: l10n.entryShort,
                  value: signal.entry1.toStringAsFixed(_decimalPlaces),
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Container(width: 1, height: 28, color: AppColors.outlineVariant.withValues(alpha: 0.2)),
              Expanded(
                child: _PriceCell(
                  label: l10n.exitLabel,
                  value: _exitPrice.toStringAsFixed(_decimalPlaces),
                  color: _statusColor,
                ),
              ),
              Container(width: 1, height: 28, color: AppColors.outlineVariant.withValues(alpha: 0.2)),
              Expanded(
                child: _PriceCell(
                  label: l10n.rrLabel,
                  value: signal.riskReward != null
                      ? '1:${signal.riskReward!.toStringAsFixed(1)}'
                      : '—',
                  color: AppColors.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
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
    return Column(
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
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DirectionBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _DirectionBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
