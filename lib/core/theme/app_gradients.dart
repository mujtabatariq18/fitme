import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Brand gradients used across buttons, headers and hero surfaces.
class AppGradients {
  AppGradients._();

  /// Primary pink → magenta. The signature FitMe gradient.
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.pinkBright, AppColors.magenta],
  );

  /// Vertical variant for full-bleed headers.
  static const LinearGradient brandVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.pink, AppColors.deepMagenta],
  );

  /// Blue progress/tracking surfaces.
  static const LinearGradient progress = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.blue, AppColors.blueDark],
  );

  /// Subtle pink wash for screen backgrounds (light).
  static const LinearGradient backgroundWash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.pinkBg, AppColors.white],
  );
}
