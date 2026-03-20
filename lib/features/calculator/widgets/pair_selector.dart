import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PairSelector extends StatelessWidget {
  final String selectedPair;
  final ValueChanged<String> onChanged;

  const PairSelector({
    required this.selectedPair,
    required this.onChanged,
    super.key,
  });

  static const List<Map<String, String>> pairs = [
    {'name': 'XAUUSD', 'icon': '🥇'},
    {'name': 'XAGUSD', 'icon': '🥈'},
    {'name': 'EURUSD', 'icon': '💶'},
    {'name': 'GBPUSD', 'icon': '💷'},
    {'name': 'USDJPY', 'icon': '💴'},
    {'name': 'AUDUSD', 'icon': '🦘'},
    {'name': 'USDCAD', 'icon': '🍁'},
    {'name': 'USDCHF', 'icon': '🇨🇭'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pairs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final pair = pairs[index];
          final isSelected = pair['name'] == selectedPair;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onChanged(pair['name']!);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Text(pair['icon']!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    pair['name']!,
                    style: AppTextStyles.label.copyWith(
                      color: isSelected ? Colors.white : AppColors.textMuted,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
