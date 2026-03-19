import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SkeletonBox(width: 80, height: 18),
              const SizedBox(width: 8),
              _SkeletonBox(width: 44, height: 18),
              const Spacer(),
              _SkeletonBox(width: 60, height: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _SkeletonBox(width: 60, height: 14),
              const SizedBox(width: 16),
              _SkeletonBox(width: 60, height: 14),
              const SizedBox(width: 16),
              _SkeletonBox(width: 60, height: 14),
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
        color: AppColors.cardAlt,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
