import 'package:flutter/material.dart';

/// Color tokens di-extract langsung dari Stitch design system.
/// Menggunakan Material Design 3 dark scheme.
class AppColors {
  AppColors._();

  // === Background & Surface ===
  static const Color background = Color(0xFF0B1421);
  static const Color surfaceContainerLowest = Color(0xFF060E1B);
  static const Color surfaceContainerLow = Color(0xFF131C29);
  static const Color surfaceContainer = Color(0xFF18202E);
  static const Color surfaceContainerHigh = Color(0xFF222A38);
  static const Color surfaceContainerHighest = Color(0xFF2D3544);
  static const Color surfaceBright = Color(0xFF313948);

  // === Text ===
  static const Color onBackground = Color(0xFFDAE3F6);
  static const Color onSurface = Color(0xFFDAE3F6);
  static const Color onSurfaceVariant = Color(0xFFC2C6D7);

  // === Outline ===
  static const Color outline = Color(0xFF8C90A0);
  static const Color outlineVariant = Color(0xFF424655);

  // === Primary (light blue) ===
  static const Color primary = Color(0xFFB0C6FF);
  static const Color primaryContainer = Color(0xFF558DFF);
  static const Color onPrimary = Color(0xFF002D6E);
  static const Color onPrimaryContainer = Color(0xFF002661);
  static const Color inversePrimary = Color(0xFF0058CA);

  // === Secondary (green/success) ===
  static const Color secondary = Color(0xFF6CFFBF);
  static const Color secondaryContainer = Color(0xFF00E5A0);
  static const Color onSecondary = Color(0xFF003824);
  static const Color onSecondaryContainer = Color(0xFF006141);

  // === Tertiary (gold/amber) ===
  static const Color tertiary = Color(0xFFFFBA20);
  static const Color tertiaryContainer = Color(0xFFBC8700);
  static const Color onTertiary = Color(0xFF412D00);
  static const Color onTertiaryContainer = Color(0xFF392600);

  // === Error ===
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // === Inverse ===
  static const Color inverseSurface = Color(0xFFDAE3F6);
  static const Color inverseOnSurface = Color(0xFF28313F);

  // === Aliases (kompatibilitas dengan kode lama) ===
  static const Color surface = surfaceContainer;
  static const Color card = surfaceContainer;
  static const Color cardAlt = surfaceContainerHigh;
  static const Color surfaceVariant = surfaceContainerHighest;
  static const Color textPrimary = onBackground;
  static const Color textMuted = onSurfaceVariant;
  static const Color success = secondaryContainer;
  static const Color gold = tertiary;
  static const Color orange = tertiaryContainer;
  static const Color purple = Color(0xFF7C4DFF);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color divider = outlineVariant;
  static const Color transparent = Colors.transparent;
}
