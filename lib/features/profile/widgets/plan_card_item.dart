import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PlanCardItem extends StatelessWidget {
  final String name;
  final String price;
  final String period;
  final Color color;
  final List<String> features;
  final List<String> lockedFeatures;
  final bool isPopular;
  final VoidCallback onTap;
  final String buttonLabel;

  const PlanCardItem({
    required this.name,
    required this.price,
    required this.period,
    required this.color,
    required this.features,
    required this.lockedFeatures,
    required this.onTap,
    required this.buttonLabel,
    this.isPopular = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPopular ? color : AppColors.divider,
              width: isPopular ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(name, style: AppTextStyles.h3.copyWith(color: color)),
                  const Spacer(),
                  Text(
                    price,
                    style: TextStyle(
                      color: color,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(period, style: AppTextStyles.caption),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 16),

              // Features (unlocked)
              ...features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: color, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(f, style: AppTextStyles.bodySmall)),
                    ],
                  ),
                ),
              ),

              // Features (locked) — hanya tampil di Free
              ...lockedFeatures.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cancel,
                        color: AppColors.error,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          f,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    buttonLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (isPopular)
          Positioned(
            top: -12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '⭐ MOST POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
