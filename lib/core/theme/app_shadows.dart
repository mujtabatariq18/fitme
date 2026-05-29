import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Soft, layered shadows for the "floating card" look in the references.
class Shadows {
  Shadows._();

  static List<BoxShadow> card(Color tint) => [
        BoxShadow(
          color: tint.withValues(alpha: 0.06),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: tint.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// Colored glow under brand buttons (e.g. the blue "Add weight" CTA).
  static List<BoxShadow> glow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.35),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> ringNode = [
    BoxShadow(
      color: AppColors.white.withValues(alpha: 0.9),
      blurRadius: 12,
      spreadRadius: 1,
    ),
  ];
}
