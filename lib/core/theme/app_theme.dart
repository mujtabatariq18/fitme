import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Convenience accessor for FitMe semantic tokens: `context.fit.surface`.
extension FitThemeX on BuildContext {
  FitColors get fit => Theme.of(this).extension<FitColors>()!;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light, FitColors.light);
  static ThemeData dark() => _build(Brightness.dark, FitColors.dark);

  static ThemeData _build(Brightness brightness, FitColors fit) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.pink,
      brightness: brightness,
      primary: AppColors.pink,
      surface: fit.surface,
    );

    final textTheme = AppType.textTheme(fit.textPrimary, fit.textSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: fit.background,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      extensions: [fit],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: fit.textPrimary,
        titleTextStyle: textTheme.titleLarge,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: fit.surface,
        shape: const RoundedRectangleBorder(borderRadius: Radii.sheetRadius),
        showDragHandle: true,
      ),
      dividerTheme: DividerThemeData(color: fit.border, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: fit.textSecondary),
    );
  }
}
