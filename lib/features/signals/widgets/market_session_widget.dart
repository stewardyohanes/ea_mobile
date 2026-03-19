import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MarketSessionWidget extends StatelessWidget {
  const MarketSessionWidget({super.key});

  String get _activeSession {
    final hour = DateTime.now().toUtc().hour;
    if (hour >= 7 && hour < 16) return 'London';
    if (hour >= 12 && hour < 21) return 'New York';
    if (hour >= 21 || hour < 6) return 'Sydney';
    return 'Tokyo';
  }

  Color get _sessionColor {
    switch (_activeSession) {
      case 'London':
        return AppColors.primary;
      case 'New York':
        return AppColors.success;
      case 'Sydney':
        return AppColors.gold;
      default:
        return AppColors.cyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _sessionColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          _PulseDot(color: _sessionColor),
          const SizedBox(width: 8),
          Text(
            '$_activeSession Session Active',
            style: AppTextStyles.label.copyWith(color: _sessionColor),
          ),
          const Spacer(),
          Text(
            'UTC ${DateTime.now().toUtc().hour.toString().padLeft(2, '0')}:${DateTime.now().toUtc().minute.toString().padLeft(2, '0')}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
