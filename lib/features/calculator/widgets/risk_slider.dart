import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Risk slider dengan gradient track (green→blue→orange→red)
/// + preset labels tappable di bawah slider
class RiskSlider extends StatelessWidget {
  final double value;
  final Color riskColor;
  final String riskLabel;
  final ValueChanged<double> onChanged;

  static const double _min = 0.5;
  static const double _max = 5.0;

  static const List<_RiskPreset> _presets = [
    _RiskPreset(label: 'Conservative', value: 1.0),
    _RiskPreset(label: 'Moderate', value: 2.0),
    _RiskPreset(label: 'Aggressive', value: 3.0),
    _RiskPreset(label: 'Extreme', value: 5.0),
  ];

  const RiskSlider({
    required this.value,
    required this.riskColor,
    required this.riskLabel,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Value display + risk badge
        Row(
          children: [
            Text(
              '${value.toStringAsFixed(1)}%',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: riskColor,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                riskLabel,
                style: AppTextStyles.caption.copyWith(
                  color: riskColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Gradient slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayColor: Colors.white.withValues(alpha: 0.15),
            trackShape: const _GradientTrackShape(),
          ),
          child: Slider(
            value: value,
            min: _min,
            max: _max,
            divisions: 45,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
          ),
        ),

        const SizedBox(height: 4),

        // Preset labels — tappable shortcuts
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _presets.map((preset) {
            final isActive = (value - preset.value).abs() < 0.6;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(preset.value);
              },
              child: Text(
                preset.label,
                style: AppTextStyles.caption.copyWith(
                  color:
                      isActive ? riskColor : AppColors.onSurfaceVariant,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Custom gradient track — full track always shows green→blue→orange→red
class _GradientTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const _GradientTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final paint = Paint()
      ..shader = LinearGradient(
        colors: const [
          Color(0xFF00E5A0), // green — Conservative
          Color(0xFFB0C6FF), // blue — Moderate
          Color(0xFFFFB420), // orange — Aggressive
          Color(0xFFFFB4AB), // red — Extreme
        ],
      ).createShader(trackRect);

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, const Radius.circular(4)),
      paint,
    );
  }
}

class _RiskPreset {
  final String label;
  final double value;
  const _RiskPreset({required this.label, required this.value});
}
