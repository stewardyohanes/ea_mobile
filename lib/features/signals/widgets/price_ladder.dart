import 'package:flutter/material.dart';
import '../models/signal_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PriceLadder extends StatelessWidget {
  final Signal signal;
  final bool isPremium;

  const PriceLadder({required this.signal, required this.isPremium, super.key});

  List<_PriceLevel> get _levels {
    final levels = <_PriceLevel>[];

    if (signal.isBuy) {
      // BUY: TP di atas, SL di bawah
      if (signal.tp != null) {
        levels.add(_PriceLevel(
          label: 'Take Profit',
          value: signal.tp!,
          color: AppColors.success,
          type: _LevelType.tp,
        ));
      }
      if (signal.entry2 != null) {
        levels.add(_PriceLevel(
          label: 'Entry 2',
          value: signal.entry2!,
          color: AppColors.primary,
          type: _LevelType.entry,
        ));
      }
      levels.add(_PriceLevel(
        label: 'Entry 1',
        value: signal.entry1,
        color: AppColors.primary,
        type: _LevelType.entry,
      ));
      levels.add(_PriceLevel(
        label: 'Stop Loss',
        value: signal.sl,
        color: AppColors.error,
        type: _LevelType.sl,
      ));
    } else {
      // SELL: SL di atas, TP di bawah
      levels.add(_PriceLevel(
        label: 'Stop Loss',
        value: signal.sl,
        color: AppColors.error,
        type: _LevelType.sl,
      ));
      if (signal.entry2 != null) {
        levels.add(_PriceLevel(
          label: 'Entry 2',
          value: signal.entry2!,
          color: AppColors.primary,
          type: _LevelType.entry,
        ));
      }
      levels.add(_PriceLevel(
        label: 'Entry 1',
        value: signal.entry1,
        color: AppColors.primary,
        type: _LevelType.entry,
      ));
      if (signal.tp != null) {
        levels.add(_PriceLevel(
          label: 'Take Profit',
          value: signal.tp!,
          color: AppColors.success,
          type: _LevelType.tp,
        ));
      }
    }

    return levels;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: _levels.asMap().entries.map((entry) {
          final index = entry.key;
          final level = entry.value;
          final isLast = index == _levels.length - 1;

          return _PriceLevelRow(
            level: level,
            isLast: isLast,
            isPremium: isPremium,
          );
        }).toList(),
      ),
    );
  }
}

enum _LevelType { tp, entry, sl }

class _PriceLevel {
  final String label;
  final double value;
  final Color color;
  final _LevelType type;

  const _PriceLevel({
    required this.label,
    required this.value,
    required this.color,
    required this.type,
  });
}

class _PriceLevelRow extends StatelessWidget {
  final _PriceLevel level;
  final bool isLast;
  final bool isPremium;

  const _PriceLevelRow({
    required this.level,
    required this.isLast,
    required this.isPremium,
  });

  bool get _isLocked => !isPremium && level.type != _LevelType.entry;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Connector line + dot
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: 2,
                      color: level.color.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: level.color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: isLast
                        ? const SizedBox.shrink()
                        : Container(
                            width: 2,
                            color: level.color.withValues(alpha: 0.3),
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Label + Value
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text(
                    level.label,
                    style: AppTextStyles.label.copyWith(color: level.color),
                  ),
                  const Spacer(),
                  _isLocked
                      ? Row(
                          children: [
                            const Icon(
                              Icons.lock,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '••••••',
                              style: AppTextStyles.price.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          level.value.toStringAsFixed(
                            level.value > 100 ? 2 : 5,
                          ),
                          style: AppTextStyles.price.copyWith(
                            color: level.color,
                          ),
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
