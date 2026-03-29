import 'package:flutter/material.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class FilterTabBar extends StatelessWidget {
  final String activeFilter; // 'ALL' | 'TP HIT' | 'SL HIT'
  final ValueChanged<String> onFilterChanged;

  const FilterTabBar({
    required this.activeFilter,
    required this.onFilterChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filters = [
      ('ALL', l10n.filterAll),
      ('TP HIT', l10n.filterTpHit),
      ('SL HIT', l10n.filterSlHit),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: filters.map<Widget>(((String, String) entry) {
          final (key, label) = entry;
          final isActive = activeFilter == key;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.card : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label.copyWith(
                    color: isActive ? AppColors.textPrimary : AppColors.textMuted,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
