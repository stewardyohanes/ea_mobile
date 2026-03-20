import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RiskSlider extends StatelessWidget {
  final double value;
  final Color riskColor;
  final String riskLabel;
  final ValueChanged<double> onChanged;

  const RiskSlider({
    required this.value,
    required this.riskColor,
    required this.riskLabel,
    required this.onChanged,
    super.key,
  });

  static const List<String> presets = ['0.5%', '1%', '2%', '3%', '5%'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: riskColor,
            inactiveTrackColor: riskColor.withValues(alpha: 0.2),
            thumbColor: riskColor,
            overlayColor: riskColor.withValues(alpha: 0.1),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0.5,
            max: 10,
            divisions: 19,
            onChanged: onChanged,
          ),
        ),

        Row(
          children: [
            Text('0.5%', style: AppTextStyles.caption),
            const Spacer(),
            Text(
              '${value.toStringAsFixed(1)}%',
              style: AppTextStyles.h3.copyWith(color: riskColor),
            ),
            const Spacer(),
            Text('10%', style: AppTextStyles.caption),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: presets.map((r) {
            final val = double.parse(r.replaceAll('%', ''));
            final isActive = value == val;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onChanged(val);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? riskColor : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    r,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: isActive ? Colors.white : AppColors.textMuted,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
